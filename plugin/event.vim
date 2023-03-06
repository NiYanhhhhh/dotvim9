" --special filetype settings-- "
au FileType c,cpp,java set mps+==:;

" --keyboard event-- "
autocmd InsertEnter * ++once call event#on_insert_enter()
autocmd InsertLeave * call event#on_insert_leave()
autocmd BufReadPost * call event#on_bufread()

" --quit quickfix when all windows closed-- "
autocmd BufEnter * if &filetype == 'qf' && winnr('$') < 2 | q | endif

" --start fcitx-- “
autocmd InsertEnter * call event#start_fcitx()

" --CursorMoved event-- "
autocmd CursorMoved * call event#on_cursor_moved()

" --coc init events-- "
if g:complete_frame == 'coc'
    autocmd User CocNvimInit call event#on_coc_init()
endif

" --fern inti-- "
autocmd FileType fern call keymap#fern()

