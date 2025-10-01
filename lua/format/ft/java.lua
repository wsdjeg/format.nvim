local M = {}

function M.enabled()
  return { 'astyle' }
end

function M.astyle(opt)
  return {
    exe = 'astyle',
    args = {'--mode=java'},
    stdin = true,
  }
end

return M

