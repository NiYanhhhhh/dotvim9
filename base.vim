" base
set helplang=cn
set nocompatible
filetype on
filetype plugin on
filetype plugin indent on
set autochdir
set nobackup
set noswapfile
set history=1024
set nobomb
set whichwrap=b,s,<,>,[,],h,l
set backspace=2
set clipboard+=unnamed
set backspace=indent,eol,start
let mapleader=' '

"coding"
set encoding=utf-8
set termencoding=utf-8
set fencs=utf-8
let $lang = 'en_us.utf-8'
let g:python_host_prog='/usr/bin/python'
let g:python2_host_prog='/usr/bin/python2'

" intent settings"
set expandtab
set smartindent
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
au filetype python,java,vim set tabstop=4
au filetype python,java,vim set softtabstop=4
au filetype python,java,vim set shiftwidth=4
au filetype json set tabstop=2
au filetype json set softtabstop=2
au filetype json set shiftwidth=2

" appearance
colorscheme github
syntax on
autocmd bufread,bufnewfile *.c,*.h,*.cpp,*.java,*.py set expandtab
set splitright
set splitbelow
set hlsearch
set incsearch
set ignorecase
set smartcase
set cursorline
set cursorcolumn
set ruler
set number
set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
set scrolloff=3
set showmode
set showcmd
set mouse=a
