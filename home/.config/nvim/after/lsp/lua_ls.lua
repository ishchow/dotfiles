-- Lua LSP configuration overrides (base config from nvim-lspconfig)
-- See: https://luals.github.io/wiki/settings/
return {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
