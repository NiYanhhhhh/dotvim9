call plug#begin(g:home.'/plugged')

" --themes-- "
Plug 'ayu-theme/ayu-vim', {'on': [], 'dir': g:home..'/theme/ayu-vim'}

" --tools-- "
"Plug 'tpope/surround', {'on': [], 'dir': g:home..'/surround'}
Plug 'lilydjwg/fcitx.vim', {'on': []}
Plug 'SirVer/ultisnips', {'on': []}
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'skywind3000/gutentags_plus'
Plug 'tpope/vim-commentary'
Plug 'itchyny/vim-gitbranch'
Plug 'Shougo/neco-vim', {'for': 'vim'}
Plug 'Yggdroot/LeaderF', {'on': ['Leaderf', 'LeaderfBufTagCword']}
Plug 'ianva/vim-youdao-translater', {'on': ['Ydc', 'Ydv', 'Yde']}
Plug 'iamcco/markdown-preview.nvim', {'for': 'markdown', 'do': 'cd app && yarn install'}
Plug 'mbledkowski/neuleetcode.vim', {'on': ['LeetCodeList', 'LeetCodeTest', 'LeetCodeSubmit', 'LeetCodeSignIn']}
if g:tree_frame == 'fern'
    Plug 'lambdalisue/fern.vim' , {'on': []}
    "Plug 'lambdalisue/fern-git-status.vim', {'on': []}
endif
"Plug g:home..'/lighttree2' , {'on': []}
"Plug g:home..'/lighttree-java', {'for': ['java'], 'on': []}
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
" -cmp- "
if g:complete_frame == 'cmp'
    Plug 'neovim/nvim-lspconfig', {'on': []}
    let g:cmp_plugins = ['nvim-cmp', 'cmp-nvim-lsp', 'cmp-buffer', 'cmp-path']
    if g:snips_frame == 'ultisnips'
        call add(g:cmp_plugins, 'cmp-nvim-ultisnips')
    endif

    for plug in g:cmp_plugins
        if plug == 'cmp-nvim-ultisnips'
            Plug 'quangnguyen30192/cmp-nvim-ultisnips', {'on': []}
        else
            Plug 'hrsh7th/'..plug, {'on': []}
        endif
    endfor
endif

" --others-- "
if g:use_vimtex
    Plug 'lervag/vimtex', {'for': 'tex'}
endif

call plug#end()
