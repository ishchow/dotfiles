-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 500

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

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

-- Handle running within vscode
if vim.g.vscode then
  require('vsc')
  require('plugins.editor-common')
else
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

  -- Load native plugins check
  require('native')

  -- Load plugin configurations
  require('plugins.editor-common')
  require('plugins.editor-native')
  require('plugins.ui')
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
