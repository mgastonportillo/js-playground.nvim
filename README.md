# 🛝 JSPlayground

![Preview](https://github.com/mgastonportillo/js-playground.nvim/assets/106234166/6e8fa5a6-4ea9-4e93-8930-05dd8f1cdc3d)

> Simplest playground for JavaScript using node.js

## Installation

Lazy:

```lua
{
  "mgastonportillo/js-playground.nvim",
  dependencies = { "rcarriga/nvim-notify" }, -- optional: custom notifications
  cmd = "JSPlayground",
  init = function()
    -- example mappings
    vim.keymap.set("n", "<leader>jp", "<cmd>JSPlayground<CR>", { desc = "Run JSPlayground" })
    vim.keymap.set("n", "<leader>jx", "<cmd>JSPlayground stop<CR>", { desc = "Stop JSPlayground" })
  end
  opts = {}, -- or config = true
}
```

It is recommended to use [edgy.nvim](https://github.com/folke/edgy.nvim) for a nicer UI. Example:

```lua
{
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    right = {
      { ft = "jsplayground", title = "JS Playground", size = { width = 0.45 } },
    },
  },
}
```

## Configuration

Coming soon... maybe

## Commands

| Command | Description |
| --- | --- |
| `JSPlayground` | Short for `JSPlayground run` |
| `JSPlayground run` | Run/Rerun JSPlayground |
| `JSPlayground stop` | Stop JSPlayground |
