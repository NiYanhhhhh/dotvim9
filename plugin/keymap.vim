" --base-- "
let g:mapleader = "\<Space>"

"inoremap <m-j> <down>
"inoremap <m-k> <up>
"inoremap <m-h> <left>
"inoremap <m-l> <right>
" emacs like move
inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-b> <left>
inoremap <c-f> <right>

nnoremap <silent> <m-k> :resize +1<cr>
nnoremap <silent> <m-j> :resize -1<cr>
nnoremap <silent> <m-h> :vertical resize -1<cr>
nnoremap <silent> <m-l> :vertical resize +1<cr>

vnoremap <C-c> "+y
inoremap <C-v> <c-r>+
inoremap <C-S-v> <c-r>+

vnoremap <bs> X
nnoremap <bs> X

noremap <c-pagedown> gt
noremap <c-pageup> gT

inoremap <S-CR> <Esc>o
inoremap <C-S-CR> <Esc>O
nnoremap <S-CR> o<Esc>k
nnoremap <C-S-CR> O<Esc>j

nnoremap <c-l> <cmd>nohlsearch<cr>

" --using function-- "
inoremap <expr> <c-j> keymap#nextline(0)
inoremap <expr> <tab> pumvisible() ? "\<C-n>" :
            \ keymap#shouldindent() ? keymap#getindent() : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
nnoremap <expr> 0 keymap#gotofirst()
inoremap <silent> <expr> <c-y> keymap#confirm()

nnoremap <m-w> <cmd>call keymap#win_oprate()<cr>
inoremap <m-w> <cmd>call keymap#win_oprate()<cr>
vnoremap <m-w> <cmd>call keymap#win_oprate()<cr>

" --todo list-- "
nnoremap <leader>t <cmd>vim /TODO/j **/*.* \| copen<cr>

" --terminal-- "
if has('nvim')
    nnoremap \te <cmd>15split\|terminal<cr>i
else
    nnoremap \te <cmd>terminal<CR>
endif
tnoremap <Esc> <C-\><C-n>

" --quickfix-- "
nnoremap <silent> \co :copen 12<cr>
nnoremap <silent> \cc :cclose \| lclose<cr>
nnoremap <silent> \rg :AsyncTask grep<cr>

" --search-- "
vnoremap <silent> # "ay/<c-r>a<cr>

" --file explorer-- "
nnoremap <F3> <cmd>call keymap#tree_toggle()<cr>
nnoremap <leader><F3> <cmd>call keymap#tree_focus()<cr>
