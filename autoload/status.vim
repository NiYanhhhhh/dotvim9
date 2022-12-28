function! status#get() abort
    let start_part = s:start_part()
    let s_pos = " %12(%l/%{line('$')}:%c%V%)  %p%%"
    " TODO: This 2 terms are broken
    let s_lsp_diagnostic = '' "s:diagnostic()
    let s_git = s:git()
    let s_line = start_part . "%<%=" . s_lsp_diagnostic . s_pos . s_git

    return s_line
endfunction

function! s:diagnostic()
    if !exists('b:lsp_error_counts')
        let b:lsp_error_counts = 0
    endif
    if !exists('b:lsp_warn_counts')
        let b:lsp_warn_counts = 0
    endif
    if !exists('b:lsp_info_counts')
        let b:lsp_info_counts = 0
    endif
    if !exists('b:lsp_hint_counts')
        let b:lsp_hint_counts = 0
    endif
    let counts = b:lsp_hint_counts + b:lsp_info_counts + b:lsp_warn_counts + b:lsp_error_counts
    if counts == 0
        return "%#StatusLineOk#2B, or not 2B%*"
    endif

    let info = "%#StatusLineInfo#"
    let error = "%#StatusLineError#"
    let warn = "%#StatusLineWarn#"
    let hint = "%#StatusLineHint#"
    let diag = ""
    let diag .= error
    let diag .= b:lsp_error_counts <= 4 ? repeat("#", b:lsp_error_counts) : printf("[%d]", b:lsp_error_counts)
    let diag .= warn
    let diag .= b:lsp_warn_counts <= 4 ? repeat("#", b:lsp_warn_counts) : printf("[%d]", b:lsp_warn_counts)
    let diag .= info
    let diag .= b:lsp_info_counts <= 4 ? repeat("#", b:lsp_info_counts) : printf("[%d]", b:lsp_info_counts)
    let diag .= hint
    let diag .= b:lsp_hint_counts <= 4 ? repeat("#", b:lsp_hint_counts) : printf("[%d]", b:lsp_hint_counts)
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
    let branch = gitbranch#name()

    if branch == ""
        return ""
    endif
    let branch = " ⁋ " . branch

    return branch
endfunction

function! status#setup() abort
    set statusline=%!status#get()
endfunction
