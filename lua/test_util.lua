#!/usr/bin/lua

local test = {}

function test.expand(tab, flag, depth)
  if not depth then
    depth = 0
  end

  if type(tab) == 'string' or type(tab) == 'number' or type(tab) == 'function' or type(tab) == 'boolean' then
    if type(tab) == 'boolean' then
      tab = tostring(tab)
    end
    print(string.rep('  ', depth) .. flag .. ': ' .. tab)
  elseif type(tab) == 'table' then
    if flag then
      print(string.rep('  ', depth) .. flag .. ": ")
    end
    for k, v in pairs(tab) do
      if not (type(k) == 'number' and (type(v) == 'nil' or (type(v) == 'table' and vim.tbl_isempty(v)))) then
        test.expand(k, 'k', depth + 1)
        test.expand(v, 'v', depth + 1)
      end
    end
  else
    print(flag .. ': ' .. type(tab))
  end
end

-- local test_tab = {
  -- 1,
  -- false,
  -- nil,
  -- subkey = 'apple',
  -- tab = {
    -- key = 'orange'
  -- },
  -- null = nil,
-- }
-- test.expand(test_tab)

return test
