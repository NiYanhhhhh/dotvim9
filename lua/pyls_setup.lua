#!/usr/bin/lua

local M = {}

local lspconfig = require('lspconfig')

local jedi_on_attach = function(client, bufnr)
  require('commonls_setup').common_on_attach(client, bufnr)
end

local pyright_on_attach = function(client, bufnr)
  local opts = {noremap = true, silent = true}

  require('commonls_setup').common_on_attach(client, bufnr)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>o', "<CMD>PyrightOrganizeImports<CR>", opts)
end

function M.setup()
    lspconfig.jedi_language_server.setup {
        on_attach = jedi_on_attach,
        autostart = false
    }
    lspconfig.pyright.setup {
        on_attach = pyright_on_attach,
    }
end

return M
