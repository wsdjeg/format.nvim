local M = {}

function M.enabled()
  return { 'mixformat' }
end

function M.mixformat(opt)
  return {
    exe = 'mix',
    args = { 'format', '-' },
    stdin = true,
  }
end

return M
