local M = {}
local nt = require('notify')

local log = require('format.log')
--- display message via notify
function M.msg(msg)
  nt.notify(msg)
end

--- log message via logger.nvim
function M.info(msg)
  log.info(msg)
end

return M
