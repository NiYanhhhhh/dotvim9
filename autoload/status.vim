let g:status_broken = 'fine'

function! status#get()
    let start_part = s:start_part()
    let s_pos = " %12(%l/%{line('$')}:%c%V%)  %p%%"
    " TODO: This 2 terms may broken
    let s_line = ''
    if g:status_broken == 'fine'
        let s_lsp_diagnostic = s:try(function('s:diagnostic'), "Diagnostic is broken!")
        let s_git = s:try(function('s:git'), "Git is broken!")

        let s_line = start_part . "%<%=" . s_lsp_diagnostic . s_pos . s_git
    else
        return start_part . "%<%=%#Error#Oops! " . g:status_broken . "%*" . s_pos
    endif

    return s_line
endfunction

function! s:diagnostic()
    let b:lsp_diagnostic_info = get(b:, 'lsp_diagnostic_info', {'error': 0, 'warning': 0, 'information': 0, 'hint': 0})
    if exists('b:coc_diagnostic_info')
        let b:lsp_diagnostic_info = b:coc_diagnostic_info
    endif
    call filter(b:lsp_diagnostic_info, 'type(v:val) == v:t_number')

    let counts = 0
    for val in values(b:lsp_diagnostic_info)
        let counts += val
    endfor
    if counts == 0
        return "%#StatusLineOk#2B, or not 2B%*"
    endif

    let information = "%#StatusLineInfo#"
    let error = "%#StatusLineError#"
    let warning = "%#StatusLineWarn#"
    let hint = "%#StatusLineHint#"
    let diag = ""
    for [key, val] in items(b:lsp_diagnostic_info)
        let diag .= {key}
        let diag .= val <= 4 ? repeat("#", val) : printf("[%d]", val)
    endfor
    let diag .= "%*"
    return diag
endfunction

function! s:start_part() abort
    let s_fname = "%-0.30f %-m%-r%-y"
    let s_mode = "%-5{printf('[%s]', mode())}"
    let start_part = s_mode . s_fname
    return start_part
endfunction

function! s:git()
    if expand('%:t') =~? 'Tagbar\|Gundo\|NERD'
        return ''
    endif

    if !exists('*gitbranch#name')
        return ''
    endif

    let branch = gitbranch#name()
    if branch == ""
        return ""
    endif
    let branch = " ⁋ " . branch

    return branch
endfunction

function! status#setup()
    set statusline=%!status#get()
endfunction

function! s:try(func, result)
    let val = ''
    try
        let val = a:func()
    catch /.*/
        let g:status_broken = a:result
        echohl Error
        echom v:throwpoint
        echom v:exception
        echohl None
    endtry

    return val
endfunction
