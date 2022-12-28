function! s:terminal_metamode(mode)
    set ttimeout
    if $tmux != ''
        set ttimeoutlen=25
    elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
        set ttimeoutlen=25
    endif
    if has('nvim') || has('gui_running')
        return
    endif
    function! s:metacode(mode, key)
        if a:mode == 0
            exec "set <m-".a:key.">=\e".a:key
        else
            exec "set <m-".a:key.">=\e]{0}".a:key."~"
        endif
    endfunc
    for i in range(10)
        call s:metacode(a:mode, nr2char(char2nr('0') + i))
    endfor
    for i in range(26)
        call s:metacode(a:mode, nr2char(char2nr('a') + i))
        call s:metacode(a:mode, nr2char(char2nr('a') + i))
    endfor
    if a:mode != 0
        for c in [',', '.', '/', ';', '[', ']', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_']
            call s:metacode(a:mode, c)
        endfor
    else
        for c in [',', '.', '/', ';', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_']
            call s:metacode(a:mode, c)
        endfor
    endif
endfunc

call s:terminal_metamode(0)

map ïH <home>
imap ïH <home>
vmap ïH <home>
cmap ïH <home>

map ïF <end>
imap ïF <end>

vmap ïF <end>
cmap ïF <end>

map ïR <f3>
imap ïR <f3>
vmap ïR <f3>
cmap ïR <f3>

