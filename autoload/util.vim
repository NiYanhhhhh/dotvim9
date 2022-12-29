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

# --root finder-- #
export def Root(path: string)
    var pattern = g:root_pattern
    var root = getbufvar('%', 'rootDir')
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
