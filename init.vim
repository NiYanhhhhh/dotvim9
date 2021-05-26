" set runtimepath+=~/.vim/after
" let &packpath = &runtimepath
let mapleader=' '
let g:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec 'source '.g:home.'/pluggins.vim'
exec 'source '.g:home.'/base.vim'
exec 'source '.g:home.'/keymaps.vim'
exec 'source '.g:home.'/dispatch.vim'

if has_key(environ(), 'DISPLAY')
    colorscheme gruvbox-material
    if exists('g:goneovim')
        set background=dark
    endif
else
    colorscheme default
endif
