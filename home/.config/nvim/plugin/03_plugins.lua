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
  -- Replace the nvim-web-devicons stub from 01_pack.lua with the real mock
  require('mini.icons').mock_nvim_web_devicons()

  -- Check for required executables
  local os_utils = require("ishaat.os")
  os_utils.check_executable("yazi")
  os_utils.check_executable("broot")
  os_utils.check_executable("fzf")
  os_utils.check_executable("rg")
  os_utils.check_executable("fd")
  os_utils.check_executable("bat")
  os_utils.check_executable("zoxide")

  -- Configure which-key.nvim
  local wk = require("which-key")
  wk.setup({
    icons = {
      provider = "mini.icons",
    },
    plugins = {
      marks = false,
      registers = false,
      spelling = { enabled = false },
    },
  })
  wk.add({
    { "<leader>b", group = "Buffer" },
    { "<leader>e", group = "Explore/Edit" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>l", group = "Language" },
    { "<leader>o", group = "Other" },
    { "<leader>t", group = "Terminal" },
    { "<leader>ta", desc = "Agency Copilot" },
  })

  -- Configure eyeliner.nvim
  require("eyeliner").setup({
    highlight_on_key = true, -- highlight only after pressing f/F/t/T
    dim = false,             -- dimming other chars
  })

  -- Configure ts-comments.nvim (only if nvim >= 0.10.0)
  if vim.fn.has("nvim-0.10.0") == 1 then
    require("ts-comments").setup({})
  end

  -- Configure vim-table-mode for markdown-friendly tables.
  -- NOTE: vim.g.table_mode_disable_mappings and vim.g.table_mode_corner
  -- are set in 01_pack.lua (before vim.pack.add) so they take effect
  -- before the plugin loads.

  -- Disable netrw to prevent it from loading behind yazi
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- Configure broot (custom module — uses conf-nvim.hjson for neovim-specific verbs)
  local broot_conf_dir
  if vim.fn.has("win32") == 1 then
    broot_conf_dir = vim.fn.expand("$APPDATA/dystroy/broot/config")
  else
    broot_conf_dir = vim.fn.expand("~/.config/broot")
  end
  require("ishaat.broot").setup({
    conf_path = broot_conf_dir .. "/conf-nvim.hjson",
  })

  -- Configure yazi.nvim
  require("yazi").setup({
    open_for_directories = true,
    keymaps = {
      show_help = "<f1>",
    },
  })

  -- Configure fzf-lua (max-perf: disables git/file icons for speed)
  require("fzf-lua").setup({
    "max-perf",
    -- Override max-perf's native fzf previewer back to the builtin Neovim previewer.
    previewer = "builtin",
    winopts = {
      width = 0.95,
      height = 0.95,
    },
    -- Keep picker navigation explicit to avoid terminal/fzf variance on Windows.
    keymap = {
      fzf = {
        ["up"] = "up",
        ["down"] = "down",
        ["ctrl-p"] = "up",
        ["ctrl-n"] = "down",
      },
    },
    -- Use fd explicitly for fastest file finding.
    -- Start with preview hidden for file list pickers (toggle with F4).
    files = {
      winopts = { preview = { hidden = "hidden" } },
    },
    git = { files = { winopts = { preview = { hidden = "hidden" } } } },
  })

  -- Register fzf-lua as the vim.ui.select backend
  require("fzf-lua").register_ui_select()

  -- Custom picker: git submodules — select a submodule and cd into it.
  _G.git_submodules = function(opts)
    local fzf_lua = require("fzf-lua")
    local ansi = fzf_lua.utils.ansi_codes
    opts = opts or {}
    opts.prompt = "Git Submodules> "
    local function strip_ansi(s)
      return s:gsub("\27%[[%d;]*m", "")
    end
    local function parse_path(selected)
      return vim.trim(strip_ansi(selected[1]))
    end
    opts.actions = {
      ["default"] = function(selected)
        local p = parse_path(selected)
        vim.cmd.cd(p)
        vim.notify("cd " .. vim.fn.getcwd(), vim.log.levels.INFO)
      end,
      ["ctrl-e"] = function(selected)
        fzf_lua.files({ cwd = parse_path(selected) })
      end,
    }
    opts.preview = {
      type = "cmd",
      fn = function(items)
        local p = vim.trim(strip_ansi(items[1]))
        if p == "" then return "echo 'No submodule path'" end
        return string.format("git -C %s log --oneline -15 2>&1 || echo 'not a git repo'",
          vim.fn.shellescape(p))
      end,
    }
    -- Avoid `git submodule status` (slow — checks SHA of every submodule).
    -- Instead, read initialized names from .git/config and map to paths via .gitmodules.
    -- Both are instant config reads (~0.1s vs ~2s for `status`).
    local init = vim.system(
      { "git", "config", "--get-regexp", [[submodule\..*\.url]] }, { text = true }):wait()
    local paths_result = vim.system(
      { "git", "config", "--file", ".gitmodules", "--get-regexp", [[submodule\..*\.path]] },
      { text = true }):wait()
    if not init.stdout or not paths_result.stdout then
      vim.notify("Not a repo with submodules", vim.log.levels.WARN)
      return
    end
    -- Build set of initialized submodule names from local config.
    local initialized = {}
    for name in init.stdout:gmatch("submodule%.(.-)%.url") do
      initialized[name] = true
    end
    -- Map name→path from .gitmodules, keep only initialized ones.
    local entries = {}
    for name, path_str in paths_result.stdout:gmatch("submodule%.(.-)%.path%s+(%S+)") do
      if initialized[name] then
        table.insert(entries, ansi.green(path_str))
      end
    end
    table.sort(entries, function(a, b) return strip_ansi(a) < strip_ansi(b) end)
    fzf_lua.fzf_exec(entries, opts)
  end


  require('gitsigns').setup({
    signs = {
      add          = { text = '▎' },
      change       = { text = '▎' },
      delete       = { text = '' },
      topdelete    = { text = '' },
      changedelete = { text = '▎' },
      untracked    = { text = '▎' },
    },
  })

  -- Configure diffview.nvim (git diff/merge/log viewer)
  require('diffview').setup({
    use_icons = true,
  })

  -- Configure blink.indent (indent guides + scope)
  require('blink.indent').setup({})

  -- Configure mini.statusline
  require('mini.statusline').setup({})

  -- Configure mini.trailspace (highlight + trim trailing whitespace)
  require('mini.trailspace').setup({})

  -- Treesitter (parser management via nvim-treesitter plugin).
  -- The plugin is archived but its main branch works with Neovim 0.12.
  -- It provides ensure_installed + automatic parser compilation.
  require('nvim-treesitter').setup({
    ensure_installed = {
      'bash', 'c', 'c_sharp', 'css', 'html', 'javascript', 'json', 'lua',
      'markdown', 'markdown_inline', 'python', 'query', 'sql', 'typescript',
      'vim', 'vimdoc', 'yaml',
    },
  })

  -- Enable treesitter highlighting for all filetypes with installed parsers.
  -- The archived nvim-treesitter plugin only manages parser installation;
  -- highlighting must be started explicitly (Neovim <0.12).
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('treesitter-highlight', {}),
    callback = function(ev)
      if pcall(vim.treesitter.start, ev.buf) then
        vim.bo[ev.buf].syntax = ''
      end
    end,
  })

  -- Configure dropbar.nvim (treesitter-based breadcrumbs in winbar)
  require('dropbar').setup()

  -- Configure blink.cmp
  require('blink.cmp').setup({
    keymap = {
      -- Accept with Enter rather than Ctrl-y (default) to match IDE behavior
      preset = 'enter',
      -- Tab: NES accept when suggestion pending → snippet forward → select next → fallback
      ['<Tab>'] = {
        function(cmp)
          if vim.b[vim.api.nvim_get_current_buf()].nes_state then
            cmp.hide()
            return (
              require('copilot-lsp.nes').apply_pending_nes()
              and require('copilot-lsp.nes').walk_cursor_end_edit()
            )
          end
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        'fallback',
      },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = { documentation = { auto_show = false } },
    sources = {
      default = { 'copilot', 'lsp', 'snippets', 'path', 'buffer' },
      -- Make Copilot more prominent by giving it a higher score offset and showing it
      providers = {
        copilot = {
          name = 'copilot',
          module = 'blink-copilot',
          score_offset = 100,
          async = true,
        },
      },
    },
    -- Prefer the Rust implementation of the fuzzy matcher for better performance.
    -- However, fall back to the Lua implementation with a warning if the Rust
    -- one fails to load. Prebuilt Rust binaries are only attached to tagged
    -- releases. Since vim.pack clones at HEAD by default, the lockfile rev
    -- must be pinned to a release tag commit (check blink.cmp's releases
    -- page for the correct hash). If the rev drifts to an untagged commit,
    -- the Rust binary won't be found and this setting will fall back to Lua.
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  })

  -- Configure live-preview.nvim (markdown/HTML browser preview)
  require('livepreview.config').set({
    picker = 'fzf-lua',
  })

  -- Configure copilot-lsp (NES — Next Edit Suggestions)
  vim.g.copilot_nes_debounce = 500
  require('copilot-lsp').setup({
    nes = { move_count_threshold = 3 },
  })

  -- Configure sidekick.nvim (AI CLI terminal with tmux integration)
  require('sidekick').setup({
    nes = { enabled = false },

    cli = {
      picker = 'fzf-lua',
      watch = true,
      -- TODO: re-enable once sidekick supports Windows process discovery for tmux
      -- mux = {
      --   enabled = true,
      --   backend = 'tmux',
      --   create = 'window',
      -- },
      win = {
        layout = 'float',
      },
      tools = {
        agency_copilot = {
          cmd = { 'agency', 'copilot' },
          is_proc = function(_, proc)
            local re = vim.regex('\\<copilot\\>')
            return re:match_str(proc.cmd) and not proc.cmd:find('language%-server') or false
          end,
        },
      },
    },
    copilot = {
      status = { enabled = false },
    },
  })

  -- Configure snacks.nvim (only vim.ui.input override)
  require('snacks').setup({
    input = { enabled = true },
  })

  -- LSP: nvim-lspconfig provides base configs in its lsp/ directory.
  -- Override per-server settings in after/lsp/<server>.lua (see :h lsp-config).
  -- List servers to enable here:
  vim.lsp.enable({
    'lua_ls',
    'markdown_oxide',
    'copilot_ls',
  })
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
