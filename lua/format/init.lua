local M = {}

local util = require('format.util')
local task = require('format.task')

local timeout = 5000

local custom_formatters = {}

---@param bang boolean
---@param user_input string
---@param start_line number
---@param end_line number
function M.format(bang, user_input, start_line, end_line, opts)
  if not vim.o.modifiable then
    return util.msg('buffer is not modifiable!')
  end

  opts = opts or {}

  local ok, formatter

  local filetype = vim.o.filetype
  local argvs = vim.split(user_input, '%s+', { trimempty = true })
  if bang and #argvs > 0 then
    filetype = argvs[1]
  end

  if filetype == '' then
    return util.msg('format: skip empty filetype')
  end

  if (not bang and #argvs > 0) or (#argvs > 1) then
    local formatter_name
    ok = pcall(function()
      local default = require('format.ft.' .. filetype)
      if bang then
        formatter_name = argvs[2]
      else
        formatter_name = argvs[1]
      end
      formatter = default[formatter_name]({
        filepath = vim.fn.expand('%:p'),
        start_line = start_line,
        end_line = end_line,
      })
      if vim.fn.executable(formatter.exe) == 1 then
        util.info('using specific formatter:' .. formatter_name)
      else
        return util.msg(formatter.exe .. ' is not executable!')
      end
    end)
    if not ok then
      return util.msg('formatter ' .. formatter_name .. ' is not defined.')
    end
  end

  if not formatter and custom_formatters[filetype] then
    formatter = custom_formatters[filetype]
    if formatter.exe and type(formatter.exe) == 'string' then
      util.info('using custom formatter:' .. formatter.exe)
    end
  end

  if not formatter then
    ok = pcall(function()
      local default = require('format.ft.' .. filetype)
      for _, formatname in ipairs(default.enabled()) do
        formatter = default[formatname]({
          filepath = vim.fn.expand('%:p'),
          start_line = start_line,
          end_line = end_line,
        })
        if vim.fn.executable(formatter.exe) == 1 then
          util.info('using default formatter:' .. formatname)
          break
        else
          util.info(formatter.exe .. ' is not executable.')
          formatter = nil
        end
      end
    end)
    if not formatter then
      return util.msg('no formatter for ' .. filetype)
    end
  end

  local indent = 0

  if start_line > 1 then
    indent = vim.fn.matchstr(vim.fn.getline(start_line - 1), '^\\s*')
  end

  task.run({
    bufnr = vim.fn.bufnr(),
    stdin = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false),
    start_line = start_line - 1,
    end_line = end_line,
    formatter = formatter,
    timeout = timeout,
    hooks = opts.hooks,
    lock_buf = opts.lock_buf,
    indent = indent,
  })
end

function M.setup(opt)
  if opt.custom_formatters and type(opt.custom_formatters) == 'table' then
    for k, v in pairs(opt.custom_formatters) do
      if type(v) == 'table' then
        custom_formatters[k] = v
      end
    end
  end
  timeout = opt.timeout or timeout
end

return M
