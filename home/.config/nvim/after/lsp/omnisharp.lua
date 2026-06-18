-- OmniSharp LSP server configuration
-- Overrides for the built-in nvim-lspconfig omnisharp config
-- See: https://github.com/OmniSharp/omnisharp-roslyn

local extended = require("omnisharp_extended")

---@type vim.lsp.Config
return {
  handlers = {
    ["textDocument/definition"] = extended.definition_handler,
    ["textDocument/typeDefinition"] = extended.type_definition_handler,
    ["textDocument/references"] = extended.references_handler,
    ["textDocument/implementation"] = extended.implementation_handler,
  },
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
      EnableDecompilationSupport = true,
    },
    Sdk = {
      IncludePrereleases = true,
    },
  },
}
