function! s:run_part_code(reg) abort
    let code = getreg(a:reg)
    let l_code = split(code, '\n')
    let space_len = match(l_code[-1], '\S')
    for i in range(len(l_code) - 1)
        let l = match(l_code[i], '\S')
        if l < space_len
            let space_len = l
        endif
    endfor
    for line in l_code
        exec strpart(line, space_len)
    endfor
endfunction

nnoremap <buffer> <silent> <f5> <cmd>source %<cr>
vnoremap <buffer> <silent> <script> <F5> "by<cmd><SID>run_part_code("b")<cr>

