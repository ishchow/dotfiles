-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Plugin management with vim.pack ]]

vim.pack.add({
  -- Core editor plugins (always loaded)
  'https://github.com/nvim-mini/mini.pairs',
  'https://github.com/nvim-mini/mini.ai',
  'https://github.com/nvim-mini/mini.surround',
  'https://github.com/nvim-mini/mini.comment',
  'https://github.com/nvim-mini/mini.move',
  'https://github.com/tpope/vim-repeat',
  'https://github.com/ggandor/leap.nvim',

  -- Dependencies (load before other UI plugins)
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-mini/mini.icons',

  -- UI and native plugins (conditionally configured)
  'https://github.com/catppuccin/nvim',
  'https://github.com/rcarriga/nvim-notify',
  'https://github.com/mikavilpas/yazi.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/jinh0/eyeliner.nvim',
  'https://github.com/folke/ts-comments.nvim',
})

-- Define config table to be able to pass data between scripts
-- It is a global variable which can be use both as `_G.Config` and `Config`
_G.Config = {}

-- Loading helpers used to organize config into fail-safe parts. Example usage:
-- - `now` - execute immediately. Use for what must be executed during startup.
--   Like colorscheme, statusline, tabline, dashboard, etc.
-- - `later` - execute a bit later. Use for things not needed during startup.
-- - `now_if_args` - use only if needed during startup when Neovim is started
--   like `nvim -- path/to/file`, but otherwise delaying is fine.
-- - Others are better used only if the above is not enough for good performance.
--   Use only if you are comfortable with adding complexity to your config:
--   - `on_event` - execute once on a first matched event. Like "delay until
--     first Insert mode enter": `on_event('InsertEnter', function() ... end)`.
--   - `on_filetype` - execute once on a first matched filetype. Like "delay
--     until first Lua file": `on_filetype('lua', function() ... end)`.
local misc = require('mini.misc')
Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely('event:' .. ev, f) end
Config.on_filetype = function(ft, f) misc.safely('filetype:' .. ft, f) end

-- Define custom autocommand group and helper to create an autocommand.
-- Autocommands are Neovim's way to define actions that are executed on events
-- (like creating a buffer, setting an option, etc.).
--
-- See also:
-- - `:h autocommand`
-- - `:h nvim_create_augroup()`
-- - `:h nvim_create_autocmd()`
local gr = vim.api.nvim_create_augroup('custom-config', {})
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

-- Define custom `vim.pack.add()` hook helper. See `:h vim.pack-events`.
-- Example usage: see 'plugin/40_plugins.lua'.
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Config.new_autocmd('PackChanged', '*', f, desc)
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
