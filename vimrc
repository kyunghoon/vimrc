:set mouse=

call plug#begin('~/.vim/plugged')

"Plug 'w0rp/ale'                                             " Async linting (need to setup tslint)
Plug 'scrooloose/nerdtree'                                  " File tree browser
"Plug 'Xuyuanp/nerdtree-git-plugin'                          " Git for NerdTree
"Plug 'jistr/vim-nerdtree-tabs'                              " NerdTree independent of tabs
Plug 'https://github.com/rhysd/vim-color-spring-night.git'
"Plug 'jacoborus/tender.vim'
"Plug 'rust-lang/rust.vim'                                   " Rust support
Plug 'https://github.com/kyunghoon/rust.vim.git'            " Cargo support
Plug 'https://github.com/vim-syntastic/syntastic'
Plug 'https://github.com/Quramy/tsuquyomi'
Plug 'https://github.com/leafgarland/typescript-vim'
"Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'mkitt/tabline.vim'                                    " Cleaner tabs
Plug 'https://github.com/keith/swift.vim.git'               " Swift support
Plug 'vim-airline/vim-airline'                              " Upgraded status line
"Plug 'https://github.com/Yggdroot/indentLine.git'           " Show tabs
Plug 'hjson/vim-hjson'
"Plug 'https://github.com/chivalry/filemaker.vim.git'
Plug 'https://github.com/neovimhaskell/haskell-vim.git'
Plug 'https://github.com/alx741/vim-hindent.git'
Plug 'https://github.com/dunedain289/vim-tup.git'
Plug 'https://github.com/yssl/QFEnter'

"function! SyntasticCheckHook(errors)
"  if !empty(a:errors)
"      windo if &buftype == "quickfix" || &buftype == "locationlist" | lclose | endif
"      let g:syntastic_loc_list_height = min([len(a:errors)+3, 10])
"  endif
"endfunction
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  let l = 1
  let n_lines = 0
  let w_width = winwidth(0)
  while l <= line('$')
    " number to float for division
    let l_len = strlen(getline(l)) + 0.0
    let line_width = l_len/w_width
    let n_lines += float2nr(ceil(line_width))
    let l += 1
  endw
  exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction

call plug#end()

" start nerdtree when opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" map nerd tree to <Ctrl-n>
map <C-n> :NERDTreeToggle<CR>
"map <C-n> :NERDTreeTabsToggle<CR>

" set colorscheme
colorscheme spring-night
"colorscheme tender

" tweak tabs
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" refactor typescript keybinding
autocmd FileType typescript nmap <buffer> <Leader>e <Plug>(TsuquyomiRenameSymbol)
autocmd FileType typescript nmap <buffer> <Leader>E <Plug>(TsuquyomiRenameSymbolC)
autocmd FileType typescript nmap <buffer> <Leader>q <Plug>(completeopt)

" tooltip for typescript
autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

" syntastic for typescript errors
let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.
let g:tsuquyomi_disable_quickfix = 1
let g:tsuquyomi_use_local_typescript = 0
let g:tsuquyomi_use_dev_node_module = 0

" shift-tab autocomplete
function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction
inoremap <s-tab> <c-r>=Smart_TabComplete()<CR>
set completeopt=longest,menuone

" recommended syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

" add top and bottom gutters
set scrolloff=5
set sidescrolloff=5

" set tmp for location
set backupdir=/tmp
set directory=/tmp
set undodir=/tmp

" fix backstapce
set backspace=indent,eol,start

" interpret .b files as scheme files
au BufNewFile,BufRead *.b set syntax=scheme

set nowrap

" disable indenting when typing the pound symbol in yml files
au BufNewFile,BufRead *.yml,*.yaml set indentexpr=[]

" enabled rust formatter
let g:rustfmt_autosave = 0

" enable cargo errors
let g:syntastic_rust_checkers = []
"let g:syntastic_rust_checkers = ['cargo']

" disable auto comment next line
autocmd BufNewFile,BufRead * setlocal formatoptions-=r

" disable nerdtree opening by default on macvim startup
let g:nerdtree_tabs_open_on_gui_startup=0

" disable bell
set visualbell t_vb=

" word wrap quickfix
augroup quickfix
  autocmd!
  autocmd FileType qf setlocal wrap
augroup END

map! <C-v>p ¶

au FileType qf wincmd J

"let g:syntastic_loc_list_height=5

let g:hindent_on_save = 1
let g:hindent_indent_size = 2
let g:hindent_line_length = 120
set autoindent
set nocindent
set smartindent

autocmd FileType cpp :setlocal sw=4 ts=4 sts=4
autocmd FileType h :setlocal sw=4 ts=4 sts=4

set ff=unix
