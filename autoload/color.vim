function! s:common()
    hi StatusLineOk cterm=bold ctermfg=121 gui=bold guifg=DarkGreen guibg=#c2bfa5
    hi StatusLineInfo ctermfg=4 guifg=LightBlue guibg=#c2bfa5
    hi StatusLineError ctermfg=1 guifg=Red guibg=#c2bfa5
    hi StatusLineWarn ctermfg=3 guifg=Orange guibg=#c2bfa5
    hi StatusLineHint ctermfg=7 guifg=LightGrey guibg=#c2bfa5
endfunction

function! s:default()
    set background=light
endfunction

function! s:ayu()
    let s:style = get(g:, 'ayucolor', 'dark')
    if s:style == 'light'
        hi! VertSplit guifg=gray20
        hi! SignColumn ctermbg=242 guifg=gray30 guibg=#FAFAFA
        " hi link NormalFloat Normal
        hi link FloatBorder Type
        hi! StatusLine guifg=White guibg=Black
        hi! StatusLineNC guifg=White guibg=Gray
    else
        hi! VertSplit guifg=#263651
    endif
endfunction

function! s:desert()
    hi! Pmenu guibg=gray28
    hi! PmenuSel guibg=#c2bfa5 guifg=gray30 gui=bold
    hi! SignColumn ctermfg=14 ctermbg=242 guifg=Cyan guibg=grey20 gui=bold
    hi! NvimTreeIndentMarker guifg=gray30
    hi! ColorColumn ctermbg=1 guibg=gray18
    hi! FloatBorder cterm=reverse guifg=#c2bfa5
endfunction

function! color#on_colorscheme() abort
    call s:common()
    let csname = expand("<amatch>")
    if exists('*s:'.csname)
        call s:{csname}()
    endif
    if exists('g:lightline')
        let g:lightline.colorscheme = csname
        call lightline#enable()
    endif
endfunction

function! color#setup(t) abort
    call plug#load('ayu-vim')
	if !has_key(environ(), 'DISPLAY')
	    let ayucolor = 'dark'
	    colorscheme ayu
        return
    endif

	if a:t == 'ayu'
		let g:ayucolor = 'light'
	endif
    exec 'colorscheme '.a:t
endfunction

augroup hi_after
    au!
    autocmd ColorScheme * call color#on_colorscheme()
augroup END
