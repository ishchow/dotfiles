return {
  { "numToStr/Comment.nvim", opts = {} },
  { "tpope/vim-surround", },
  {
    "phaazon/hop.nvim",
    opts = {},
    keys = {
      { "<leader>ha", "<cmd>HopAnywhere<cr>", mode = {"n", "v"}, desc = "Hop: Anywhere" },
      { "<leader>ho", "<cmd>HopChar1<cr>", mode = {"n", "v"}, desc = "Hop: 1 Character Search" },
      { "<leader>ht", "<cmd>HopChar2<cr>", mode = {"n", "v"}, desc = "Hop: 2 Character Search" },
      { "<leader>hl", "<cmd>HopLine<cr>", mode = {"n", "v"}, desc = "Hop: Line" },
      { "<leader>hs", "<cmd>HopLineStart<cr>", mode = {"n", "v"}, desc = "Hop: Line Start" },
      { "<leader>hv", "<cmd>HopVertical<cr>", mode = {"n", "v"}, desc = "Hop: Vertical" },
      { "<leader>hp", "<cmd>HopPattern<cr>", mode = {"n", "v"}, desc = "Hop: Pattern" },
      { "<leader>hw", "<cmd>HopWord<cr>", mode = {"n", "v"}, desc = "Hop: Word" },
    }
  }
}
