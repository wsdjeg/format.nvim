local M = {}
local nt = require('notify')

local log = require('format.log')

function M.msg(msg)
  nt.notify(msg)
end

function M.info(msg)
  log.info(msg)
end

return M
