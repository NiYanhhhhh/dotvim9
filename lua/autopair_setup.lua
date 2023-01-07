local M = {}

local npairs = require "nvim-autopairs"

M.setup = function ()
  local cfg = {}
  npairs.setup(cfg)
end

return M
