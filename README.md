# 🛝 JSPlayground

\[image\]

> Simple playground for JavaScript using node.js

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

## Configuration

Coming soon... maybe

## Commands

| Command | Description |
| --- | --- |
| `JSPlayground` | Short for `JSPlayground run` |
| `JSPlayground run` | Run/Rerun JSPlayground |
| `JSPlayground stop` | Stop JSPlayground |
