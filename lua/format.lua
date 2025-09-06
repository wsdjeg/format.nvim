local M = {}

local util = require('format.util')
local task = require('format.task')

local custom_formatters = {}

---@param bang boolean
---@param user_input string
---@param start_line number
---@param end_line number
function M.format(bang, user_input, start_line, end_line)
  if not vim.o.modifiable then
    return util.msg('buffer is not modifiable!')
  end

  local ok, formatter

  local filetype = vim.o.filetype
  local argvs = vim.split(user_input, '%s+')
  if bang and #argvs > 0 then
    filetype = argvs[1]
  elseif not bang and #argvs > 0 then
    ok = pcall(function()
      local default = require('format.ft.' .. filetype)
      formatter = default[argvs[1]]({
        filepath = vim.fn.expand('%:p'),
        start_line = start_line,
        end_line = end_line,
      })
      if vim.fn.executable(formatter.exe) == 1 then
        util.info('using specific formatter:' .. argvs[1])
      else
          return util.msg(argvs[1] ..' is not executable!')
      end
    end)
    if not ok then
      return util.msg('formatter ' .. argvs[1] .. ' is not defined.')
    end
  end

  if filetype == '' then
    return util.msg('format: skip empty filetype')
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
        end
      end
    end)
    if not ok then
      return util.msg('no formatter for ' .. filetype)
    end
  end

  task.run({
    bufnr = vim.fn.bufnr(),
    stdin = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false),
    start_line = start_line - 1,
    end_line = end_line,
    formatter = formatter,
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
end

return M
