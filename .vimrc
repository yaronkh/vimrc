" Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
"Plug 'ctrlpvim/ctrlp.vim'
"Plug 'justmao945/vim-clang'
"Plug 'chazy/cscope_maps'
Plug 'wesleyche/SrcExpl'
Plug 'vim-scripts/taglist.vim'
Plug 'scrooloose/nerdtree'
Plug 'wesleyche/Trinity'
Plug 'vim-scripts/OmniCppComplete'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'rdolgushin/snipMate-acp'
Plug 'vim-scripts/AutoComplPop'
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/a.vim'
Plug 'ervandew/supertab'
Plug 'vim-airline/vim-airline'
Plug 'skywind3000/asyncrun.vim'
Plug 'justinmk/vim-sneak'
Plug 'brandonbloom/csearch.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'terryma/vim-multiple-cursors'
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/TagHighlight'
Plug 'erig0/cscope_dynamic'
Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

" Generation Parameters
let g:ctagsFilePatterns = '\.c$|\.cc$|\.cpp$|\.cxx$|\.h$|\.hh$|\.hpp$'
let g:ctagsOptions = '--languages=C,C++ --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --tag-relative'
let g:ctagsEverythingOptions = '--c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --tag-relative'

" Install
function! ZInstall()
    copen
    exec ":AsyncRun sudo apt install silversearcher-ag exuberant-ctags cscope global codesearch -y
    \ & sed -i 's/ autochdir/ noautochdir/' ~/.vim/plugged/SrcExpl/plugin/srcexpl.vim
    \ & sed -i 's/silent execute \"perl/silent execute \"!perl/' ~/.vim/plugged/cscope_dynamic/plugin/cscope_dynamic.vim 
    \ & sed -i 's@ . redraw!@\ . \" > /dev/null\"@' ~/.vim/plugged/cscope_dynamic/plugin/cscope_dynamic.vim
    \ & sed -i \"s/'String',[ \\t]*s\\:green/'String', \\['\\#d78787', 174\\]/\" ~/.vim/plugged/gruvbox/colors/gruvbox.vim"
endfunction

" Generate All
function! ZGenerateAll()
    copen
    exec ":AsyncRun ctags -R " . g:ctagsOptions . " && echo '" . g:ctagsOptions . "' > .gutctags && sed -i 's/ /\\n/g' .gutctags && ag -l -g '" . g:ctagsFilePatterns . "' > cscope.files && cscope -bq && cindex . && gtags"
endfunction

" Generate All
function! ZGenerateEverything()
    copen
    exec ":AsyncRun ctags -R " . g:ctagsEverythingOptions . " && echo '" . g:ctagsEverythingOptions . "' > .gutctags && sed -i 's/ /\\n/g' .gutctags && ag -l > cscope.files && cscope -bq && cindex . && gtags"
endfunction

" Write tags options.
function! ZWriteTagsOptions()
    copen
    exec ":AsyncRun echo " . g:ctagsOptions . " > .gutctags && sed -i 's/ /\\n/g' .gutctags"
endfunction

" Generate Tags
function! ZGenTags()
    copen
    exec ":AsyncRun ctags -R " . g:ctagsOptions
endfunction

" Generate Cscope Files
function! ZGenCsFiles()
    copen
    exec ":AsyncRun ag -l -g '" . g:ctagsFilePatterns . "' > cscope.files"
endfunction

" Generate Tags and Cscope Files
function! ZGenTagsAndCsFiles()
    copen
    exec ":AsyncRun ag -l -g '" . g:ctagsFilePatterns . "' > cscope.files && ctags -R " . g:ctagsOptions
endfunction

" Install Mapping
nnoremap <leader>zi :call ZInstall()<CR>

" Generate All Mapping
nnoremap <leader>zg :call ZGenerateAll()<CR>
nnoremap <leader>zG :call ZGenerateEverything()<CR>

" Generate Tags and Cscope Files Mapping
nnoremap <leader>zt :call ZGenTagsAndCsFiles()<CR>

" Codesearch
nnoremap <leader>zx "tyiw:exe "CSearch " . @t . ""<CR>

" VimClang
let g:clang_c_options = '-std=c11'
let g:clang_cpp_options = '-std=c++17 -stdlib=libc++'

let g:vimroot=$PWD
function! ZSwitchToRoot()
    execute "cd " . g:vimroot 
endfunction
nnoremap <leader>zr :call ZSwitchToRoot()<CR>

" Trinity
"nnoremap <C-L> :TrinityToggleNERDTree<CR>:TrinityToggleTagList<CR>
nnoremap <leader>zs :TrinityToggleSourceExplorer<CR>
nnoremap <C-w>e :TrinityUpdateWindow<CR>

" NERDTree and TagBar
let g:NERDTreeWinSize = 23
let g:NERDTreeAutoCenter = 0
let g:tagbar_width=23
nnoremap <C-L> :NERDTreeToggle<CR>:wincmd w<CR>:TagbarToggle<CR>

" Ctrlp
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

" Omni
"au BufNewFile,BufRead,BufEnter *.cpp,*.hpp,*.c,*.h,*.cxx,*.cc,*.hh set omnifunc=omni#cpp#complete#Main
let g:acp_behaviorSnipmateLength = 1

" GutenTags
let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_plus_nomap = 1
noremap <silent> <leader>gs :GscopeFind s <C-R><C-W><cr>
noremap <silent> <leader>gg :GscopeFind g <C-R><C-W><cr>
noremap <silent> <leader>gc :GscopeFind c <C-R><C-W><cr>
noremap <silent> <leader>gt :GscopeFind t <C-R><C-W><cr>
noremap <silent> <leader>ge :GscopeFind e <C-R><C-W><cr>
noremap <silent> <leader>gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <leader>gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <leader>gd :GscopeFind d <C-R><C-W><cr>
noremap <silent> <leader>ga :GscopeFind a <C-R><C-W><cr>

" Fzf
let $FZF_DEFAULT_COMMAND = "if [ -f cscope.files ]; then cat cscope.files; else ag -l; fi"
set rtp+=~/.fzf
nnoremap <C-p> :call ZSwitchToRoot()<CR>:Files<CR>
nnoremap <C-n> :call ZSwitchToRoot()<CR>:Tags<CR>

" Sneak
let g:sneak#use_ic_scs = 1
let g:sneak#s_next = 1

" Cscope
let g:cscopedb_big_file = 'cscope.out'
let g:cscopedb_small_file = 'cscope_small.out'
let g:cscopedb_auto_files = 0

" Multi Cursor
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_word_key      = '<C-k>'
"let g:multi_cursor_select_all_word_key = '<A-k>'
let g:multi_cursor_start_key           = 'g<C-k>'
"let g:multi_cursor_select_all_key      = 'g<A-k>'
let g:multi_cursor_next_key            = '<C-k>'
let g:multi_cursor_prev_key            = '<C-e>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" Cpp Highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1

" QuickFix
nnoremap <C-w>p :copen<CR>

" Generic
syntax on
filetype plugin indent on
nnoremap ` :noh<CR>
set expandtab
set ignorecase
set smartcase
set nocompatible
set shellslash
set autoindent
autocmd filetype cpp setlocal cindent
autocmd filetype c setlocal cindent
set cinoptions=g0N-s
set backspace=indent,eol,start
set ruler
set showcmd
set incsearch
set hlsearch
color desert
set shiftwidth=4
set tabstop=4
set cmdheight=1
set number
set wildmode=list:longest,full
set completeopt=longest,menuone
set nowrap
nnoremap <C-q> <C-v>
set shellslash
map <C-w>w :q<CR>
autocmd filetype make setlocal noexpandtab autoindent
noremap <F1> <C-w><C-p>
noremap <F2> <C-w><C-w>
noremap <F6> :bp<CR>
noremap <F7> :bn<CR>
noremap <F5> :set nu!<CR>:set paste!<CR>i
set noerrorbells visualbell t_vb=

" Extensions
function! Cscope(option, query, ...)
  let a:ignorecase = get(a:, 1, 0)
  if a:ignorecase
    let realoption = "C" . a:option
  else
    let realoption = a:option
  endif

  let color = '{ x = $1; $1 = ""; z = $3; $3 = ""; printf "\033[36m%s\033[0m:\033[36m%s\033[0m\011\033[37m%s\033[0m\n", x,z,$0; }'
  let opts = {
  \ 'source':  "cscope -dL" . realoption . " " . a:query . " | awk '" . color . "' && cscope -f cscope_small.out -dL" . realoption . " " . a:query . " | awk '" . color . "'",
  \ 'options': ['--ansi', '--prompt', '> ',
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104'],
  \ 'down': '40%'
  \ }

  function! opts.sink(lines) 
    let data = split(a:lines)
    let file = split(data[0], ":")
    execute 'e ' . '+' . file[1] . ' ' . file[0]
  endfunction
  call fzf#run(opts)
endfunction

function! CscopeQuery(option, ...)
  call inputsave()
  if a:option == '9'
    let query = input('Assignments to: ')
  elseif a:option == '3'
    let query = input('Functions calling: ')
  elseif a:option == '2'
    let query = input('Functions called by: ')
  elseif a:option == '6'
    let query = input('Egrep: ')
  elseif a:option == '7'
    let query = input('File: ')
  elseif a:option == '1'
    let query = input('Definition: ')
  elseif a:option == '8'
    let query = input('Files #including: ')
  elseif a:option == '0'
    let query = input('C Symbol: ')
  elseif a:option == '4'
    let query = input('Text: ')
  else
    echo "Invalid option!"
    return
  endif
  call inputrestore()
  if query != ""
    let a:ignorecase = get(a:, 1, 0)
    if a:ignorecase
      call Cscope(a:option, query, 1)
    else
      call Cscope(a:option, query)
    endif
  else
    echom "Cancelled Search!"
  endif
endfunction

nnoremap <silent> <Leader>ca :call Cscope('9', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cc :call Cscope('3', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cd :call Cscope('2', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ce :call Cscope('6', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cf :call Cscope('7', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cg :call Cscope('1', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ci :call Cscope('8', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cs :call Cscope('0', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ct :call Cscope('4', expand('<cword>'))<CR>

nnoremap <silent> <Leader><Leader>fa :call CscopeQuery('9')<CR>
nnoremap <silent> <Leader><Leader>fc :call CscopeQuery('3')<CR>
nnoremap <silent> <Leader><Leader>fd :call CscopeQuery('2')<CR>
nnoremap <silent> <Leader><Leader>fe :call CscopeQuery('6')<CR>
nnoremap <silent> <Leader><Leader>ff :call CscopeQuery('7')<CR>
nnoremap <silent> <Leader><Leader>fg :call CscopeQuery('1')<CR>
nnoremap <silent> <Leader><Leader>fi :call CscopeQuery('8')<CR>
nnoremap <silent> <Leader><Leader>fs :call CscopeQuery('0')<CR>
nnoremap <silent> <Leader><Leader>ct :call CscopeQuery('4')<CR>

nnoremap <silent> <Leader><Leader>ca :call CscopeQuery('9', 1)<CR>
nnoremap <silent> <Leader><Leader>cc :call CscopeQuery('3', 1)<CR>
nnoremap <silent> <Leader><Leader>cd :call CscopeQuery('2', 1)<CR>
nnoremap <silent> <Leader><Leader>ce :call CscopeQuery('6', 1)<CR>
nnoremap <silent> <Leader><Leader>cf :call CscopeQuery('7', 1)<CR>
nnoremap <silent> <Leader><Leader>cg :call CscopeQuery('1', 1)<CR>
nnoremap <silent> <Leader><Leader>ci :call CscopeQuery('8', 1)<CR>
nnoremap <silent> <Leader><Leader>cs :call CscopeQuery('0', 1)<CR>
nnoremap <silent> <Leader><Leader>ct :call CscopeQuery('4', 1)<CR>

" Gruvbox
set background=dark
let g:gruvbox_contrast_datk = 'medium'
color gruvbox
hi Normal ctermbg=none
