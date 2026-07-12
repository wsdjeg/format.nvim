-- test/notify.lua
-- Mock notify module for tests
-- Provides a minimal notify.notify() function so format.util can load

local M = {}

--- Display message (mock: just print to stdout)
---@param msg string
function M.notify(msg)
  print('[notify] ' .. tostring(msg))
end

return M

