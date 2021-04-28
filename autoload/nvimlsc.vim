function! nvimlsc#complete(findstart, base) abort
    lua require('lsc').complete(vim.api.nvim_eval('a:findstart'), vim.api.nvim_eval('a:base'))
endfunction

function! nvimlsc#testGetItem() abort
    lua require('lsc').test_item()
endfunction
