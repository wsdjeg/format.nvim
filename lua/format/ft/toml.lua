local M = {}

function M.enabled()
  return { 'taplo', 'topiary' }
end

function M.taplo(opt)
  return {
    exe = 'taplo',
    args = { 'fmt', '-' },
    stdin = true,
  }
end

function M.topiary(opt)
  return {
    exe = 'topiary',
    stdin = true,
    args = { 'format', '--merge-configuration', '--language', 'toml' },
  }
end

return M
