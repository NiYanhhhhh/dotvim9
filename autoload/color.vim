let s:style = 'light'

function! s:common()
    hi default link StatusLineOk vimSpecial
    hi default link StatusLineInfo vimSpecial
    hi default link StatusLineError vimError
    hi default link StatusLineWarn vimWarn
    hi default link StatusLineHint vimFold
    hi CocHighlightText gui=underline cterm=reverse
    if s:style == 'light'
        hi! StatusLine guifg=White guibg=Black
        hi! StatusLineNC guifg=White guibg=Gray
        hi! StatusLineOk cterm=bold ctermfg=121 gui=bold guifg=LightGreen guibg=Black
        hi! StatusLineInfo ctermfg=4 guifg=LightBlue guibg=Black
        hi! StatusLineError ctermfg=1 guifg=Red      guibg=Black
        hi! StatusLineWarn ctermfg=3 guifg=Orange    guibg=Black
        hi! StatusLineHint ctermfg=7 guifg=LightGrey guibg=Black
    elseif s:style == 'dark'
        hi! StatusLine guifg=White guibg=Black
        hi! StatusLineNC guifg=White guibg=Gray
        hi! StatusLineOk cterm=bold ctermfg=121 gui=bold guifg=LightGreen guibg=Black
        hi! StatusLineInfo ctermfg=4 guifg=LightBlue guibg=Black
        hi! StatusLineError ctermfg=1 guifg=Red      guibg=Black
        hi! StatusLineWarn ctermfg=3 guifg=Orange    guibg=Black
        hi! StatusLineHint ctermfg=7 guifg=LightGrey guibg=Black
    elseif s:style == 'desert'
    endif
endfunction

function! s:default()
    let s:style = 'light'
    set background=light
    call s:common()
endfunction

function! s:ayu()
    let s:style = get(g:, 'ayucolor', 'dark')
    if s:style == 'light'
        hi! VertSplit guifg=gray20
        hi! SignColumn ctermbg=242 guifg=gray30 guibg=#FAFAFA
        " hi link NormalFloat Normal
        hi link FloatBorder Type
    else
        hi! VertSplit guifg=#263651
    endif
    call s:common()
endfunction

function! s:desert()
    let s:style = 'desert'
    hi! Pmenu guibg=gray28
    hi! PmenuSel guibg=#c2bfa5 guifg=gray30 gui=bold
    hi! SignColumn ctermfg=14 ctermbg=242 guifg=Cyan guibg=grey20 gui=bold
    hi! NvimTreeIndentMarker guifg=gray30
    hi! ColorColumn ctermbg=1 guibg=gray18
    hi! FloatBorder cterm=reverse guifg=#c2bfa5
    call s:common()
endfunction

function! color#on_colorscheme() abort
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
	if !has_key(environ(), 'DISPLAY')
        call plug#load('ayu-vim')
	    let ayucolor = 'dark'
	    colorscheme ayu
        return
    endif

	if a:t == 'ayu'
        call plug#load('ayu-vim')
		let g:ayucolor = 'light'
        command! Ayu call ayu#Switchcolor()
	endif

    exec 'colorscheme '.a:t
endfunction

augroup hi_after
    au!
    autocmd ColorScheme * call color#on_colorscheme()
augroup END
