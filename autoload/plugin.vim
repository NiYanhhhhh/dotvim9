function! plugin#basic_setup() abort
    " fcitx.vim
    let g:fcitx5_remote = '/usr/bin/fcitx5-remote'

    "ultisnips
    if g:snips_frame == 'ultisnips'
        call s:ultisnips()
    endif

    "gutentags
    call s:gutentags()

    "commentary
    call s:commentary()

    "Leaderf
    call s:leaderf()
endfunction

function! plugin#vimtex_setup() abort
    if g:vimtex_loaded
        return
    endif
    let g:vimtex_loaded = 1

    let g:vimtex_view_method = 'zathura'
    let g:vimtex_complete_enabled = 1
    nnoremap <f5> <cmd>VimtexView<cr>
    nnoremap <f9> <cmd>VimtexCompile<cr>
endfunction

function! plugin#coc_setup() abort
    call keymap#coc()
    " let g:coc_config_home = '~/.vim/coc-settings.json'

	let g:coc_global_extensions = ['coc-json', 'coc-marketplace',
                \ 'coc-pairs', 'coc-vimlsp', 'coc-explorer', 'coc-snippets']
    if g:coc_language_extensions
        let g:coc_global_extensions += ['coc-jedi', 'coc-java', 'coc-texlab',
                    \ 'coc-clangd', 'coc-sumneko-lua', 'coc-cmake']
    endif
    autocmd CursorHold * call CocActionAsync('highlight')
endfunction

function! s:ultisnips() abort
    call plug#load('ultisnips')
    " let g:UltiSnipsExpandTrigger = "<c-y>"
    let g:UltiSnipsEditSplit = "vertical"
    let g:UltiSnipsJumpForwardTrigger = "<c-j>"
    let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
endfunction

function! s:gutentags() abort
    let g:gutentags_project_root = ['.root', '.git']
    let g:gutentags_cache_dir = expand('~/.cache/tags')
    let g:gutentags_ctags_tagfile = '.tags'

    let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
    let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
    let g:gutentags_modules = ['ctags', 'gtags_cscope']

    let g:gutentags_plus_nomap = 1
endfunction

function! s:commentary() abort
    xmap <leader>c  <Plug>Commentary
    nmap <leader>c  <Plug>Commentary
    omap <leader>c  <Plug>Commentary
    nmap <leader>cc <Plug>CommentaryLine
    nmap <leader>cu <Plug>Commentary<Plug>Commentary
endfunction

function! s:leaderf() abort
    let g:Lf_WindowPosition = 'popup'
    let g:Lf_PreviewInPopup = 1
    let g:Lf_ShortcutF = "<leader>ff"
    let g:Lf_ShortcutB = "<leader>bu"
    let g:Lf_CommandMap = {
                \   '<c-X>': ['<c-s>'],
                \   '<c-]>': ['<c-i>'],
                \   '<c-j>': ['<c-j>', '<Tab>'],
                \   '<c-k>': ['<c-k>', '<s-Tab>'],
                \ }
    noremap <leader>fu :LeaderfFunction<CR>
    noremap <leader>fb :LeaderfBufTag<CR>
    noremap <leader>fw :LeaderfBufTagCword<CR>
    noremap <leader>ft :Leaderf --nowrap task<CR>
    noremap <leader>fj :Leaderf tag<CR>
endfunction
