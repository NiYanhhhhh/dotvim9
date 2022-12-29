vim9script

g:autopair_debug = 1
g:autopair_enable = 1
g:autopair = [
    '(c)',
    '[c]',
    '{c}',
    '''c''',
    '"c"'
]
g:autopair_cache = {}
var mapped = []
var max_startlen = 1
var max_endlen = 1

def ReplaceSpecial(s: string): string
    if strlen(s) > 1
        # TODO
    endif
    var key = s
    if key == '|'
        key = '\|'
    endif
    return key
enddef

export def PairMap(s: string)
    var open = split(s, 'c')[0]
    var close = split(s, 'c')[1]
    var key = open
    if strlen(open) == 1
        key = open
    elseif strlen(open) < 1 && g:autopair_debug
        call debug#error("You are mapping an empty string, skip")
    else
        key = open[strlen(open) - 1]
    endif

    key = ReplaceSpecial(key)
    close = ReplaceSpecial(close)
    var to_what = open .. close .. repeat('<Left>', strlen(close))

    if index(mapped, key) > 0 && g:autopair_debug
        call debug#info("Map " .. key .. " again! overwrited by " .. to_what)
    endif
    exec 'inoremap ' .. key .. ' ' .. to_what
    g:autopair_cache[key] = to_what
enddef

export def UnPairMaps()
    for key in keys(g:autopair_cache)
        exec 'iunmap ' .. key
    endfor
    g:autopair_enable = 0
enddef

export def BSParser(): string
    var pos = col('.') - 1
    var line = getline('.')
    if MatchPattern(strpart(line, pos - max_startlen, max_startlen + max_endlen))
        return repeat("\<BS>", max_startlen) .. repeat("\<Delete>", max_endlen)
    endif

    return "\<BS>"
enddef

export def CRParser()
enddef

def MatchPattern(s: string): bool
    for item in g:autopair
        var pat = substitute(item, 'c', '', '')
        if match(s, pat) >= 0
            return v:true
        endif
    endfor
    return v:false
enddef

export def Init()
    g:autopair_enable = 1

    for pair in g:autopair
        PairMap(pair)
    endfor
    inoremap <silent> <expr> <BS> autopair#BSParser()
enddef
