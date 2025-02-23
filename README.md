# format.nvim

> _format.nvim_ is an asynchronous code formatting plugin for neovim.

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Configuration](#configuration)
- [Usage](#usage)
- [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Install

With [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```
require('plug').add({
    {
        'wsdjeg/format.nvim',
        cmds = { 'Format' },
    }
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

## Feedback

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/wsdjeg/format.nvim/issues)
