""" VALUES """
""""""""""""""
let g:home = "~/.vim"
let g:appearance_load = 0
let g:fcitx_load = 0
let g:nu_load = 0
let g:mapleader = "\<Space>"
let g:snips_frame = 'ultisnips'
let g:complete_frame = 'coc'
let g:tree_frame = 'fern'
let g:autopairs = 'nvim-autopairs'
"let g:color_set = 'delek'
let g:color_set = 'ayu'
let g:root_pattern = ['.git', '.root', '.vimproject']

let g:terminal_height = 12

" --special-- "
let g:gutentags_define_advanced_commands = 1
let g:coc_language_extensions = 1
let g:use_vimtex = 1
let g:use_surround = 0
let g:insert_entered = 0
let g:bufreaded = 0

if has('nvim')
    if g:complete_frame == 'lsp'
        let g:complete_frame = 'coc'
    endif
else
    let nvim_autopair_frames = ['nvim-autopairs', 'coc-pairs']
    if index(nvim_autopair_frames, g:autopairs) >= 0
        let g:autopairs = 'autopairs'
    endif
    if g:complete_frame == 'cmp'
        let g:complete_frame = 'lsp'
    endif
endif

if g:complete_frame == 'coc'
    if has('nvim') && g:autopairs == 'autopairs'
        let g:autopairs = 'coc-pairs'
    endif
endif


""" PLUGINS """
"""""""""""""""
exec 'source '.g:home.'/pluglist.vim'
call plugin#basic_setup()
au Filetype tex call plugin#vimtex_setup()

" --lsp-- "
"settings are in function plugin#lsp_init()


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

"gui front settings
set guifont=Consolas:h11
if exists('g:neovide')
    let g:neovide_cursor_trail_size = 0.0
endif

"python
let g:python3_host_prog = '/usr/bin/python3'
let g:python2_host_prog = '/usr/bin/python3'



""" APPEARANCE """
""""""""""""""""""
" --enable some plugins after vim entering-- "
" containing loading appearance
"autocmd FileReadPost * call event#on_ui_enter()
call event#on_ui_enter()
