" plugins will be downloaded under the specified directory.

call plug#begin(g:home.'/.vim/plugged')

" declare the list of plugins.

" appearance
Plug 'mhinz/vim-startify'
Plug 'kien/rainbow_parentheses.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'cormacrelf/vim-colors-github'
Plug 'ncm2/float-preview.nvim'
" tools
Plug 'ianva/vim-youdao-translater'
Plug 'terryma/vim-multiple-cursors'
Plug 'chrisbra/changesPlugin'
" debug
Plug 'skywind3000/asyncrun.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
" navigation
Plug 'airblade/vim-rooter'
Plug 'preservim/nerdtree'
" code assistance
Plug 'Chiel92/vim-autoformat'
Plug 'preservim/nerdcommenter'
Plug 'jiangmiaO/auto-pairs'
" Plug 'vim-syntastic/syntastic'
Plug 'syngan/vim-vimlint'
Plug 'ynkdir/vim-vimlparser'
" syntax
" Plug 'dense-analysis/ale'
Plug 'neomake/neomake'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" search
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

""""""""""""""""""""""""""""""""""
""" code complete
""""""""""""""""""""""""""""""""""
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

" python
Plug 'davidhalter/jedi-vim'
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

""""""""""""""""""""""""""""""""""
"
""""""""""""""""""""""""""""""""""

" list ends here. plugins become visible to vim after this call.
call plug#end()


""" plugin configurations "
" autoformat
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
let g:formatter_yapf_style = 'pep8'
noremap = :Autoformat<cr>

" airline
let g:airline_theme='github'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#coc#enabled = 1

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

au Filetype markdown let g:AutoPairs['$']='$'


" youdao translater
vnoremap <silent> <c-t> :<c-u>Ydv<cr>
nnoremap <silent> <c-t> :<c-u>Ydc<cr>
noremap <leader>yd :<c-u>Yde<cr>o

" vim-rooter
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_patterns = ['Rakefile',
            \ '.git/', '.project', 'README.*', 'LICENSE', '.gitignore']
let g:rooter_use_lcd = 1

" Ultisnips
let g:UltiSnipsExpandTrigger = "<M-/>"
let g:UltiSnipsEditSplit = "vertical"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-h>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

" ale
" let g:ale_java_eclipse_workspace_path = '/home/niyan/eclipse-workspace'
" " let g:ale_java_eclipselsp_path = '/home/niyan/jdt-language-server-0.9.0-201711302113'
" let g:ale_java_eclipselsp_path = '/home/niyan/eclipse.jdt.ls/eclipse.jdt.ls'
" let g:ale_linters = {'java' : ['javac']}
" au Filetype java compiler javac

" coc.nvim
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <c-/> coc#refresh()

" deoplete.nvim
let g:deoplete#enable_at_startup = 1

" deoplete-tabnine
call deoplete#custom#var('tabnine', {
\ 'line_limit': 500,
\ 'max_num_results': 3,
\ })

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
let g:jedi#completions_command = "<C-N>"
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 0

" neomake
call neomake#configure#automake('nwr', 500)

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

" eclim
" au BufRead *.java exec 'CocDisable'
let g:EclimFileTypeValidate = 0

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

""" plugin configurations end "
