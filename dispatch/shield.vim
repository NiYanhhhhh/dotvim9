" A vim plugin that input punctuations in pairs
" Maintainer:   NiYanhhhhh <2093615664@qq.com>
" Version:      1.0
" Last Change:  2020-6-17
" Repository:   https://github.com/NiYanhhhhh/shield
" License:      MIT


if exists('g:shield_loaded') || &cp
    finish
endif
let g:shield_loaded = 1

if !exists('g:shield_startup')
    let g:shield_startup = 1
endif

"----------------------------------------------------------------------
" important var
"----------------------------------------------------------------------
"
" These var is often defined in parser function
"
"     line: a line to parser
"     `let line = getline('.')`
"
"     pos: position in insmode, whose value starts at 0
"     `let pos = col('.') - 1`
"
" These vars is often defined in s:function
"
"     before: substring in line before pos
"     `let before = strpart(line, 0, pos)`
"     after: substring in line before pos
"
"     `let after = strpart(line, pos)`
"
"let line = getline('.')
"let pos = col('.') - 1
"let before = strpart(line, 0, pos)
"let after = strpart(line, pos)

"----------------------------------------------------------------------
" tool functions
"----------------------------------------------------------------------
function! s:shieldStrFix(str)
    if a:str == "|"
        return '\<BAR>'
    endif
    if a:str == "\""
        return '\"'
    endif
    return a:str
endfunction

" return 0 means not (after key | before value)
function! s:judge_kv(line, pos, key, value)
    let before = strpart(a:line, 0, a:pos)
    let after = strpart(a:line, a:pos)
    let result = 0

    if a:key != 'null'
        if match(before, '\V'.a:key.'\$') == -1
            return 0
        else
            let result = 1
        endif
    endif

    if a:value != 'null'
        if match(after, '\V\^'.a:value) == -1
            return 0
        else
            let result = 1
        endif
    endif

    return result
endfunction

" this function's name is actually is_open_or_close, too long
" when the flag is set to 'open', return 1 means closing is too much.
" when the flag is set to 'close', return 1 means closing is not enough.
function! s:isoc(line, pos, opening, closing, flag)
    let count = 0
    let opening = a:opening
    let closing = a:closing
    let pat = '\M\\"\|\\|\|'.opening.'\|'.closing.'\|\["'']'

    let mat = matchstrpos(a:line, pat)
    let index = mat[2]
    let stack =[0, 0]
    " to judge if index is between quotes
    let i = 0
    " to judge if pos is between quotes
    let j = 0
    let quote = 0
    while mat[0] != ''
        if mat[0] == '''' && a:opening != ''''
            if quote == 0
                if index < a:pos
                    let j = 1
                endif
                let i += 1
                let quote = 1
            elseif quote == 1
                if index < a:pos
                    let j = 0
                endif
                let i -= 1
                let quote = 0
            endif
        elseif mat[0] == '"' && a:opening != '"'
            if quote == 0
                if index < a:pos
                    let j = 1
                endif
                let i += 1
                let quote = 2
            elseif quote == 2
                if index < a:pos
                    let j = 0
                endif
                let i -= 1
                let quote = 0
            endif
        elseif mat[0] == opening
            let stack[i] += 1
        elseif mat[0] == closing
            let stack[i] -= 1
            if stack[i] == 0
                if index > a:pos
                    if a:flag == 'close' && i == j
                        return 1
                    endif
                endif
            elseif stack[i] < 0
                if index > a:pos
                    if a:flag == 'open' && i == j
                        return 1
                    endif
                endif
                let stack[i] = 0
            endif
        endif

        let mat = matchstrpos(a:line, pat, index)
        let index = mat[2]
    endwhile
    return 0
endfunction

"----------------------------------------------------------------------
" functional functions
"----------------------------------------------------------------------
function! ShieldToggle()
    if b:shield_enabled
        let b:shield_enabled = 0
        echo 'Shield Toggled! (Disabled).'
    else
        let b:shield_enabled = 1
        echo 'Shield Toggled! (Enabled).'
    end
    return ''
endf

function! ShieldOpenInputParser(oclist)
    let trigger_list = a:oclist[-1]
    let trigger_o = strpart(trigger_list[0], len(trigger_list[0]) - 1)

    if !b:shield_enabled
        return trigger_o
    endif

    let line = getline('.')
    let pos = col('.') - 1

    for [key, value] in a:oclist
        if len(key) == 1
            if !s:isoc(line, pos, key, value, 'open')
                return key.value.repeat("\<LEFT>", len(value))
            endif
        endif

        if !s:isoc(line, pos, key, value, 'open') && s:judge_kv(line, pos, strpart(key, 0, len(key) - 1), 'null')
            let value_f = value
            let aftervalue = strpart(line, pos, len(value) - 1)
            if aftervalue == strpart(value, 1)
                let value_f = strpart(value, 0, 1)
            endif
            return trigger_o.value_f.repeat("\<LEFT>", len(value_f))
        endif
    endfor
    return trigger_o
endfunction

function! ShieldCloseInputParser(oclist)
    let trigger_list = a:oclist[-1]
    let trigger_c = strpart(trigger_list[1], 0, 1)

    if !b:shield_enabled
        return trigger_c
    endif

    if !g:shield_autoclose
        return trigger_c
    endif

    let line = getline('.')
    let pos = col('.') - 1

    for pair in a:oclist
        let key = pair[0]
        let value = pair[1]

        if s:isoc(line, pos, key, value, 'close') && s:judge_kv(line, pos, 'null', value)
            return repeat("\<RIGHT>", len(value))
        endif
    endfor
    return trigger_c
endfunction

function! ShieldSameInputParser(oclist)
    let trigger_list = a:oclist[-1]
    let trigger = strpart(trigger_list[1], 0, 1)

    if !b:shield_enabled
        return trigger
    endif

    let line = getline('.')
    let pos = col('.') - 1

    if trigger == '"' && &filetype == 'vim'
        if line =~ '^\s*$'
            return trigger
        endif
    endif

    if !g:shiel_autoclose_same
        return ShieldOpenInputParser(a:oclist)
    endif

    for pair in a:oclist
        let key = pair[0]
        let value = pair[1]

        if s:judge_kv(line, pos, 'null', value)
            return repeat("\<RIGHT>", len(value))
        endif
    endfor

    return ShieldOpenInputParser(a:oclist)
endfunction

function! ShieldBSParser()
    let line = getline('.')
    let pos = col('.') - 1
    let before = strpart(line, 0, pos)
    let after = strpart(line, pos)

    if line =~ '^\s*$'
        return ShieldBSMultilineParser()
    endif

    if !b:shield_enabled
        return "\<BS>"
    endif

    let keys = keys(b:shield_rules)
    for i in reverse(range(1, len(keys)))
        for j in range(i-1)
            if len(keys[j]) < len(keys[j+1])
                let t = keys[j]
                let keys[j] = keys[j+1]
                let keys[j+1] = t
            endif
        endfor
    endfor

    for key in keys
        let value = get(b:shield_rules, key)
        if s:judge_kv(line, pos, key, value)
            return repeat("\<BS>", len(key)).repeat("\<DEL>", len(value))
        endif
    endfor
    return "\<BS>"
endfunction

function! ShieldBSMultilineParser()
    if !b:shield_enabled
        return "\<BS>"
    endif

    if !g:shield_bs_multiline
        return "\<BS>"
    endif

    let line_before = getline(line('.') - 1)
    let line_after = getline(line('.') + 1)
    let pos_before = len(line_before)
    let pos_after = match(line_after, '\S')

    for [key, value] in items(b:shield_multiline_rules)
        if s:judge_kv(line_before, pos_before, key, 'null') && s:judge_kv(line_after, pos_after, 'null', value)
            return "\<Esc>kJJcc"
        endif
    endfor

    return "\<BS>"
endfunction

" Should be improved, it's too slow
function! ShieldReturnAppend(mode)
    let line = getline('.')

    if a:mode == 'i'
        " because of a <esc>, the pos is already declined
        let pos = col('.') - 1
    elseif a:mode == 'n'
        let pos = len(line)
    endif

    for key in keys(b:shield_multiline_rules)
        if s:judge_kv(line, pos, key, 'null')
            let value = get(b:shield_multiline_rules, key)
            let appendline = strpart(line, 0, match(line, '\S')).value
            call append(line('.'), appendline)
            if s:judge_kv(line, pos, 'null', value)
                let line_fix = substitute(line, value, '', "")
                call setline('.', line_fix)
            endif
        endif
    endfor
endfunction

function! ShieldMap()
    let shield_rules = items(b:shield_rules)
    let trigger_list = {}

    " get trigger_list:
    " {'trigger: ':'[[op1, cl1], [op2, cl2], ...]', ...}
    for pair in shield_rules
        let opening = pair[0]
        let closing = pair[1]

        let trigger_o = strpart(opening, len(opening) - 1)
        let trigger_c = strpart(closing, 0, 1)
        let trigger = trigger_o.trigger_c

        if string(get(trigger_list, trigger, 'null')) == "'null'"
            let trigger_list[trigger] = []
        endif

        call add(trigger_list[trigger], [opening, closing])
    endfor

    " rank trigger with op string length
    " values is like this:
    "   [
    "   [[t1o1, t1c1], [t1o2, t1c2], ...],
    "   [[t2o1, t2c1], [t2o2, t2c2], ...],
    "   ...
    "   ]
    " we just use value[i][0]
    for value in values(trigger_list)
        for i in reverse(range(1, len(value)))
            for j in range(i-1)
                if len(value[j][0]) < len(value[j+1][0])
                    let t = value[j]
                    let value[j] = value[j+1]
                    let value[j+1] = t
                endif
            endfor
        endfor

        for pair in value
            if pair[0] == '|'
                let pair[0] = '<BAR>'
            endif
            if pair[1] == '|'
                let pair[1] = '<BAR>'
            endif
        endfor
    endfor

    for trigger in keys(trigger_list)
        let trigger_o = split(trigger, '\zs')[0]
        let trigger_c = split(trigger, '\zs')[1]

        if trigger_o == '|'
            let trigger_o = '<BAR>'
        endif
        if trigger_c == '|'
            let trigger_c = '<BAR>'
        endif

        if trigger_o != trigger_c
            exec "inoremap <buffer> <silent> ".trigger_o." \<C-R>=ShieldOpenInputParser(".string(trigger_list[trigger]).")\<CR>"
            exec "inoremap <buffer> <silent> ".trigger_c." \<C-R>=ShieldCloseInputParser(".string(trigger_list[trigger]).")\<CR>"
        elseif trigger_o == trigger_c
            exec "inoremap <buffer> <silent> ".trigger_o." \<C-R>=ShieldSameInputParser(".string(trigger_list[trigger]).")\<CR>"
        endif
    endfor
endfunction

" Some functions for convenient operation
function! ShieldJumptoLeft()
    let line = getline('.')
    let pos = col('.') - 1
    let before = strpart(line, 0, pos)

    let jump_position = 0

    for [opening, closing] in items(b:shield_rules)
        let pat = '\M\\"\|\\|\|'.opening.'\|'.closing.'\|\["'']'
        let mat = matchstrpos(before, pat)
        let index = mat[2]
        let stack = 0
        let quote = 0
        let position = 0

        if opening != closing
            while mat[0] != '' && index <= pos
                if mat[0] == '''' && opening != ''''
                    if quote == 0
                        let quote = 1
                    elseif quote == 1
                        let quote = 0
                    endif
                elseif mat[0] == '"' && opening != '"'
                    if quote == 0
                        let quote = 2
                    elseif quote == 2
                        let quote = 0
                    endif
                elseif mat[0] == opening && !quote
                    let stack += 1
                elseif mat[0] == closing && !quote
                    let stack -= 1
                    if stack < 0
                        let stack = 0
                    endif
                endif
                let mat = matchstrpos(before, pat, index)
                let index = mat[2]
            endwhile
            if stack != 0
                let position = matchstrpos(before, opening, 0, stack)[2] + 1
            endif
        endif

        if opening == closing
            while mat[0] != '' && index < pos
                if mat[0] == '''' && opening != ''''
                    if quote == 0
                        let quote = 1
                    elseif quote == 1
                        let quote = 0
                    endif
                elseif mat[0] == '"' && opening != '"'
                    if quote == 0
                        let quote = 2
                    elseif quote == 2
                        let quote = 0
                    endif
                elseif mat[0] == opening
                    let stack = !stack
                endif
                let mat = matchstrpos(before, pat, index)
                let position = index + 1
                let index = mat[2]
            endwhile
            if !stack
                let position = 0
            endif
        endif

        if position > jump_position
            let jump_position = position
        endif
    endfor

    return jump_position
endfunction


" A function to test
function! ShTest(opening, closing)
    echo 'key-value: '.s:judge_kv(getline('.'), col('.')-1, a:opening, a:closing)
    echo 'key: '.s:judge_kv(getline('.'), col('.')-1, a:opening, 'null')
    echo 'value: '.s:judge_kv(getline('.'), col('.')-1, 'null', a:closing)
    echo 'isopen: '.s:isoc(getline('.'), col('.') - 1, a:opening, a:closing, 'open')
    echo 'isclose: '.s:isoc(getline('.'), col('.') - 1, a:opening, a:closing, 'close')
    echo 'out open: '.ShieldOpenInputParser([[a:opening, a:closing]])
    echo 'out close: '.ShieldCloseInputParser([[a:opening, a:closing]])
endfunction

"----------------------------------------------------------------------
" init function
"----------------------------------------------------------------------
function! ShieldInit()

    let b:shield_enabled = g:shield_startup

    " Inline edit
    if !exists('g:shield_rules')
        let g:shield_rules = {
                    \ '(':')',
                    \ '[':']',
                    \ '{':'}',
                    \ "'":"'",
                    \ '"':'"',
                    \ "`":"`",
                    \ "'''":"'''",
                    \ '"""':'"""',
                    \ }
    endif

    if !exists('b:shield_rules_extend')
        let b:shield_rules_extend = {}
    endif

    if !exists('b:shield_rules')
        let b:shield_rules = copy(g:shield_rules)
    endif

    let g:shield_rules = extend(b:shield_rules, b:shield_rules_extend)


    " Multi lines edit
    if !exists('g:shield_multiline_rules')
        let g:shield_multiline_rules = {
                    \ '(':')',
                    \ '[':']',
                    \ '{':'}',
                    \ "'''":"'''",
                    \ '"""':'"""',
                    \ }
    endif

    if !exists('b:shield_multiline_rules_extend')
        let b:shield_multiline_rules_extend = {}
    endif

    if !exists('b:shield_multiline_rules')
        let b:shield_multiline_rules = copy(g:shield_multiline_rules)
    endif

    let b:shield_multiline_rules = extend(b:shield_multiline_rules, b:shield_multiline_rules_extend)


    " some paraments
    if !exists('g:shield_autoclose')
        let g:shield_autoclose = 1
    endif

    if !exists('g:shiel_autoclose_same')
        let g:shiel_autoclose_same = 0
    endif

    if !exists('g:shield_bs_multiline')
        let g:shield_bs_multiline = 1
    endif

    " key maps
    if !exists('g:shield_jumpto_right')
        let g:shield_jumpto_right = '<C-l>'
    endif

    if !exists('g:shield_jumpto_left')
        let g:shield_jumpto_left = '<C-h>'
    endif

    if !exists('g:shield_wrap')
        let g:shield_wrap = '<C-e>'
    endif

    if !exists('g:shield_toggle')
        let g:shield_toggle = '<M-p>'
    endif

    " main init function
    call ShieldMap()
    inoremap <buffer> <silent> <BS> <C-R>=ShieldBSParser()<CR>
    inoremap <buffer> <silent> <expr> <CR> getline('.') =~ '^\s*$' ? "\<CR>" : '<C-\><C-O>:call ShieldReturnAppend("i")<CR><CR>'
    nnoremap <buffer> <silent> o :call ShieldReturnAppend("n")<CR>o

    if g:shield_toggle !=""
        exec 'inoremap <buffer> <silent> <expr> '.g:shield_toggle." ShieldToggle()"
        exec 'nnoremap <buffer> <silent> '.g:shield_toggle." :call ShieldToggle()\<CR>"
    endif

    exec 'inoremap <buffer> <silent> '.g:shield_jumpto_left.' <C-\><C-O>:call cursor(line(''.''), ShieldJumptoLeft())<CR>'
    exec 'nnoremap <buffer> <silent> '.g:shield_jumpto_left.' :call cursor(line(''.''), ShieldJumptoLeft())<CR>'

endfunction

auto BufEnter * call ShieldInit()
