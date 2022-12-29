call plug#begin(g:home.'/plugged')

" --themes-- "
Plug 'ayu-theme/ayu-vim', {'on': [], 'dir': g:home.'/theme/ayu-vim'}

" --tools-- "
Plug 'lilydjwg/fcitx.vim', {'on': []}
Plug 'SirVer/ultisnips', {'on': []}
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'tpope/vim-commentary'
Plug 'itchyny/vim-gitbranch'
Plug 'Shougo/neco-vim'
"lsp
Plug 'yegappan/lsp'

" --others-- "
if !g:vimtex_loaded
    Plug 'lervag/vimtex', {'for': 'tex'}
endif

call plug#end()
