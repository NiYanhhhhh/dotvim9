#!/usr/bin/lua

local M = {}

function M.common_on_attach(client, bufnr)
  if client.resolved_capabilities.document_highlight then
      vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightBlue
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightBlue
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightBlue
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          autocmd CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]], false)
  end
end

return M
