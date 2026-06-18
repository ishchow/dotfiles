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
})

if not vim.g.vscode then
    -- Stub nvim-web-devicons so plugins that check for it at load time
    -- don't warn. MiniIcons.mock_nvim_web_devicons() replaces this later
    -- in 03_plugins.lua with the full implementation.
    package.preload['nvim-web-devicons'] = function()
      return {
        get_icon = function() return '', 'Normal' end,
        get_icon_by_filetype = function() return '', 'Normal' end,
        setup = function() end,
      }
    end

    -- Disable vim-table-mode default mappings before loading (they conflict with <Leader>t group)
    vim.g.table_mode_disable_mappings = 1
    vim.g.table_mode_disable_tableize_mappings = 1
    vim.g.table_mode_corner = '|'

    vim.pack.add({
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
      'https://github.com/folke/which-key.nvim',
      'https://github.com/dhruvasagar/vim-table-mode',

      -- Treesitter (parser management + ensure_installed)
      'https://github.com/nvim-treesitter/nvim-treesitter',

      -- Breadcrumbs (treesitter-based winbar)
      'https://github.com/Bekaboo/dropbar.nvim',

      -- LSP
      'https://github.com/neovim/nvim-lspconfig',
      'https://github.com/Hoffs/omnisharp-extended-lsp.nvim',

      -- Completion
      'https://github.com/saghen/blink.cmp',
      'https://github.com/fang2hou/blink-copilot',
      -- Snippets
      'https://github.com/rafamadriz/friendly-snippets',

      -- Indent guides
      'https://github.com/saghen/blink.indent',

      -- Statusline
      'https://github.com/nvim-mini/mini.statusline',

      -- Trailing whitespace
      'https://github.com/nvim-mini/mini.trailspace',

      -- Git
      'https://github.com/lewis6991/gitsigns.nvim',
      'https://github.com/sindrets/diffview.nvim',

      -- Markdown preview
      'https://github.com/brianhuster/live-preview.nvim',


      -- UI overrides (vim.ui.input)
      'https://github.com/folke/snacks.nvim',
    })
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et