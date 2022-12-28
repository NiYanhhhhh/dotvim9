vim9script

g:autopair_debug = 1
g:autopair = [
    '(c)',
    '[c]',
    '{c}'
]
g:autopair_cache = {}
var mapped = []

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

def EnterMap()
    
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
enddef

export def Init()
    for pair in g:autopair
        PairMap(pair)
    endfor
enddef
