" A vim plugin that input something easily
" Maintainer:   NiYanhhhhh <2093615664@qq.com>
" Version:      1.0
" Last Change:  2020-9-16
" Repository:   https://github.com/NiYanhhhhh/shield
" License:      MIT


"----------------------------------------------------------------------
" Some parameters
"----------------------------------------------------------------------
let g:ei_list = ['(', ')', '[', ']', '{', '}']
let g:ei_crlist = ['(', ')', '[', ']', '{', '}', '"""', '"""', "'''", "'''"]


"----------------------------------------------------------------------
" functional functions
"----------------------------------------------------------------------
function! EIToggle()
    if b:ei_enabled
        let b:ei_enabled = 0
        echo 'Easy Input Toggled! (Disabled).'
    else
        let b:ei_enabled = 1
        echo 'Easy Input Toggled! (Enabled).'
    end
    return ''
endfunction

function! EIOpenParser(open, close)
    if !b:ei_enabled
        return a:open
    endif

    let skip = 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\\|comment"'
    let [s_lnum1, s_colu1] = searchpairpos(a:open, '', a:close, 'Wn', skip)
    let [s_lnum2, s_colu2] = searchpairpos(a:open, '', a:close, 'rWn', skip)
    return a:open.a:close."\<Left>"
endfunction

function! EICloseParser(open, close)
    if !b:ei_enabled
        return a:close
    endif

    let c_lnum = line('.')
    let c_col = col('.') - 1
    let c1 = getline(c_lnum)[c_col]
    let i = index(b:ei_list, c1)
    if i % 2 != 1
        return a:close
    else
        " let skip = 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\\|comment"'
        " let [s_lnum1, s_colu1] = searchpairpos(a:open, '', a:close, 'bWn', skip)
        " let [s_lnum2, s_colu2] = searchpairpos(a:open, '', a:close, 'rbWn', skip)
        " if s_lnum1 == s_lnum2 && s_colu1 == s_colu2
            return "\<Right>"
        " else
            " return a:close
        endif
    endif
    return a:close
endfunction

function! EIBSParser()
    if !b:ei_enabled
        return "\<BS>"
    endif

    let c_lnum = line('.')
    let c_col = col('.') - 1
    let c1 = getline(c_lnum)[c_col]
    let i = index(b:ei_list, c1)
    if i < 0
        return "\<BS>"
    elseif i % 2 == 1
        let c2 = getline(c_lnum)[c_col - 1]
        if b:ei_list[i - 1] == c2
            return "\<BS>\<Del>"
        endif
    endif

    return "\<BS>"
endfunction

function! EICRParser()
    if !b:ei_enabled
        return "\<CR>"
    endif

    let c_lnum = line('.')
    let c_col = col('.') - 1
    let c1 = getline(c_lnum)[c_col - 1]
    let i = index(b:ei_list, c1)
    if i % 2 != 0
        return "\<CR>"
    elseif i % 2 == 0
        let c2 = b:ei_list[i + 1]
        let [m_lnum, m_col] = searchpairpos(c1, '', c2, 'nWc')
        let m_col = m_col - 1
        if m_lnum == 0
            return c2 . "\<Left>\<CR>\<Up>\<End>\<CR>"
        elseif m_lnum == c_lnum && m_col == c_col
            return "\<CR>\<Up>\<End>\<CR>"
        elseif m_lnum != c_lnum
            return "\<CR>"
        endif
    endif
endfunction


"----------------------------------------------------------------------
" Init
"----------------------------------------------------------------------
function! EIInit()
    let b:ei_list = g:ei_list
    let b:ei_crlist = g:ei_crlist
    let b:ei_enabled = 1

    " Key maps
    for i in range(0, len(b:ei_list) - 1, 2)
        let open = b:ei_list[i]
        let close = b:ei_list[i + 1]
        exec "inoremap <buffer> <silent> ".open." \<C-R>=EIOpenParser('".open."', '".close."')\<CR>"
        exec "inoremap <buffer> <silent> ".close." \<C-R>=EICloseParser('".open."', '".close."')\<CR>"
    endfor

    inoremap <buffer> <silent> <BS> <C-R>=EIBSParser()<CR>
    inoremap <buffer> <silent> <CR> <C-R>=EICRParser()<CR>
    inoremap <buffer> <expr> <M-p> EIToggle()
    nnoremap <buffer> <silent> <M-p> :call EIToggle()<CR>
endfunction

auto BufEnter * call EIInit()
