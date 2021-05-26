#!/usr/bin/lua

local M = {}

local xml2lua = require('xml2lua')
local handler = require('xmlhandler.tree')

local dotcp = xml2lua.loadFile('.classpath')
local parser = xml2lua.parser(handler)

local function get_name_and_path()
  parser:parse(dotcp)

  local classpath = handler.root.classpath

  if #classpath.classpathentry > 1 then
    classpath = classpath.classpathentry
  end

  local np = {}

  for i, cp in pairs(classpath) do
    if cp._attr.kind == 'lib' then
      local path
      local name

      if type(cp._attr.sourcepath) ~= 'nil' then
        path = cp._attr.sourcepath
      else
        path = cp._attr.path
      end

      name = string.match(path, '[^/]*$')
      np[i].name = name
      np[i].path = path
    end
  end

  return np
end

return M
