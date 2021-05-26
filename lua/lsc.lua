#!/usr/bin/lua

local M = {}

local request = vim.lsp.buf_request_sync
local command = vim.api.nvim_command
local util = vim.lsp.util
local api = vim.api

local loclist_type_map = {
  [vim.lsp.protocol.DiagnosticSeverity.Error] = 'E',
  [vim.lsp.protocol.DiagnosticSeverity.Warning] = 'W',
  [vim.lsp.protocol.DiagnosticSeverity.Information] = 'I',
  [vim.lsp.protocol.DiagnosticSeverity.Hint] = 'I'
}


-- @private
-- to fix position problem which cause wrong character
-- local function get_character(extra_str)
-- local row, col = unpack(api.nvim_win_get_cursor(0))
-- row = row - 1
-- local line = api.nvim_buf_get_lines(0, row, row+1, true)[1]
-- if not line then
-- return { line = 0; character = 0; }
-- end
-- col = vim.str_utfindex(line .. extra_str, col + string.len(extra_str))
-- return { line = row; character = col; }
-- end

local function get_complete(prefix)
  local ms_wait = vim.g.deoplete_nvimlsp_wait or 200
  local params = util.make_position_params()
  local bufnr = api.nvim_get_current_buf()
  local result_str = ''
  local respond = request(bufnr, 'textDocument/completion', params, ms_wait)
  local err = ''
  local result_table = {}

  if not respond then
    return ''
  end

  for id, result in pairs(respond) do
    if not id or not result.result then
      return ''
    end

    if not result.result.isIncomplete then
      local item_table = util.text_document_completion_list_to_complete_items(result.result, prefix)

      vim.list_extend(result_table, item_table)
    else
      -- TODO: logic when result is incomplete
    end
  end

  local results = {}
  for _, item in ipairs(result_table) do
    repeat
      local result = {}
      -- FIXME:if the kind is 'Snippet', there's no way to implement
      -- the Snippet feature through vim complete fucntion
      if item['kind'] == 'Snippet' then
        print(item['word'])
        item['word'] = vim.fn.matchstr(item['word'], '\\w*')
      end
      for key, value in pairs(item) do
        if key == 'user_data' then
          value = ""
        end
        table.insert(result, string.format("'%s'", key) .. ": " .. string.format("'%s'", value))
      end
      table.insert(results, '{' .. table.concat(result, ', ') .. '}')
    until true
  end

  result_str = table.concat(results, ', ')

  return result_str
end

function M.complete(findstart, base)
  local has_buffer_clients = not vim.tbl_isempty(vim.lsp.buf_get_clients())
  if not has_buffer_clients then
    if findstart == 1 then
      return -2
    else
      return {}
    end
  end

  local pos = api.nvim_win_get_cursor(0)
  local line = api.nvim_get_current_line()
  local line_to_cursor = line:sub(1, pos[2])
  local textMatch = vim.fn.match(line_to_cursor, '\\k*$')

  local prefix = line_to_cursor:sub(textMatch + 1)

  if findstart == 1 then
    Matches = get_complete(prefix)
    command('return ' .. textMatch)
  else
    command('return [' .. Matches .. ']')
  end
end

function M.set_all_loclist()

  local diags = vim.lsp.diagnostic.get_all()

  local items = {}
  local insert_diag = function(diag, bufnr)
    local pos = diag.range.start
    local row = pos.line
    local col = util.character_offset(bufnr, row, pos.character)

    local line = (api.nvim_buf_get_lines(bufnr, row, row + 1, false) or {""})[1]

    table.insert(items, {
      bufnr = bufnr,
      lnum = row + 1,
      col = col + 1,
      text = line .. " | " .. diag.message,
      type = loclist_type_map[diag.severity or vim.lsp.protocol.DiagnosticSeverity.Error] or 'E'
    })
  end

  for bufnr, buffer_diags in pairs(diags) do
    for _, diag in ipairs(buffer_diags) do
      insert_diag(diag, bufnr)
    end
  end

  table.sort(items, function(a, b)
    return a.bufnr < b.bufnr or a.lnum < b.lnum
  end)
  util.set_loclist(items)

  vim.cmd [[lopen]]
end

function M.test_item()
  command('echom "test_item:"')
  local pos = api.nvim_win_get_cursor(0)
  local line = api.nvim_get_current_line()
  local line_to_cursor = line:sub(1, pos[2])
  local textMatch = vim.fn.match(line_to_cursor, '\\k*$')

  local prefix = line_to_cursor:sub(textMatch + 1)

  command("echom \"" .. get_complete(prefix) .. "\"")
  print('test_item end')
end

return M
