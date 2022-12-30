function! keymap#nextline(arg) abort
    let cmd = "\<end>"

    let semi_ft_list = ['java', 'c', 'cpp']
    if index(semi_ft_list, &filetype) > -1
        let append_sem = 1
        let line = getline('.')
        if line == ''
            let append_sem = 0
        endif
        let last_char = strpart(line, strlen(line) - 1)
        if &filetype == 'cpp'
            if match(line, '\s*#include') > -1
                let append_sem = 0
            endif
        endif
        if last_char != ';' && append_sem
            let cmd .= ';'
        endif
    endif

    if &filetype == 'tex'
    endif

    " if a:arg == 0
    " elseif a:arg == 1
        " let cmd .= "\<Up>"
    " endif
    let lines = getline(line('.') - 1, line('.'))
    if join(lines) !~ '\S'
        let cmd .= "\<up>"
    endif

    let cmd .= "\<cr>"
    return cmd
endfunction

function! keymap#shouldindent() abort
    let indlen = cindent('.')

    if indlen == 0
        return 0
    endif
    if getline('.') !~ '^\s*$'
        return 0
    endif
    if col('.') - 1 >= indlen
        return 0
    else
        return 1
    endif
endfunction

function! keymap#getindent() abort
    let length = cindent('.') - col('.') + 1
    return repeat(' ', length)
endfunction

function! keymap#win_oprate()
    while(1)
        let input = getchar()
        if input == 13 || input == 27
            break
        endif
        if input == "\<Left>"
            wincmd h
        elseif input == "\<Right>"
            wincmd l
        elseif input == "\<Up>"
            wincmd k
        elseif input == "\<Down>"
            wincmd j
        else
            exec 'wincmd ' . nr2char(input)
        endif
        redraw
    endwhile
endfunction

function! keymap#gotofirst() abort
    let pos = col('.') - 1
    let first_pos = match(getline('.'), '\S')
    if pos == first_pos
        return '0'
    else
        return '^'
    endif
endfunction

function! keymap#lsp() abort
    nnoremap <leader>lh <cmd>LspHover<cr>
    nnoremap <leader>r <cmd>LspRename<cr>
    nnoremap <leader>dl <cmd>LspDiagCurrent<cr>
    nnoremap <leader>ds <cmd>LspDiagShow<cr>
    nnoremap <leader>dN <cmd>LspDiagPrev<cr>
    nnoremap <leader>dn <cmd>LspDiagNext<cr>
    nnoremap <c-s> <cmd>LspShowSignature<cr>
    inoremap <c-s> <cmd>LspShowSignature<cr>
    nnoremap <leader>da <cmd>LspCodeAction<cr>
    nnoremap gd <cmd>LspGotoDefinition<CR>
    nnoremap gD <cmd>LspGotoDeclaration<CR>
    nnoremap <leader>li <cmd>LspPeekImpl<CR>
    nnoremap <leader>lr <cmd>LspPeekReferences<CR>
    nnoremap <leader>ld <cmd>LspPeekDefinition<CR>
endfunction

function! keymap#coc() abort
    nnoremap <leader>lh <cmd>call CocActionAsync("doHover")<cr>
    nnoremap <leader>r <cmd>call CocActionAsync("rename")<cr>
    nnoremap <leader>dl <cmd>LspDiagCurrent<cr>
    nnoremap <leader>ds <cmd>LspDiagShow<cr>
    nnoremap <leader>dN <cmd>LspDiagPrev<cr>
    nnoremap <leader>dn <cmd>LspDiagNext<cr>
    nnoremap <c-s> <cmd>LspShowSignature<cr>
    inoremap <c-s> <cmd>LspShowSignature<cr>
    nnoremap <leader>da <cmd>LspCodeAction<cr>
    nnoremap gd <cmd>LspGotoDefinition<CR>
    nnoremap gD <cmd>LspGotoDeclaration<CR>
    nnoremap <leader>li <cmd>LspPeekImpl<CR>
    nnoremap <leader>lr <cmd>LspPeekReferences<CR>
    nnoremap <leader>ld <cmd>LspPeekDefinition<CR>
endfunction
