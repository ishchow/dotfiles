-- markdown-oxide LSP configuration overrides (base config from nvim-lspconfig)
-- See: https://github.com/Feel-ix-343/markdown-oxide
-- Requires dynamicRegistration for features like "Create Unresolved File" code action
return {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
}
