function! nvimlsc#complete(findstart, base) abort
    if g:deoplete_nvimlsp_enable
        lua require('lsc').complete(vim.api.nvim_eval('a:findstart'), vim.api.nvim_eval('a:base'))
    endif
endfunction

function! nvimlsc#testGetItem() abort
    lua require('lsc').test_item()
endfunction
