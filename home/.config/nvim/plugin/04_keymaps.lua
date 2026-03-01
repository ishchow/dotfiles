-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Configure leap.nvim keymaps
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

-- ============================================================================
-- VSCode-Specific Keymaps
-- ============================================================================

if vim.g.vscode then
  -- Note: VSCode extension provides special commands via VSCodeNotify

  -- Find
  vim.keymap.set("n", "<Leader>ff", "<cmd>call VSCodeNotify('workbench.action.quickOpen')<cr>")

  -- Toggle
  vim.keymap.set("n", "<Leader>ts", "<cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<cr>")
  vim.keymap.set("n", "<Leader>te", "<cmd>call VSCodeNotify('workbench.view.explorer')<cr>")
  vim.keymap.set("n", "<Leader>tp", "<cmd>call VSCodeNotify('workbench.actions.view.problems')<cr>")
  vim.keymap.set("n", "<Leader>tg", "<cmd>call VSCodeNotify('workbench.view.scm')<cr>")
end

-- ============================================================================
-- Native-Only Keymaps
-- ============================================================================

if not vim.g.vscode then
  -- Yazi file manager keymaps
  vim.keymap.set({ "n", "v" }, "<leader>-", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
  vim.keymap.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>", { desc = "Open the file manager in nvim's working directory" })
  vim.keymap.set("n", "<c-up>", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" })

  -- LSP keymaps using <leader> instead of g-prefix
  -- This keeps Vim defaults intact
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buf = args.buf
      local opts = { noremap=true, silent=true, buffer=buf }
      local map = vim.keymap.set

      -- Go to definitions / declarations / type / implementation
      map('n', '<leader>gd', vim.lsp.buf.definition, opts)
      map('n', '<leader>gD', vim.lsp.buf.declaration, opts)
      map('n', '<leader>gy', vim.lsp.buf.type_definition, opts)
      map('n', '<leader>gI', vim.lsp.buf.implementation, opts)

      -- Rename, references, code actions
      map('n', '<leader>gr', vim.lsp.buf.rename, opts)
      map('n', '<leader>gA', vim.lsp.buf.references, opts)
      map('n', '<leader>g.', vim.lsp.buf.code_action, opts)

      -- Hover / diagnostics
      map('n', '<leader>gh', vim.lsp.buf.hover, opts)
      map('n', '<leader>gn', vim.diagnostic.goto_next, opts)
      map('n', '<leader>gp', vim.diagnostic.goto_prev, opts)

      -- Optional: file/project symbols (requires telescope or LSP built-in)
      map('n', '<leader>gs', vim.lsp.buf.document_symbol, opts)
      map('n', '<leader>gS', vim.lsp.buf.workspace_symbol, opts)
    end,
  })
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
