au Filetype markdown nnoremap <F5> :MarkdownPreview<CR>
au Filetype markdown nnoremap <F6> :MarkdownPreviewStop<CR>
au Filetype vim nnoremap <F5> :source %<CR>

"" asyncrun
" python run
au Filetype python nnoremap <F5> :AsyncRun -mode=terminal -rows=12 python %<CR>

