local M = {}

function M.enabled()
  return { 'gofmt' }
end

function M.gofmt(opt)
  return {
    exe = 'gofmt',
    args = {},
    stdin = true,
  }
end

return M

