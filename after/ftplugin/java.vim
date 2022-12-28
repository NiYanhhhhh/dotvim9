" --base-- "

" --gradle-- "
nnoremap <silent> <leader><F8> <cmd>call GradleTaskView()<cr>

function! GradleTaskView()
    
endfunction

function! s:check_gradle_cache()
    let search_str = substitute(getcwd(), "/", "_")
    let gradle_cache_dir = getenv("HOME") . "/.gralde/completion"
    let file_list = readdir(gradle_cache_dir)
    let hasresult = 0
    for fname in file_list
        if match(fname, search_str) >= 0

        endif
    endfor
endfunction

function! s:create_win()
    
endfunction
