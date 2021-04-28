#!/usr/bin/lua

local M = {}

local on_attach = function(client, bufnr)
  require('commonls_setup').common_on_attach(client, bufnr)
end

function M.setup()
    local root_makers = {'mvnw', 'gradlew', '.git', '.project'}
    local workspace =  os.getenv('HOME') .. '/.eclipselsp/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    local cmd = {'java-lsp', workspace}
    local root_dir = require('jdtls.setup').find_root(root_makers)

    local config = {
        cmd = cmd,
        root_dir = root_dir,
        on_attach = on_attach
    }

    require('jdtls').start_or_attach(config)
end

return M
