-- This spec is for pluings that we want to run only when neovim is running natively and not embedded in another editor (ex. vscode)
return {
  {
    "jinh0/eyeliner.nvim",
    config = function()
      require("eyeliner").setup {
        highlight_on_key = true, -- highlight only after pressing f/F/t/T
        dim = false,             -- dimming other chars
      }
    end,
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  }
}
