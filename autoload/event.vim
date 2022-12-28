function! event#on_insert_enter() abort
    set norelativenumber
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

function! event#start_fcitx() abort
    if g:fcitx_load
        return
    endif
    let g:fcitx_load = 1

    call plug#load('fcitx.vim', 'ultisnips')
endfunction

function! event#on_cursor_moved() abort
    if g:nu_load
        set nonumber
        set norelativenumber
        let g:nu_load = 0
    endif

endfunction
