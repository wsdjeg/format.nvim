# format.nvim

**format.nvim** is an asynchronous code formatting plugin for neovim.
By using `nvim_buf_get_lines` api, format.nvim is able to format the buffer which has not been saved.
On a formatter success It will update current buffer via `nvim_buf_set_lines`, and marks, jumps, etc.
are all maintained after formatting.

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Configuration](#configuration)
- [Usage](#usage)
    - [Before/after format hooks](#beforeafter-format-hooks)
    - [Lock buffer when formatting](#lock-buffer-when-formatting)
- [Custom Formatter](#custom-formatter)
- [Debug](#debug)
- [Default formatters](#default-formatters)
- [Self-Promotion](#self-promotion)
- [Feedback](#feedback)
- [Credits](#credits)

<!-- vim-markdown-toc -->

## Install

With [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
  {
    'wsdjeg/format.nvim',
    cmds = { 'Format' },
    depends = {
      { 'wsdjeg/job.nvim' },
      { 'wsdjeg/notify.nvim' },
    },
  },
})
```

## Configuration

```lua
require('format').setup({
  custom_formatters = {
    lua = {
      exe = 'stylua',
      args = { '-' },
      stdin = true,
    },
  },
  timeout = 5000,
})
```

## Usage

1. format current buffer or selected text.

```
:Format
```

2. format code block in markdown file.

```lua
require('plug').add({
  {
    'wsdjeg/format.nvim',
    config = function()
      require('format').setup({
        custom_formatters = {
          lua = {
            exe = 'stylua',
            args = { '-' },
            stdin = true,
          },
        },
      })
    end,
    config_before = function()
      vim.keymap.set('n', '<leader>lf', function()
        local cf = vim.call('context_filetype#get')
        if vim.o.filetype == 'markdown' and cf.filetype ~= 'markdown' then
          local line1 = cf['range'][1][1]
          local line2 = cf['range'][2][1]
          vim.cmd(string.format('%s,%sFormat! %s', line1, line2, cf.filetype))
        end
      end, { silent = true, desc = 'format code block' })
    end,
    cmds = { 'Format' },
    depends = { { 'Shougo/context_filetype.vim' } },
  },
})
```

3. format code when save file.

```lua
local augroup = vim.api.nvim_create_augroup('format_on_save', { clear = true })

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  group = augroup,
  callback = function(_)
    vim.cmd('FormatWrite')
  end,
})
```

### Before/after format hooks

This feature is inspired by formatter.nvim, instead of using User autocmd, format.nvim uses functions.

```lua
require('format').format(bang, user_input, start_line, end_line, {
  hooks = {
    pre = function(buf) end,
    post = function(buf) end,
  },
})
```

### Lock buffer when formatting

Using `FormatLock` or `FormatWriteLock` commands instead of `Format` or `FormatWrite`, format.nvim will lock the buffer when formatting.

## Custom Formatter

| name    | description                                        | optional/required |
| ------- | -------------------------------------------------- | ----------------- |
| `exe`   | `string`, formatter executable or path             | required          |
| `args`  | `table<string>`, list of arguments                 | optional          |
| `stdin` | `boolean`, send data to the stdin of the formatter | optional          |

## Debug

If you want to read the runtime log of format.nvim, you need to install [logger.nvim](http://github.com/wsdjeg/logger.nvim).

```lua
require('plug').add({
  {
    'wsdjeg/format.nvim',
    depends = {
      {
        'wsdjeg/job.nvim',
      },
      {
        'wsdjeg/notify.nvim',
      },
      {
        'wsdjeg/logger.nvim',
      },
    },
  },
})
```

```
[ 15:02:25:277 ] [ Info  ] [ format.nvim ] using custom formatter:stylua
[ 15:02:25:277 ] [ Info  ] [ format.nvim ] running formatter: stylua
[ 15:02:25:331 ] [ Info  ] [ format.nvim ] formatter: stylua exit code:0 single:0
[ 15:03:59:481 ] [ Info  ] [ format.nvim ] using default formatter:prettier
[ 15:03:59:482 ] [ Info  ] [ format.nvim ] running formatter: D:\Scoop\apps\nodejs\current\bin\prettier.CMD
[ 15:04:00:340 ] [ Info  ] [ format.nvim ] formatter: prettier exit code:0 single:0
```

## Default formatters

- c: uncrustify, clangformat, astyle
- rust: rustfmt
- markdown: prettier
- json: prettier
- python: yapf
- go: gofmt

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## Feedback

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/wsdjeg/format.nvim/issues)

## Credits

- [sbdchd/neoformat](https://github.com/sbdchd/neoformat)
- [google/vim-codefmt](https://github.com/google/vim-codefmt)
- [vim-autoformat](https://github.com/vim-autoformat/vim-autoformat)
- [mhartington/formatter.nvim](https://github.com/mhartington/formatter.nvim)
- [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)
