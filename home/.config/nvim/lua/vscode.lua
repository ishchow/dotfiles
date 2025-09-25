-- [[ Leader Key Maps ]]

-- Find
vim.keymap.set("n", "<Leader>ff", "<cmd>call VSCodeNotify('workbench.action.quickOpen')<cr>")

-- Toggle
vim.keymap.set("n", "<Leader>ts", "<cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<cr>")
vim.keymap.set("n", "<Leader>te", "<cmd>call VSCodeNotify('workbench.view.explorer')<cr>")
vim.keymap.set("n", "<Leader>tp", "<cmd>call VSCodeNotify('workbench.actions.view.problems')<cr>")
vim.keymap.set("n", "<Leader>tg", "<cmd>call VSCodeNotify('workbench.view.scm')<cr>")