" plugins will be downloaded under the specified directory.

call plug#begin(g:home.'/.vim/plugged')

" declare the list of plugins.

" appearance
Plug 'mhinz/vim-startify'
Plug 'kien/rainbow_parentheses.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'cormacrelf/vim-colors-github'
Plug 'sainnhe/gruvbox-material'
Plug 'ncm2/float-preview.nvim'

" tools
Plug 'tpope/vim-fugitive'
Plug 'ianva/vim-youdao-translater'
Plug 'terryma/vim-multiple-cursors'
Plug 'chrisbra/changesPlugin'
Plug 'yianwillis/vimcdoc'

" debug
Plug 'skywind3000/asyncrun.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }

" navigation
Plug 'airblade/vim-rooter'
Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'}

" code assistance
Plug 'DaeZak/crafttweaker-vim-highlighting'
Plug 'Chiel92/vim-autoformat'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'preservim/nerdcommenter'
Plug 'syngan/vim-vimlint'
Plug 'ynkdir/vim-vimlparser'
" Plug 'cohama/lexima.vim'
Plug 'Shougo/echodoc'

" syntax
Plug 'dense-analysis/ale'
" Plug 'neomake/neomake'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'sheerun/vim-polyglot'

" search
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

" Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'

" LSP plugins
Plug 'mfussenegger/nvim-jdtls'
Plug 'neovim/nvim-lspconfig'

""""""""""""""""""""""""""""""""""
""" code complete
""""""""""""""""""""""""""""""""""
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neopairs.vim'
" Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

" python
" Plug 'davidhalter/jedi-vim'
Plug 'deoplete-plugins/deoplete-jedi'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Sirver/ultisnips'
" vimL
Plug 'Shougo/neco-vim'
" zsh
Plug 'deoplete-plugins/deoplete-zsh'
" c/cpp
Plug 'Shougo/neoinclude.vim'
Plug 'xavierd/clang_complete'
" lua
" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-lua-ftplugin'

""""""""""""""""""""""""""""""""""
"
""""""""""""""""""""""""""""""""""

" list ends here. plugins become visible to vim after this call.
call plug#end()


""" plugin configurations "
" autoformat
let g:autoformat_retab = 0
let g:autoformat_autoindent = 0
autocmd FileType vim,tex let b:autoformat_autoindent = 1
let g:formatter_yapf_style = 'pep8'
noremap = :Autoformat<cr>
let g:formatdef_my_custom_c = '"astyle --mode=c --style=java -pcH".(&expandtab ? "s".shiftwidth() : "t")'
let g:formatters_c = ['my_custom_c']
let g:formatdef_lua_formatter = "'lua-format --config=' . getenv('HOME') . '/.config/luaformatter/config.yaml'"
let g:formatters_lua = ['lua_formatter']

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#coc#enabled = 1

" gruvbox-material
" let g:gruvbox_material_background = 'soft'

" rainbowParentheses
let g:rbpt_colorpairs = [
            \ ['brown',       'RoyalBlue3'],
            \ ['Darkblue',    'SeaGreen3'],
            \ ['darkgray',    'DarkOrchid3'],
            \ ['darkgreen',   'firebrick3'],
            \ ['darkcyan',    'RoyalBlue3'],
            \ ['darkred',     'SeaGreen3'],
            \ ['darkmagenta', 'DarkOrchid3'],
            \ ['brown',       'firebrick3'],
            \ ['gray',        'RoyalBlue3'],
            \ ['black',       'SeaGreen3'],
            \ ['darkmagenta', 'DarkOrchid3'],
            \ ['Darkblue',    'firebrick3'],
            \ ['darkgreen',   'RoyalBlue3'],
            \ ['darkcyan',    'SeaGreen3'],
            \ ['darkred',     'DarkOrchid3'],
            \ ['red',         'firebrick3'],
            \ ]
let g:rbpt_max = 16
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" nerdtree
noremap <f3> :NERDTreeToggle<cr>
noremap \nf :NERDTreeFocus<cr>
let g:NERDTreeShowHidden = 1

" nerdcommenter
let g:NERDSpaceDelims = 1

" auto-pairs
let g:AutoPairsMultilineClose = 0
let g:AutoPairsFlyMode = 0

" youdao translater
vnoremap <silent> <c-t> :<c-u>Ydv<cr>
nnoremap <silent> <c-t> :<c-u>Ydc<cr>
noremap <leader>yd :<c-u>Yde<cr>o

" vim-rooter
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_patterns = ['Rakefile',
            \ '.git/', '.project', 'README.*', 'LICENSE', '.gitignore']
let g:rooter_cd_cmd = 'lcd'

" Ultisnips
let g:UltiSnipsExpandTrigger = "<M-/>"
let g:UltiSnipsEditSplit = "vertical"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

" ale
let g:ale_sign_error = "E"
let g:ale_sign_warning = "W"
let g:ale_sign_info = "I"

let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_java_eclipselsp_workspace_path = '/home/.eclipselsp'
let g:ale_java_eclipselsp_path = '/home/niyan/Codes/japroj/eclipse.jdt.ls'
let g:ale_linters = {
            \ 'java' : [],
            \ 'lua' : [],
            \ 'python' : ['pylint']
            \ }
let g:ale_java_eclipselsp_config_path = "/home/niyan/Codes/japroj/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux"

" let g:ale_python_pylint_executable = 'ale-python-check'

"" deoplete.nvim
let g:deoplete#enable_at_startup = 1
" call deoplete#custom#option('profile', v:true)
" call deoplete#enable_logging('DEBUG', '/home/niyan/deoplete.log')
" call deoplete#custom#source('nvimlsp', 'is_debug_enabled', v:true)
" call deoplete#custom#option('omni_patterns', {
            " \ 'java': '[^. *\t].\{-}\w*',
            " \ })
call deoplete#custom#var('omni', 'functions', {
            \ 'lua' : 'nvimlsc#complete',
            \ 'java' : 'nvimlsc#complete'
            \ })
" call deoplete#custom#var('omni', 'input_patterns', {
            " \ 'lua': '\w+|\w+[.:]\w*',
            " \ 'java': '[^. \t0-9]\.{0,1}\w*'
            " \ })

" deoplete-tabnine
call deoplete#custom#var('tabnine', {
            \ 'line_limit': 500,
            \ 'max_num_results': 3,
            \ })

call deoplete#custom#option('camel_case', 'v:true')

" deoplete-zsh
call deoplete#custom#source('zsh', 'filetypes', ['zsh', 'sh'])

" float-preview
set completeopt-=preview
let g:float_preview#docked = 1
function! DisableExtras()
    call nvim_win_set_option(g:float_preview#win, 'number', v:false)
    call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:false)
    call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
endfunction

autocmd User FloatPreviewWinOpen call DisableExtras()


" jedi-vim
let g:jedi#completions_command = "<A-/>"
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 0

" neomake
" call neomake#configure#automake('nw', 500)

" syntastic
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_auto_jump = 2
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_mode_map = {
            \ "mode": "passive" }

""" markdown
let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1

" markdown-preview
let g:mkdp_browser = 'chromium'
let g:mkdp_markdown_css = ''

" startify
" returns all modified files of the current git repo
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
            \ { 'type': 'files',     'header': ['   MRU']            },
            \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
            \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
            \ { 'type': 'commands',  'header': ['   Commands']       },
            \ ]

let g:startify_commands = [
            \ {'h': 'help'},
            \ {'p': 'PlugInstall'},
            \ {'u': 'PlugUpdate'},
            \ {'c': 'PlugClean'}
            \ ]

" vim-multi-cursors
func! Multiple_cursors_before()
    call deoplete#disable()
endfunc
func! Multiple_cursors_after()
    call deoplete#enable()
endfunc

" leaderf
let g:Lf_PopupColorscheme = 'gruvbox_default'
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_ShortcutF = "<leader>ff"
let g:Lf_ShortcutB = "<leader>bu"
noremap <leader>fu :LeaderfFunction<CR>
noremap <leader>bt :LeaderfBufTag<CR>
noremap <leader>bc :LeaderfBufTagCword<CR>

" gutentags
let g:gutentags_project_root = ['.root', '.svn', '.git', 'README.*', 'LICENSE', '.project']
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
if !isdirectory(s:vim_tags)
    silent! call mkdir(s:vim_tags, 'p')
endif
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" tagbar
nmap <F8> :TagbarToggle<cr>

" asyncrun
let g:asyncrun_open = 12
autocmd User AsyncRunStop cw
nnoremap <leader>ru :AsyncRun -mode=terminal -rows=12 
nnoremap <leader>rb :AsyncRun -rows=12 

" LSP
if has('nvim-0.5')
    augroup jdtls_lsp
        au!
        au BufEnter *.java lua require('jdtls_setup').setup()
    augroup end
    let lspconfigs = ['luals_setup']
    for config in lspconfigs
        lua require(vim.api.nvim_eval('config')).setup()
    endfor
endif

au FileType java noremap <silent> <buffer> <leader>o <CMD>lua require('jdtls').organize_imports()<CR>
au BufEnter *.java,*.lua noremap <silent> <buffer> K <CMD>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <buffer> gd <CMD>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <buffer> gD <CMD>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <buffer> <leader>li <CMD>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <buffer> <leader>lr <CMD>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <buffer> <leader>r <CMD>lua vim.lsp.buf.rename()<CR>
vnoremap <silent> <buffer> gd <CMD>lua vim.lsp.buf.definition()<CR>
vnoremap <silent> <buffer> gD <CMD>lua vim.lsp.buf.declaration()<CR>
vnoremap <silent> <buffer> <leader>li <CMD>lua vim.lsp.buf.implementation()<CR>
vnoremap <silent> <buffer> <leader>lr <CMD>lua vim.lsp.buf.references()<CR>
vnoremap <silent> <buffer> <leader>r <CMD>lua vim.lsp.buf.rename()<CR>

set completefunc=v:lua.vim.lsp.omnifunc

" vim-lua-ftplugin
let g:lua_check_syntax = 0
let g:lua_complete_dynamic = 0
let g:lua_define_completion_mappings = 0
let g:lua_complete_omni = 1

""" plugin configurations end "
