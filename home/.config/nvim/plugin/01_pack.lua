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

        -- LSP
        'https://github.com/neovim/nvim-lspconfig',

        -- Completion
        'https://github.com/saghen/blink.cmp',
    })
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et