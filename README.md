# format.nvim

[![Run Tests](https://github.com/wsdjeg/format.nvim/actions/workflows/test.yml/badge.svg)](https://github.com/wsdjeg/format.nvim/actions/workflows/test.yml)
[![GitHub License](https://img.shields.io/github/license/wsdjeg/format.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/format.nvim)](https://github.com/wsdjeg/format.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/format.nvim)](https://github.com/wsdjeg/format.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/format.nvim)](https://github.com/wsdjeg/format.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/format.nvim)](https://luarocks.org/modules/wsdjeg/format.nvim)

**format.nvim** is an asynchronous code formatting plugin for neovim.
By using `nvim_buf_get_lines` api, format.nvim is able to format the buffer which has not been saved.
On a formatter success It will update current buffer via `nvim_buf_set_lines`, and marks, jumps, etc.
are all maintained after formatting.

<!-- vim-markdown-toc GFM -->

- [Features](#features)
- [Install](#install)
    - [nvim-plug](#nvim-plug)
    - [lazy.nvim](#lazynvim)
    - [LuaRocks](#luarocks)
- [Configuration](#configuration)
- [Usage](#usage)
    - [Commands](#commands)
    - [Format on save](#format-on-save)
    - [Range formatting](#range-formatting)
    - [Embedded code block formatting](#embedded-code-block-formatting)
    - [Before/after format hooks](#beforeafter-format-hooks)
    - [Lock buffer when formatting](#lock-buffer-when-formatting)
- [Custom Formatter](#custom-formatter)
- [Default Formatters](#default-formatters)
- [How It Works](#how-it-works)
- [Debug](#debug)
- [Self-Promotion](#self-promotion)
- [Feedback](#feedback)
- [Credits](#credits)

<!-- vim-markdown-toc -->

## Features

- **Async** — formatters run in background via [job.nvim](https://github.com/wsdjeg/job.nvim), no UI blocking
- **No temp files** — buffer content is piped via stdin, unsaved buffers work seamlessly
- **Auto-fallback** — each filetype has an ordered formatter list; the first available executable wins
- **Range formatting** — format a visual selection or arbitrary line range
- **Buffer lock** — optionally lock the buffer during formatting to prevent edit conflicts
- **Hooks** — run custom `pre`/`post` functions before and after formatting
- **Custom formatters** — register your own formatters per filetype via `setup()`
- **Marks preserved** — marks, jumps, and folds are maintained after formatting
- **Lightweight** — minimal dependencies, pure Lua, no LSP required

## Install

### nvim-plug

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

### lazy.nvim

```lua
{
  'wsdjeg/format.nvim',
  cmd = { 'Format', 'FormatWrite', 'FormatLock', 'FormatWriteLock' },
  dependencies = {
    'wsdjeg/job.nvim',
    'wsdjeg/notify.nvim',
  },
  config = function()
    require('format').setup({})
  end,
}
```

### LuaRocks

```sh
luarocks install format.nvim
```

> **Dependencies:**
> - [job.nvim](https://github.com/wsdjeg/job.nvim) — async job execution (required)
> - [notify.nvim](https://github.com/wsdjeg/notify.nvim) — notification display (required)
> - [logger.nvim](https://github.com/wsdjeg/logger.nvim) — debug logging (optional)

## Configuration

```lua
require('format').setup({
  -- register custom formatters per filetype
  custom_formatters = {
    lua = {
      exe = 'stylua',
      args = { '-' },
      stdin = true,
    },
  },
  -- timeout in milliseconds (default: 5000)
  timeout = 5000,
})
```

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `:Format` | Format current buffer or selected range |
| `:FormatWrite` | Format and write the buffer to disk |
| `:FormatLock` | Format with buffer locked during formatting |
| `:FormatWriteLock` | Format + write with buffer locked |

Use `!` to force a specific filetype: `:Format! python`

Use a formatter name to pick one explicitly: `:Format stylua`

### Format on save

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

### Range formatting

In visual mode, select lines and run:

```
:'<,'>Format
```

Or specify line numbers directly:

```
:10,20Format
```

### Embedded code block formatting

Format code blocks inside markdown files using [context_filetype.vim](https://github.com/Shougo/context_filetype.vim):

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

Example — register a custom formatter for TypeScript:

```lua
require('format').setup({
  custom_formatters = {
    typescript = {
      exe = 'prettier',
      args = { '--stdin-filepath', vim.fn.expand('%:p') },
      stdin = true,
    },
  },
})
```

## Default Formatters

| Language | Formatters | Notes |
|----------|-----------|-------|
| C | uncrustify, clang-format, astyle | auto-fallback to first available |
| Lua | stylua | |
| Python | yapf | |
| Rust | rustfmt | |
| Go | gofmt | |
| JSON | prettier | |
| Markdown | prettier | `--parser markdown` |
| JavaScript | js-beautify | respects `shiftwidth()` |
| Java | astyle | `--mode=java` |
| Assembly | asmfmt | |
| Elixir | mix format | `mix format -` |
| TOML | taplo, topiary | auto-fallback to first available |

## How It Works

1. Reads buffer lines via `nvim_buf_get_lines` (no file save needed)
2. Finds the first available formatter for the current filetype
3. Pipes buffer content to the formatter via stdin (async, via job.nvim)
4. Collects formatted output and replaces buffer lines via `nvim_buf_set_lines`
5. Preserves marks, jumps, folds, and undo history

```
Buffer ──nvim_buf_get_lines──▶ stdin ──▶ formatter ──▶ stdout ──▶ nvim_buf_set_lines──▶ Buffer
```

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

