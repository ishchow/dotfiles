-- This file is for plugins that we want to run only when neovim is running natively and not embedded in another editor (ex. vscode)

-- Configure eyeliner.nvim
require("eyeliner").setup({
  highlight_on_key = true, -- highlight only after pressing f/F/t/T
  dim = false,             -- dimming other chars
})

-- Configure ts-comments.nvim (only if nvim >= 0.10.0)
if vim.fn.has("nvim-0.10.0") == 1 then
  require("ts-comments").setup({})
end
