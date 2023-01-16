if !has('vim9script')
    function! util#Nu() abort
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
    finish
endif

vim9script

# --number settings-- #
export def Nu()
    if g:nu_load
        set nonumber
        set norelativenumber
        g:nu_load = 0
    else
        set number
        set relativenumber
        g:nu_load = 1
    endif
enddef

export def Form(str, indent = 0)
    var t = type(str)
    if t == v:list
        echom repeat(' ', indent) .. "["
        for item in str
            Form(item, indent + 2)
        endfor
        echom repeat(' ', indent) .. "]"
    elseif t == v:t_dict
    else
        echo str
    endif
enddef
