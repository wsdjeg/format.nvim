# format.nvim

> _format.nvim_ is an asynchronous code formatting plugin for neovim.

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

<!-- vim-markdown-toc GFM -->

* [Install](#install)
* [Configuration](#configuration)
* [Usage](#usage)
* [Self-Promotion](#self-promotion)
* [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Install

With [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
  {
    'wsdjeg/format.nvim',
    cmds = { 'Format' },
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
})
```

## Usage

- `:Format`: format current buffer

format code block in markdown:

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
      vim.keymap.set('n', '<leader>bf', '<cmd>Format<cr>', { silent = true })
      vim.keymap.set('n', '<leader>lf', function()
        local cf = vim.call('context_filetype#get')
        if vim.o.filetype == 'markdown' and cf.filetype ~= 'markdown' then
          local line1 = cf['range'][1][1]
          local line2 = cf['range'][2][1]
          vim.cmd(string.format('%s,%sFormat! %s', line1, line2, cf.filetype))
        end
      end, { silent = true })
    end,
    cmds = { 'Format' },
    depends = { { 'Shougo/context_filetype.vim' } },
  },
})
```

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg) and
[Twitter](http://twitter.com/wsdtty).

## Feedback

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/wsdjeg/format.nvim/issues)
