local M = {}

function M.enabled()
  return { 'prettier' }
end

function M.prettier(opt)
  return {
    exe = 'prettier',
    name = 'prettier',
    args = {'--parser', 'markdown'},
    stdin = true
  }
end

return M
