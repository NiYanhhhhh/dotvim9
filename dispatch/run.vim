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

