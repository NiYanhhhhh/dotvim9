""" VALUES """
""""""""""""""
let g:home = "~/.vim"
let g:appearance_load = 0
let g:fcitx_load = 0
let g:nu_load = 0
let g:mapleader = "\<Space>"
let g:snips_frame = 'ultisnips'
let g:complete_frame = 'coc'
let g:tree_frame = 'netwr'
let g:color_set = 'delek'
let g:root_pattern = ['.root', '.vimproject']

let g:terminal_height = 12

let g:gutentags_define_advanced_commands = 1

" --special-- "
let g:vimtex_loaded = 0 "set to 1 to disable vimtex

""" PLUGINS """
"""""""""""""""
exec 'source '.g:home.'/pluglist.vim'
call plugin#basic_setup()
au Filetype tex call plugin#vimtex_setup()

" --lsp-- "
if g:complete_frame == 'lsp'
    let lsp_opt = {
                \   "showInlayHints": v:true,
                \   "usePopupInCodeAction": v:true,
                \   "showSignature": v:false
                \ }
    call plug#load('lsp')
    call lsp#LspSetup()
    call LspOptionsSet(lsp_opt)
elseif g:complete_frame == 'coc'
    call plug#load('coc.nvim')
    call coc#Setup()
endif

"my own plugins
call autopair#Init()


""" KEYMAPS """
"""""""""""""""
" using file plugin/keymaps.vim


""" BASE SETTINGS """
"""""""""""""""""""""
" --base-- "
set helplang=cn
set nocompatible
filetype on
filetype plugin on
filetype plugin indent on
" set autochdir
set nobackup
set noswapfile
set history=1024
set nobomb
set whichwrap=b,s,<,>,[,],h,l
set backspace=2
set clipboard+=unnamed
set backspace=indent,eol,start
" set lazyredraw
set updatetime=200
set hidden
set complete=.,w,b,u,i,k

" --encoding-- "
set encoding=utf-8
set termencoding=utf-8
set fencs=utf-8
let $lang = 'en_us.utf-8'

" --intent settings-- "
set expandtab
set smartindent
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
"
set cinoptions=g=
"

" --gui & terminal-- "
if has('termguicolors')
    set termguicolors
endif
syntax on
set wildmenu
set laststatus=2
set showtabline=2
set noshowmode
set splitright
set splitbelow
set hlsearch
set incsearch
set ignorecase
set smartcase
set cursorline
" set cursorcolumn
set ruler
set scrolloff=3
set sidescrolloff=7
set showcmd
set showtabline=1
set mouse=a

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"



""" APPEARANCE """
""""""""""""""""""
" --enable some plugins after vim entering-- "
" containing loading appearance
"autocmd FileReadPost * call event#on_ui_enter()
call event#on_ui_enter()
