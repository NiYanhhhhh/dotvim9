#!/usr/bin/lua

local M = {}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end
  local opts = {noremap = true, silent = true}

  require('commonls_setup').common_on_attach(client, bufnr)

  buf_set_keymap('n', '<leader>o', "<CMD>lua require('jdtls').organize_imports()<CR>", opts)
end

function M.setup()
  local root_makers = {'mvnw', 'gradlew', '.git', '.project'}
  local workspace = os.getenv('HOME') .. '/.eclipselsp/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local cmd = {'java-lsp', workspace}
  local root_dir = require('jdtls.setup').find_root(root_makers)

  local config = {filetypes = {'groovy', 'java'}, cmd = cmd, root_dir = root_dir, on_attach = on_attach}

  require('jdtls').start_or_attach(config)
end

return M
