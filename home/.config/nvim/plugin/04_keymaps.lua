-- ┌─────────────────┐
-- │ Custom mappings │
-- └─────────────────┘
--
-- This file uses a "two key Leader mappings" approach inspired by MiniMax:
-- first key describes the semantic group, second key executes an action.
--
-- Leader groups:
--   b — Buffer        e — Explore/Edit    f — Find
--   g — Git (reserved)  l — Language (LSP)  o — Other
--   t — Terminal
--
-- Convention: lowercase second key = global/workspace scope,
-- uppercase second key = local/buffer scope.

-- Helpers
local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end
local nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end

-- General mappings ===========================================================

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Word-wrap-aware movement
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Leap
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

-- ============================================================================
-- VSCode-Specific Keymaps
-- ============================================================================

if vim.g.vscode then
  local vscode = require('vscode')
  local act = function(cmd)
    return function() vscode.action(cmd) end
  end

  -- b is for 'Buffer'
  nmap_leader('bd', act('workbench.action.closeActiveEditor'),   'Delete')
  nmap_leader('bn', act('workbench.action.nextEditor'),          'Next')
  nmap_leader('bp', act('workbench.action.previousEditor'),      'Previous')

  -- e is for 'Explore/Edit'
  nmap_leader('ed', act('workbench.actions.view.problems'),              'Diagnostics')
  nmap_leader('ee', act('workbench.view.explorer'),                      'Explorer')
  nmap_leader('eg', act('workbench.view.scm'),                           'Git (SCM)')
  nmap_leader('es', act('workbench.action.toggleSidebarVisibility'),     'Toggle sidebar')

  -- f is for 'Find'
  nmap_leader('ff', act('workbench.action.quickOpen'),                   'Files')
  nmap_leader('fg', act('workbench.action.findInFiles'),                 'Grep')
  nmap_leader('fr', act('workbench.action.openRecent'),                  'Recent')
  nmap_leader('fs', act('workbench.action.gotoSymbol'),                  'Symbols document')
  nmap_leader('fS', act('workbench.action.showAllSymbols'),              'Symbols workspace')
  vim.keymap.set('n', '<Leader><Leader>', act('workbench.action.showCommands'), { desc = 'Command palette' })

  -- l is for 'Language'
  nmap_leader('la', act('editor.action.quickFix'),                       'Actions')
  nmap_leader('ld', act('editor.action.showHover'),                      'Diagnostic popup')
  nmap_leader('lh', act('editor.action.showHover'),                      'Hover')
  nmap_leader('li', act('editor.action.goToImplementation'),             'Implementation')
  nmap_leader('lr', act('editor.action.rename'),                         'Rename')
  nmap_leader('lR', act('editor.action.goToReferences'),                 'References')
  nmap_leader('ls', act('editor.action.revealDefinition'),               'Source definition')
  nmap_leader('lD', act('editor.action.revealDeclaration'),              'Declaration')
  nmap_leader('lt', act('editor.action.goToTypeDefinition'),             'Type definition')

  -- r is for 'Refactor' (IDE-specific)
  nmap_leader('ra', act('editor.action.refactor'),                       'Refactor menu')
  nmap_leader('rr', act('editor.action.rename'),                         'Rename')

  -- o is for 'Other'
  nmap_leader('op', act('markdown.showPreview'),                         'Preview')
  nmap_leader('oz', act('workbench.action.toggleZenMode'),               'Zen mode')

  -- t is for 'Terminal'
  nmap_leader('tt', act('workbench.action.terminal.toggleTerminal'),     'Terminal')
end

-- ============================================================================
-- Native-Only Keymaps
-- ============================================================================

if not vim.g.vscode then
  -- Table workflow commands (vim-table-mode) ---------------------------------
  local function build_gfm_separator_from_header(header)
    if not header:match("^%s*|") then
      return nil
    end

    local cells = {}
    for cell in header:gmatch("|([^|]*)") do
      table.insert(cells, cell)
    end

    if #cells == 0 then
      return nil
    end

    local sep_cells = {}
    for _, cell in ipairs(cells) do
      local inner_width = math.max(3, #cell - 2)
      table.insert(sep_cells, " :" .. string.rep("-", math.max(2, inner_width - 1)) .. " ")
    end

    return "|" .. table.concat(sep_cells, "|") .. "|"
  end

  local function ensure_gfm_header_separator(header_line)
    local header = vim.fn.getline(header_line)
    local separator = build_gfm_separator_from_header(header)
    if not separator then
      return
    end

    local next_line_num = header_line + 1
    local next_line = vim.fn.getline(next_line_num)
    if next_line ~= "" and next_line:match("^%s*|[%s:%-]+|%s*$") then
      vim.fn.setline(next_line_num, separator)
    else
      vim.fn.append(header_line, separator)
    end
  end

  vim.api.nvim_create_user_command("TableCsv", function(opts)
    if opts.range > 0 then
      vim.cmd(string.format("%d,%dTableize/,", opts.line1, opts.line2))
      ensure_gfm_header_separator(opts.line1)
    else
      local current = vim.fn.line('.')
      vim.cmd("Tableize/,")
      ensure_gfm_header_separator(current)
    end
  end, { range = true, desc = "Convert CSV text to markdown table" })

  vim.api.nvim_create_user_command("TableTsv", function(opts)
    if opts.range > 0 then
      vim.cmd(string.format("%d,%dTableize/\\t", opts.line1, opts.line2))
      ensure_gfm_header_separator(opts.line1)
    else
      local current = vim.fn.line('.')
      vim.cmd("Tableize/\\t")
      ensure_gfm_header_separator(current)
    end
  end, { range = true, desc = "Convert TSV text to markdown table" })

  vim.api.nvim_create_user_command("TableFormat", function()
    vim.cmd("TableModeRealign")
  end, { desc = "Realign/format current table" })

  vim.api.nvim_create_user_command("TableGfmHeader", function(opts)
    if opts.range > 0 then
      ensure_gfm_header_separator(opts.line1)
    else
      ensure_gfm_header_separator(vim.fn.line('.'))
    end
  end, { range = true, desc = "Insert or refresh GFM alignment separator row" })

  -- Window navigation --------------------------------------------------------
  -- Use <C-hjkl> (matches mini.basics / Vim convention), freeing leader keys
  nmap('<C-h>', '<C-w>h', 'Go to left window')
  nmap('<C-j>', '<C-w>j', 'Go to lower window')
  nmap('<C-k>', '<C-w>k', 'Go to upper window')
  nmap('<C-l>', '<C-w>l', 'Go to right window')

  -- Terminal-mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>',        { desc = 'Exit terminal mode' })
  vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h',       { desc = 'Go to left window' })
  vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j',       { desc = 'Go to lower window' })
  vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k',       { desc = 'Go to upper window' })
  vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l',       { desc = 'Go to right window' })

  -- b is for 'Buffer' -------------------------------------------------------
  local new_scratch_buffer = function()
    vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
  end

  nmap_leader('ba', '<Cmd>b#<CR>',      'Alternate')
  nmap_leader('bd', '<Cmd>bdelete<CR>', 'Delete')
  nmap_leader('bn', '<Cmd>bnext<CR>',   'Next')
  nmap_leader('bp', '<Cmd>bprev<CR>',   'Previous')
  nmap_leader('bs', new_scratch_buffer, 'Scratch')

  -- e is for 'Explore/Edit' -------------------------------------------------
  local edit_plugin_file = function(filename)
    return string.format('<Cmd>edit %s/plugin/%s<CR>', vim.fn.stdpath('config'), filename)
  end
  local explore_quickfix = function()
    vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and 'cclose' or 'copen')
  end

  nmap_leader('ed', '<Cmd>Yazi cwd<CR>',                    'Directory (cwd)')
  nmap_leader('ef', '<Cmd>Yazi<CR>',                        'File directory')
  nmap_leader('er', '<Cmd>Yazi toggle<CR>',                 'Resume yazi session')
  vim.keymap.set('n', '<C-Up>', '<Cmd>Yazi toggle<CR>',     { desc = 'Resume yazi session' })
  nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>',               'init.lua')
  nmap_leader('ek', edit_plugin_file('04_keymaps.lua'),     'Keymaps config')
  nmap_leader('ep', edit_plugin_file('03_plugins.lua'),     'Plugins config')
  nmap_leader('eo', edit_plugin_file('00_options.lua'),     'Options config')
  nmap_leader('eq', explore_quickfix,                       'Quickfix list')

  -- f is for 'Find' (fzf-lua) -----------------------------------------------
  nmap_leader('fb', '<Cmd>FzfLua buffers<CR>',                      'Buffers')
  nmap_leader('fd', '<Cmd>FzfLua diagnostics_workspace<CR>',        'Diagnostics workspace')
  nmap_leader('fD', '<Cmd>FzfLua diagnostics_document<CR>',         'Diagnostics buffer')
  nmap_leader('ff', '<Cmd>FzfLua files<CR>',                        'Files')
  nmap_leader('fg', '<Cmd>FzfLua live_grep<CR>',                    'Grep live')
  nmap_leader('fG', '<Cmd>FzfLua grep_cword<CR>',                   'Grep current word')
  nmap_leader('fh', '<Cmd>FzfLua helptags<CR>',                     'Help tags')
  nmap_leader('fi', '<Cmd>FzfLua git_files<CR>',                    'Git files')
  nmap_leader('fr', '<Cmd>FzfLua resume<CR>',                       'Resume')
  nmap_leader('fR', '<Cmd>FzfLua lsp_references<CR>',               'References (LSP)')
  nmap_leader('fs', '<Cmd>FzfLua lsp_document_symbols<CR>',         'Symbols document')
  nmap_leader('fS', '<Cmd>FzfLua lsp_live_workspace_symbols<CR>',   'Symbols workspace')

  -- g is for 'Git' (gitsigns) -----------------------------------------------
  local gs = require('gitsigns')
  nmap_leader('gb', function() gs.blame_line({ full = true }) end, 'Blame line')
  nmap_leader('gB', gs.toggle_current_line_blame,                  'Blame toggle')
  nmap_leader('gd', gs.diffthis,                                   'Diff')
  nmap_leader('gD', function() gs.diffthis('~') end,               'Diff ~')
  nmap_leader('gp', gs.preview_hunk,                               'Preview hunk')
  nmap_leader('gr', gs.reset_hunk,                                 'Reset hunk')
  nmap_leader('gR', gs.reset_buffer,                               'Reset buffer')
  nmap_leader('gs', gs.stage_hunk,                                 'Stage hunk')
  nmap_leader('gS', gs.stage_buffer,                               'Stage buffer')
  nmap_leader('gu', gs.undo_stage_hunk,                            'Undo stage hunk')

  -- Hunk navigation
  nmap(']h', function() gs.nav_hunk('next') end, 'Next hunk')
  nmap('[h', function() gs.nav_hunk('prev') end, 'Previous hunk')

  -- l is for 'Language' (LSP) -----------------------------------------------
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buf = args.buf
      local opts = { noremap = true, silent = true, buffer = buf }
      local map = vim.keymap.set

      map('n', '<Leader>la', vim.lsp.buf.code_action,     vim.tbl_extend('force', opts, { desc = 'Actions' }))
      map('n', '<Leader>ld', vim.diagnostic.open_float,   vim.tbl_extend('force', opts, { desc = 'Diagnostic popup' }))
      map('n', '<Leader>lh', vim.lsp.buf.hover,           vim.tbl_extend('force', opts, { desc = 'Hover' }))
      map('n', '<Leader>li', vim.lsp.buf.implementation,  vim.tbl_extend('force', opts, { desc = 'Implementation' }))
      map('n', '<Leader>lr', vim.lsp.buf.rename,          vim.tbl_extend('force', opts, { desc = 'Rename' }))
      map('n', '<Leader>lR', vim.lsp.buf.references,      vim.tbl_extend('force', opts, { desc = 'References' }))
      map('n', '<Leader>ls', vim.lsp.buf.definition,      vim.tbl_extend('force', opts, { desc = 'Source definition' }))
      map('n', '<Leader>lD', vim.lsp.buf.declaration,     vim.tbl_extend('force', opts, { desc = 'Declaration' }))
      map('n', '<Leader>lt', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'Type definition' }))
    end,
  })

  -- o is for 'Other' ---------------------------------------------------------
  vim.api.nvim_create_user_command('CopyNvimServerName', function()
    vim.fn.setreg('+', vim.v.servername)
    vim.notify('Copied: ' .. vim.v.servername)
  end, { desc = 'Copy Neovim server name to clipboard' })
  nmap_leader('os', '<Cmd>CopyNvimServerName<CR>', 'Copy server name')
  nmap_leader('op', '<Cmd>LivePreview start<CR>', 'Preview')

  -- t is for 'Terminal' ------------------------------------------------------
  nmap_leader('ta', function()
    require('sidekick.cli').toggle({ name = 'agency_copilot', focus = true })
  end, 'Agency Copilot')
  vim.keymap.set({ 'n', 't', 'i', 'x' }, '<C-.>', function()
    require('sidekick.cli').focus()
  end, { desc = 'Sidekick Focus' })
  nmap_leader('tt', '<Cmd>vertical term<CR>',   'Terminal (vertical)')
  nmap_leader('tT', '<Cmd>horizontal term<CR>', 'Terminal (horizontal)')
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
