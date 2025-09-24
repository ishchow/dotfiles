return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
      })
    end,
  },
}