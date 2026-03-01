-- This file handles early UI setup for native Neovim
-- Wrapped in VSCode guard since UI plugins are native-only

if not vim.g.vscode then
  -- Load colorscheme first (priority)
  require("catppuccin").setup({ flavour = "mocha" })
  vim.cmd.colorscheme("catppuccin-mocha")

  -- Setup notify and override vim.notify (priority)
  local notify = require("notify")
  notify.setup({
    stages = "fade",
    timeout = 3000,
    background_colour = "#000000",
  })
  vim.notify = notify
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
