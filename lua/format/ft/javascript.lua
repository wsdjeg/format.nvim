local M = {}

function M.enabled()
  return { 'jsbeautify' }
end

function M.jsbeautify(opt)
  return {
    exe = 'js-beautify',
    args = { '--indent-size ' .. vim.fn.shiftwidth() },
    stdin = true,
  }
end

return M
