vim.api.nvim_create_user_command('Format', function(opts)
  require('format').format(opts.bang, opts.args, opts.line1, opts.line2)
end, {
  nargs = '*',
  range = '%',
  bang = true,
  bar = true,
  complete = function(_, line)
    local ft = vim.o.filetype
    local l = vim.split(line, '%s+')
    local ok, default = pcall(require, 'format.ft.' .. ft)
    if ok then
      return vim.tbl_filter(function(val)
        return vim.startswith(val, l[#l])
      end, default.enabled())
    else
    end
  end,
})

vim.api.nvim_create_user_command('FormatWrite', function(opts)
  require('format').format(opts.bang, opts.args, opts.line1, opts.line2, {
    hooks = {
      post = function(buf)
        vim.api.nvim_buf_call(buf, vim.cmd.write)
      end,
    },
  })
end, {
  nargs = '*',
  range = '%',
  bang = true,
  bar = true,
  complete = function(_, line)
    local ft = vim.o.filetype
    local l = vim.split(line, '%s+')
    local ok, default = pcall(require, 'format.ft.' .. ft)
    if ok then
      return vim.tbl_filter(function(val)
        return vim.startswith(val, l[#l])
      end, default.enabled())
    else
    end
  end,
})
