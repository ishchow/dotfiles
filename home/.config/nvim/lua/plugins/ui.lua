return
{
    ---@type LazySpec
    {
      "mikavilpas/yazi.nvim",
      version = "*", -- use the latest stable version
      event = "VeryLazy",
      enabled = not vim.g.neovide and vim.fn.executable("yazi") == 1, -- slow in neovide since neovide is not designed to run embedded terminals well
      dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
      },
      keys = {
        -- 👇 in this section, choose your own keymappings!
        {
          "<leader>-",
          mode = { "n", "v" },
          "<cmd>Yazi<cr>",
          desc = "Open yazi at the current file",
        },
        {
          -- Open in the current working directory
          "<leader>cw",
          "<cmd>Yazi cwd<cr>",
          desc = "Open the file manager in nvim's working directory",
        },
        {
          "<c-up>",
          "<cmd>Yazi toggle<cr>",
          desc = "Resume the last yazi session",
        },
      },
      ---@type YaziConfig | {}
      opts = {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = false,
        keymaps = {
          show_help = "<f1>",
        },
      },
      init = function()
      end,
    },
    {
      "rcarriga/nvim-notify",
      lazy = false,  -- load immediately (important if you want to override vim.notify early)
      priority = 1000,  -- load before most other plugins
      config = function()
        local notify = require("notify")

        -- Optionally configure notify (these are good defaults)
        notify.setup({
          stages = "fade",  -- animation style: "fade", "slide", "static", etc.
          timeout = 3000,   -- how long notifications stay (ms)
          background_colour = "#000000", -- fallback background color (useful for transparency)
        })

        -- Override the default vim.notify with nvim-notify
        vim.notify = notify
      end,
    }
}