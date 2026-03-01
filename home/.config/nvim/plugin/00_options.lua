-- ┌──────────────────────────┐
-- │ Built-in Neovim behavior │
-- └──────────────────────────┘

-- General ====================================================================
-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.mouse       = 'a'
vim.o.mousescroll = 'ver:25,hor:6'
vim.o.switchbuf   = 'usetab'
vim.o.undofile    = true
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 500

vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- UI =========================================================================
vim.o.breakindent    = true
vim.o.breakindentopt = 'list:-1'
vim.o.colorcolumn    = '+1'
vim.o.cursorline     = true
vim.o.linebreak      = true
vim.o.list           = true
vim.o.number         = true
vim.o.relativenumber = true
vim.o.pumborder      = 'single'
vim.o.pumheight      = 10
vim.o.pummaxwidth    = 100
vim.o.ruler          = false
vim.o.shortmess      = 'CFOSWaco'
vim.o.showmode       = false
vim.o.signcolumn     = 'yes'
vim.o.splitbelow     = true
vim.o.splitkeep      = 'screen'
vim.o.splitright     = true
vim.o.winborder      = 'single'
vim.o.wrap           = false
vim.o.cursorlineopt  = 'screenline,number'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.fillchars = 'eob: ,fold:╌'
vim.o.listchars = 'extends:…,nbsp:␣,precedes:…,tab:> '

-- Folding ====================================================================
vim.o.foldlevel   = 10
vim.o.foldmethod  = 'indent'
vim.o.foldnestmax = 10
vim.o.foldtext    = ''

-- Editing ====================================================================
vim.o.autoindent    = true
vim.o.expandtab     = true
vim.o.formatoptions = 'rqnl1j'
vim.o.ignorecase    = true
vim.o.incsearch     = true
vim.o.infercase     = true
vim.o.shiftwidth    = 2
vim.o.smartcase     = true
vim.o.smartindent   = true
vim.o.spelloptions  = 'camel'
vim.o.tabstop       = 2
vim.o.virtualedit   = 'block'

-- Set highlight on search
vim.o.hlsearch = false

-- Sync clipboard between OS and Neovim.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

vim.o.iskeyword = '@,48-57,_,192-255,-'

vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Completion =================================================================
vim.o.complete        = '.,w,b,kspell'
vim.o.completeopt     = 'menuone,noselect,fuzzy,nosort'
vim.o.completetimeout = 100

-- Autocommands ===============================================================

local f = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end
Config.new_autocmd('FileType', nil, f, "Proper 'formatoptions'")

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

-- Diagnostics ================================================================

local diagnostic_opts = {
  signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
  underline = { severity = { min = 'HINT', max = 'ERROR' } },
  virtual_lines = false,
  virtual_text = {
    current_line = true,
    severity = { min = 'ERROR', max = 'ERROR' },
  },
  update_in_insert = false,
}

Config.later(function() vim.diagnostic.config(diagnostic_opts) end)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
