local M = {}

local npairs = require "nvim-autopairs"
local Rule = require "nvim-autopairs.rule"

M.setup = function ()
  local cfg = {}
  npairs.setup(cfg)
  npairs.add_rules({
    Rule("$", "$", {"tex", "markdown"})
  })
end


return M
