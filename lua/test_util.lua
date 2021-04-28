#!/usr/bin/lua

local M = {}

function M.expand(tab, flag)
  if type(tab) == 'string' or type(tab) == 'number' or type(tab) == 'function' then
    print(flag .. ': ' .. tab)
  elseif type(tab) == 'boolean' then
    if tab then
      print(flag .. ': ' .. 'true')
    else
      print(flag .. ': ' .. 'false')
    end
  elseif type(tab) == 'table' then
    if flag then
      print(flag .. ": ")
    end
    for k, v in pairs(tab) do
      M.expand(k, 'k')
      M.expand(v, 'v')
    end
  else
    print(flag .. ': ' .. type(tab))
  end
end

return M
