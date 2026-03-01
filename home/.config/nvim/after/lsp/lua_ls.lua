-- Lua LSP configuration placeholder
-- This file is called when setting up lua_ls language server

-- Early exit: LSP not configured yet
-- Remove this return statement when you're ready to configure lua_ls
return

-- Example lua_ls configuration (currently disabled):
-- return {
--   settings = {
--     Lua = {
--       runtime = {
--         version = 'LuaJIT',
--       },
--       diagnostics = {
--         globals = { 'vim' },
--       },
--       workspace = {
--         library = vim.api.nvim_get_runtime_file("", true),
--         checkThirdParty = false,
--       },
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- }

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
