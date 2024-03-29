function! event#on_insert_enter() abort
    set norelativenumber
    call plugin#autopair()

    call keymap#insert_mappings()
endfunction

function! event#on_insert_leave() abort
    if &nu
        set relativenumber
    endif
endfunction

function! event#on_ui_enter() abort
    if g:appearance_load
        return
    endif
    call plug#load(
                \ 'ayu-vim',
    \ )
    call color#setup(g:color_set)
    call status#setup()
    let g:appearance_load = 1
endfunction

function! event#on_bufread() abort
    if g:bufreaded
        return
    endif
    let g:bufreaded = 1
    call plugin#lsp_init()
    call plugin#snips_init()
endfunction

function! event#start_fcitx() abort
    if g:fcitx_load
        return
    endif
    let g:fcitx_load = 1

    call plug#load('fcitx.vim')
endfunction

function! event#on_cursor_moved() abort
    if g:nu_load
        set nonumber
        set norelativenumber
        let g:nu_load = 0
    endif

endfunction

function! event#on_coc_init() abort
    if g:autopairs != 'coc-autopairs'
        call CocAction('deactivateExtension', 'coc-pairs')
    endif

    if g:use_vimtex
        call CocAction('deactivateExtension')
    endif
    if g:tree_frame != 'coc-explorer'
        call CocAction('deactivateExtension', 'coc-explorer')
    endif
endfunction
