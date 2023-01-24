function! s:CheckBox() abort
    let line = getline('.')
    let col = col('.')-1
    if strpart(line, col-1, 3) == '[ ]'
        return "rx"
    elseif strpart(line, col-1, 3) == '[x]'
        return "r\<space>"
    else
        return "\<space>"
    endif
endfunction

function! s:Bold(isVisual = 0) abort
    let insStr = "\"ms****\<esc>\<left>\"mP"
    if !a:isVisual
        let insStr = "viw"..insStr
    endif
    echom insStr
    return insStr
endfunction

function! s:Italic(isVisual = 0) abort
    let insStr = "\"ms**\<esc>\"mP"
    if !a:isVisual
        let insStr = "viw"..insStr
    endif
    return insStr
endfunction

function! s:Under(isVisual = 0) abort
    let insStr = "\"ms<u>\<esc>\"mpa</u>\<esc>"
    if !a:isVisual
        let insStr = "viw"..insStr
    endif
    return insStr
endfunction

"keymaps
nnoremap <F5> <cmd>MarkdownPreview<cr>
nnoremap <expr><silent> <space><space> <SID>CheckBox()
vnoremap <expr><silent> <leader>b <SID>Bold(1)
vnoremap <expr><silent> <leader>i <SID>Italic(1)
vnoremap <expr><silent> <leader>u <SID>Under(1)
nnoremap <expr><silent> <leader>b <SID>Bold()
nnoremap <expr><silent> <leader>i <SID>Italic()
nnoremap <expr><silent> <leader>u <SID>Under()
