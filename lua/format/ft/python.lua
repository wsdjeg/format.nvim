local M = {}

function M.enabled()
  return { 'yapf' }
end

function M.yapf(opt)
  return {
    exe = 'yapf',
    args = {},
    stdin = true,
  }
end

return M
