#!/usr/bin/lua

local M = {}

local on_attach = function(client, bufnr)
  require('commonls_setup').common_on_attach(client, bufnr)
end

function M.setup()
  local cmd = {"lua-language-server"}
  local pattern = {'.git', }

  local settings = {
    Lua = {
      runtime = {
        version = 'Lua 5.1',
        path = vim.split(package.path, ";")
      },
      diagnostics = {
        globals = {'vim'}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      telemetry = {
        enable = false
      }
    }
  }

  require('lspconfig').sumneko_lua.setup {
    filetypes = {'lua'},
    -- root_dir = util.root_pattern(pattern),
    cmd = cmd,
    settings = settings,
    on_attach = on_attach
  }
end

return M
