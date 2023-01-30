call plug#begin(g:home.'/plugged')

" --themes-- "
Plug 'ayu-theme/ayu-vim', {'on': [], 'dir': g:home..'/theme/ayu-vim'}

" --tools-- "
Plug 'tpope/surround', {'on': [], 'dir': g:home..'/surround'}
Plug 'lilydjwg/fcitx.vim', {'on': []}
Plug 'SirVer/ultisnips', {'on': []}
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'tpope/vim-commentary'
Plug 'itchyny/vim-gitbranch'
Plug 'Shougo/neco-vim', {'for': 'vim'}
Plug 'Yggdroot/LeaderF', {'on': ['Leaderf', 'LeaderfBufTagCword']}
Plug 'ianva/vim-youdao-translater', {'on': ['Ydc', 'Ydv', 'Yde']}
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app && yarn install'}
Plug g:home..'/lighttree2', {'on': []}
if has('nvim')
    Plug 'windwp/nvim-autopairs', {'on': []}
endif
"lsp
Plug 'yegappan/lsp', {'on': []}
Plug 'neoclide/coc.nvim', {'on': [], 'branch': 'release'}
" -coc- "
if g:complete_frame == 'coc'
    Plug 'neoclide/coc-neco', {'for': 'vim'}
endif

" --others-- "
if g:use_vimtex
    Plug 'lervag/vimtex', {'for': 'tex'}
endif

call plug#end()
