local M = {}

function M.enabled()
  return { 'asmfmt' }
end

function M.asmfmt(opt)
  return {
    exe = 'asmfmt',
    args = {},
    stdin = true,
  }
end

return M


