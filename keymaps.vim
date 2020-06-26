" key map
inoremap <m-j> <down>
inoremap <m-k> <up>
inoremap <m-h> <left>
inoremap <m-l> <right>

nnoremap <m-k> :resize +1<cr>
nnoremap <m-j> :resize -1<cr>
nnoremap <m-h> :vertical resize -1<cr>
nnoremap <m-l> :vertical resize +1<cr>

nnoremap <c-a> ggVG
vnoremap <C-c> "+y
inoremap <C-v> <Esc>"+pa

vnoremap <bs> X
nnoremap <bs> X

noremap <c-pagedown> gt
noremap <c-pageup> gt

nnoremap \nh :noh<cr>

inoremap <S-CR> <Esc>o
inoremap <C-S-CR> <Esc>O
nnoremap <S-CR> o<Esc>k
nnoremap <C-S-CR> O<Esc>j

vnoremap # y/<C-R>"<CR>

" recording
nnoremap \a @j
nnoremap \b @b
nnoremap \q @q

function! s:getfirstpos()
    let line = getline('.')
    return match(line, '\S')
endfunction
function! s:shouldindent()
    let indlen = cindent('.')
    if col('.') - 1 >= indlen
        return 0
    else
        return 1
    endif
endfunction
inoremap <expr> <tab> <SID>shouldindent() && getline('.')=="" ? "\<esc>cc" :
            \ pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
nnoremap <expr>0 col('.')-1==<SID>getfirstpos() ? '0' : '^'

function! Terminal_metamode(mode)
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

call Terminal_metamode(0)

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

autocmd BufNewFile *.java,*.h,*.hpp,*.c,*.cpp,*.mk,*.sh,*.py exec ":call Settitle()"
func! Settitle()
    if &filetype == 'make'
    elseif &filetype == 'sh'
    elseif &filetype == 'python'
        call setline(1,"#!/usr/bin/env python")
        call setline(2,"#-*- coding: utf-8 -*-")
        call setline(3,"\"\"\"")
        call setline(4,"#__filename__ : ".expand("%:t"))
        call setline(5,"#__author__   : niyan")
        call setline(6,"#created date : ".strftime("%F %T"))
        call setline(7,"\"\"\"")
        call setline(8,"")
        call setline(9,"")
    elseif &filetype == 'java'
        call append(0,['// file : '.expand('%'),
            \ '// author : niyan',
            \ '// created date : '.strftime('%F %T'),
            \ ''])
    else
    endif
endfunc

" python config"
let python_highlight_all=1
au filetype python,java set fileformat=unix
au filetype python set autochdir
autocmd filetype python,java set foldmethod=indent
autocmd filetype python,java set foldlevel=99

" terminal
nnoremap \te :12split term://zsh<CR>i

tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
