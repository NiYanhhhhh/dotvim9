function! ayu#Switchcolor() abort
    if g:ayucolor == "light"
        let g:ayucolor = 'dark'
    elseif g:ayucolor == 'dark'
        let g:ayucolor = 'light'
    endif

    colorscheme ayu
endfunction
