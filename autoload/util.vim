" --number settings-- "
function! util#nu() abort
    if g:nu_load
        set nonumber
        set norelativenumber
        let g:nu_load = 0
    else
        set number
        set relativenumber
        let g:nu_load = 1
    endif
endfunction

