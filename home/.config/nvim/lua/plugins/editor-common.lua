return {
  {
    "nvim-mini/mini.pairs",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    }
  },
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
  },
  {
    "nvim-mini/mini.ai",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
  },
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
  {
    "nvim-mini/mini.comment",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  }
}
