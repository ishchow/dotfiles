-- [[ Plugin Configurations ]]

-- ============================================================================
-- Common Editor Plugins (VSCode + Native)
-- ============================================================================

-- Configure mini.pairs
require("mini.pairs").setup({
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
})

-- Configure mini.ai
local ai = require("mini.ai")
ai.setup({
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
})

-- Configure mini.surround
require("mini.surround").setup({
  mappings = {
    add = "gsa", -- Add surrounding in Normal and Visual modes
    delete = "gsd", -- Delete surrounding
    find = "gsf", -- Find surrounding (to the right)
    find_left = "gsF", -- Find surrounding (to the left)
    highlight = "gsh", -- Highlight surrounding
    replace = "gsr", -- Replace surrounding
    update_n_lines = "gsn", -- Update `n_lines`
  },
})

-- Configure mini.comment
require("mini.comment").setup({})

-- Configure mini.move
require("mini.move").setup({})

-- vim-repeat has no setup (just loaded)

-- ============================================================================
-- Native-Only Plugins
-- ============================================================================

if not vim.g.vscode then
  -- Configure eyeliner.nvim
  require("eyeliner").setup({
    highlight_on_key = true, -- highlight only after pressing f/F/t/T
    dim = false,             -- dimming other chars
  })

  -- Configure ts-comments.nvim (only if nvim >= 0.10.0)
  if vim.fn.has("nvim-0.10.0") == 1 then
    require("ts-comments").setup({})
  end

  -- Configure yazi.nvim
  require("yazi").setup({
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  })

  -- Configure fzf-lua
  require("fzf-lua").setup({})

  -- Check for required executables
  local os_utils = require("ishaat.os")
  os_utils.check_executable("yazi")
  os_utils.check_executable("fzf")
  os_utils.check_executable("rg")
  os_utils.check_executable("fd")
  os_utils.check_executable("bat")
  os_utils.check_executable("zoxide")

  -- Configure blink.cmp
  require('blink.cmp').setup({
    keymap = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    completion = { documentation = { auto_show = false } },
    sources = {
      default = { 'copilot', 'lsp', 'path', 'buffer' },
      providers = {
        copilot = {
          name = 'copilot',
          module = 'blink-copilot',
          score_offset = 100,
          async = true,
        },
      },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  })

  -- LSP: nvim-lspconfig provides base configs in its lsp/ directory.
  -- Override per-server settings in after/lsp/<server>.lua (see :h lsp-config).
  -- List servers to enable here:
  vim.lsp.enable({
    'lua_ls',
    'marksman',
    'copilot',
  })
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
