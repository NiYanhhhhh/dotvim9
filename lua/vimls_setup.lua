#!/usr/bin/lua

local M = {}

local on_attach = function(client, bufnr)
  require('commonls_setup').common_on_attach(client, bufnr)
end

function M.setup()
  require('lspconfig').vimls.setup {
    on_attach = on_attach
  }
end

return M
