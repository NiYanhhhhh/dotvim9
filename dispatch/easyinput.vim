" A vim plugin that input something easily
" Maintainer:   NiYanhhhhh <2093615664@qq.com>
" Version:      1.0
" Last Change:  2020-9-19
" Repository:   https://github.com/NiYanhhhhh/easy-input
" License:      MIT
" All functions are coded according to the parameters. It may cause crashes if
" changing the parameters without adapting the functions.


"----------------------------------------------------------------------
" Some parameters
"----------------------------------------------------------------------
let g:ei_list = ['(', ')', '[', ']', '{', '}']
let g:ei_crlist = ['(', ')', '[', ']', '{', '}', '"""', '"""', "'''", "'''", '$$', '$$']
let g:ei_special = {'"':3, "'":3}


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
        " endif
    endif
    return a:close
endfunction

" TODO: adapt the ei_crlist
function! EIBSParser()
    if !b:ei_enabled
        return "\<BS>"
    endif

    let c_lnum = line('.')
    let c_col = col('.') - 1
    let s_line = getline(c_lnum)
    let s_line_above = getline(c_lnum - 1)
    let s_line_below = getline(c_lnum + 1)
    let c1 = s_line[c_col - 1]
    let c2 = s_line[c_col]
    let i = index(b:ei_list, c2)
    if i % 2 == 1
        if b:ei_list[i - 1] == c1
            return "\<BS>\<Del>"
        endif
    endif

    if index(keys(g:ei_special), c1) >= 0
        let p_len = g:ei_special[c1]
        if strpart(s_line, c_col - p_len, p_len * 2) == repeat(c1, p_len * 2)
            return repeat("\<BS>\<Del>", p_len)
        endif
    endif

    if (c1 == '"' && c2 == '"') || (c1 == '''' && c2 == '''')
        return "\<BS>\<Del>"
    endif

    if !(s_line =~ '\S')
        for i in range(0, len(g:ei_crlist) - 1, 2)
            if strpart(s_line_above, len(s_line_above) - len(g:ei_crlist[i])) == g:ei_crlist[i]
                if strpart(s_line_below, match(s_line_below, '\S'), len(g:ei_crlist[i + 1])) == g:ei_crlist[i + 1]
                    return "\<C-U>\<BS>" . repeat("\<Del>", match(s_line_below, '\S') + 1)
                endif
            endif
        endfor
    endif

    return "\<BS>"
endfunction

function! EICRParser()
    if !b:ei_enabled
        return "\<CR>"
    endif

    if  expand("%") == ""
        return "\<CR>"
    endif

    let c_lnum = line('.')
    let c_col = col('.') - 1
    let s_line = getline(c_lnum)
    let c1 = s_line[c_col - 1]
    if c1 == "."
        return "\<CR>"
    endif
    if c1 == "\["
        let c1 = '\['
    endif
    if c1 == '$'
        let c1 = '\$'
    endif

    if c1 == ''
        let i = -1
    else
        let i = match(b:ei_crlist, c1)
    endif
    let c1 = b:ei_crlist[i]
    let p_len = len(c1)

    if i % 2 == 0
        let c2 = b:ei_crlist[i + 1]
        if c2 == "]"
            let c2 = '\]'
        endif

        if p_len > 1
            let c = strpart(s_line, c_col, p_len)
            if c == c2
                return "\<CR>\<Up>\<End>\<CR>"
            else
                return "\<CR>"
            endif
        endif

        if expand("%:e") == "zs"
            let op_str = "\<CR>\<BS>\<Up>\<End>\<CR>"
        else
            let op_str = "\<CR>\<Up>\<End>\<CR>"
        endif
        let [m_lnum, m_col] = searchpairpos(c1, '', c2, 'nWc')
        let m_col = m_col - 1
        if m_lnum == 0
            return c2 . "\<Left>" . op_str
        elseif m_lnum == c_lnum && m_col == c_col
            return op_str
        elseif m_lnum != c_lnum
            return "\<CR>"
        endif
    endif

    return "\<CR>"
endfunction

function! EISpecialParser(punc)
    let c_lnum = line('.')
    let c_col = col('.') - 1
    let line = getline(c_lnum)
    let p_len = b:ei_special[a:punc]

    if !b:ei_enabled
        return a:punc
    endif

    if index(['"', "'", '#', '$'], a:punc) >= 0
        let punc = repeat(a:punc, p_len)

        let c1 = strpart(line, c_col - p_len + 1, p_len - 1)
        let c2 = strpart(line, c_col, p_len - 1)
        if c1 . a:punc == punc
            if a:punc . c2 == punc
                return repeat(a:punc, 2) . "\<Left>"
            else
                return a:punc . punc . repeat("\<Left>", p_len)
            endif
        endif

        if a:punc == '"' || a:punc == "'"
            return repeat(a:punc, 2) . "\<Left>"
        endif
    endif

    return a:punc
endfunction

function! EIWrapper()
    let c_lnum = line('.')
    let c_col = col('.') - 1
    let c2 = getline(c_lnum)[c_col]
    let c3 = getline(c_lnum)[c_col + 1]
    let c1 = getline(c_lnum)[c_col - 1]

    let cmd = "\<Del>\<Esc>ea" . c2 . "\<Left>"

    if c3 == "\"" || c3 =="'" || index(g:ei_list, c3) >= 0
        let cmd = "\<Del>\<Esc>\<Right>\<Right>ca" . c3 . c2 . "\<Esc>Pa"
    endif

    if c1 == c2
        if c1 == '"' || c1 == "'"
            return cmd
        endif
    endif

    let i = index(b:ei_list, c2)
    if i % 2 == 1 && b:ei_list[i - 1] == c1
        return cmd
    endif

    return ""
endfunction


"----------------------------------------------------------------------
" Init
"----------------------------------------------------------------------
function! EIInit()
    let b:ei_list = g:ei_list
    let b:ei_crlist = g:ei_crlist
    let b:ei_special = g:ei_special
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
    nnoremap <buffer> <silent> o A<C-R>=EICRParser()<CR>
    inoremap <buffer> <expr> <M-p> EIToggle()
    nnoremap <buffer> <silent> <M-p> :call EIToggle()<CR>
    inoremap <buffer> <silent> <C-B> <C-R>=EIWrapper()<CR>
    for key in keys(b:ei_special)
        let k_expr = key
        if key == '"'
            let k_expr = '\"'
        endif

        exec 'inoremap <buffer> <silent> '.key." \<C-R>=EISpecialParser(\"".k_expr."\")\<CR>"
    endfor

    " C code special settings
    function! Ei_c_include()
        let s_line = getline('.')
        if s_line =~ "\s*#include\s*"
            return "<>\<Left>"
        endif
        return "<"
    endfunction
    inoremap <buffer> <silent> < <C-r>=Ei_c_include()<CR>
endfunction

auto BufEnter * call EIInit()

