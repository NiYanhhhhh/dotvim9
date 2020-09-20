" markdown
au Filetype markdown nnoremap <F5> :MarkdownPreview<CR>
au Filetype markdown nnoremap <F6> :MarkdownPreviewStop<CR>

" viml
function! RunPartCode()
    let code = getreg('*')
    exec code
endfunction
vnoremap <F5> y:call RunPartCode()<CR>

au Filetype vim nnoremap <F5> :source %<CR>

" python
au Filetype python nnoremap <F5> :AsyncRun -mode=terminal -rows=12 python %<CR>

" c
function! CParams()
    if search('\s*#include\s*<math.h>', 'wn')
        return " -lm"
    endif
    return ''
endfunction
au Filetype c nnoremap <silent> <F6> :exec "AsyncRun -rows=12 gcc % -o /tmp/".expand("%:r").CParams()<CR>
au Filetype c nnoremap <silent> <F5> :exec "AsyncRun -mode=terminal -rows=12 gcc % -o /tmp/".expand("%:r").CParams()." \&\& /tmp/".expand("%:r")<CR>
