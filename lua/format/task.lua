local M = {}

local jobid = -1
local timeoutid = -1

local job = require('job')
local util = require('format.util')

local stdout = {}
local stderr = {}
local current_task

local hooks

local function on_stdout(id, data)
  for _, v in ipairs(data) do
    table.insert(stdout, v)
  end
end

local function on_stderr(id, data)
  for _, v in ipairs(data) do
    table.insert(stderr, v)
  end
end

local function on_exit(id, code, single)
  util.info(
    'formatter: '
      .. (current_task.formatter.name or current_task.formatter.exe)
      .. ' exit code:'
      .. code
      .. ' single:'
      .. single
  )
  if code == 0 and single == 0 then
    local formatted_context
    if current_task.formatter.use_stderr then
      formatted_context = stderr
    else
      formatted_context = stdout
    end
    if table.concat(formatted_context, '\n') == table.concat(current_task.stdin, '\n') then
      util.msg('no necessary changes')
    else
      util.msg((current_task.formatter.name or current_task.formatter.exe) .. ' formatted buffer')
      vim.api.nvim_buf_set_lines(
        current_task.bufnr,
        current_task.start_line,
        current_task.end_line,
        false,
        formatted_context
      )
      if current_task.hooks and current_task.hooks.post then
        current_task.hooks.post(current_task.bufnr)
      end
    end
  else
    util.msg('formatter ' .. current_task.formatter.exe .. ' failed to run')
  end
  if timeoutid >= 0 then
    vim.fn.timer_stop(timeoutid)
    timeoutid = -1
  end

  jobid = -1
end

local function task_timeout(t)
  job.stop(jobid)
end

---@param task FormatTask
function M.run(task)
  if jobid > 0 then
    util.msg('previous formatting command has not ended')
    return
  end

  if task.hooks and task.hooks.pre then
    task.hooks.pre(task.bufnr)
  end

  util.info('running formatter: ' .. task.formatter.exe)

  local cmd = { task.formatter.exe }
  for _, v in ipairs(task.formatter.args) do
    table.insert(cmd, v)
  end
  stdout = {}
  stderr = {}
  current_task = task
  util.info('cmd: ' .. vim.inspect(cmd))
  jobid = job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })

  if jobid == -1 then
    return util.msg('formatter is not executable: ' .. task.formatter.exe)
  end

  if task.formatter.stdin then
    job.send(jobid, task.stdin)
    job.send(jobid, nil)
  end
  timeoutid = vim.fn.timer_start(task.timeout, task_timeout, { ['repeat'] = 1 })
end
return M
