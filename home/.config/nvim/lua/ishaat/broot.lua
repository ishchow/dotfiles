-- Broot integration for neovim.
-- Opens broot in a floating terminal window. When the user selects a file
-- (Enter), broot's `print_path` internal verb prints the path to stdout
-- and exits. Since broot renders its TUI on stderr, we redirect stdout to
-- a temp file to capture the selected path, then open it in neovim.
--
-- Architecture: broot (floating terminal) → stdout redirect → lua reads
-- path → vim.cmd.edit(). No external commands through broot, no RPC.

local M = {
  config = {
    broot_binary = "broot",
    extra_args = {},
    config_files = {},
    default_directory = vim.fn.getcwd,
  },
}

--- @class ishaat.broot.SetupOpts
--- @field broot_binary? string
--- @field extra_args? string[]
--- @field config_files? string[]
--- @field default_directory? string|fun(): string?
--- @field create_user_commands? boolean

--- @param opts ishaat.broot.SetupOpts
function M.setup(opts)
  if type(opts.default_directory) == "string" then
    local dir = opts.default_directory
    opts.default_directory = function() return dir end
  end
  M.config = vim.tbl_extend("force", M.config, opts)

  if opts.create_user_commands ~= false then
    vim.api.nvim_create_user_command("Broot", function(cmd_opts)
      M.broot({ directory = cmd_opts.fargs[1] })
    end, { nargs = "?", complete = "dir", desc = "Open broot file manager" })
  end
end

--- Write a temporary hjson verb file that binds Enter to print_path.
--- @return string path to the temp file
function M._write_verb_file()
  local path = vim.fn.tempname() .. ".hjson"
  local content = [[
verbs: [
    {
        key: enter
        invocation: edit
        shortcut: e
        apply_to: text_file
        internal: "print_path"
    }
]
]]
  local file = io.open(path, "w")
  if file then
    file:write(content)
    file:close()
  end
  return path
end

--- Build a shell command string that runs broot and redirects stdout to a file.
--- Broot renders on stderr so the TUI is unaffected; print_path writes to stdout.
--- @param broot_args string[] arguments for broot
--- @param out_file string path to capture stdout
--- @return string shell command
function M._build_shell_cmd(broot_args, out_file)
  local parts = {}
  for _, arg in ipairs(broot_args) do
    -- Quote any arg that contains spaces, semicolons, or other shell metacharacters
    if arg:find("[%s;\"'|&<>%%$(){}]") then
      if vim.fn.has("win32") == 1 then
        -- PowerShell: use single quotes (no interpolation)
        table.insert(parts, "'" .. arg:gsub("'", "''") .. "'")
      else
        -- POSIX: use single quotes
        table.insert(parts, "'" .. arg:gsub("'", "'\\''") .. "'")
      end
    else
      table.insert(parts, arg)
    end
  end

  if vim.fn.has("win32") == 1 then
    -- PowerShell: redirect stdout with >
    return table.concat(parts, " ") .. " > '" .. out_file:gsub("'", "''") .. "'"
  else
    return table.concat(parts, " ") .. " > '" .. out_file:gsub("'", "'\\''") .. "'"
  end
end

--- @class ishaat.broot.BrootOpts
--- @field extra_args? string[]
--- @field directory? string

--- @param opts? ishaat.broot.BrootOpts
function M.broot(opts)
  opts = opts or {}

  local cwd = opts.directory or M.config.default_directory() or vim.fn.getcwd()

  -- Create scratch buffer + floating window
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = vim.o.lines - vim.o.cmdheight - (vim.o.laststatus ~= 0 and 1 or 0),
    style = "minimal",
  })

  -- Generate verb file that binds enter → print_path
  local verb_file = M._write_verb_file()

  -- Temp file to capture broot's stdout (the selected path from print_path)
  local out_file = vim.fn.tempname()

  -- Build broot arguments
  local broot_args = { M.config.broot_binary }

  local conf_files = {}
  for _, f in ipairs(M.config.config_files) do
    table.insert(conf_files, f)
  end
  table.insert(conf_files, verb_file)

  table.insert(broot_args, "--conf")
  table.insert(broot_args, table.concat(conf_files, ";"))

  for _, arg in ipairs(M.config.extra_args) do
    table.insert(broot_args, arg)
  end
  for _, arg in ipairs(opts.extra_args or {}) do
    table.insert(broot_args, arg)
  end

  -- Build shell command with stdout redirect to capture print_path output
  local shell_cmd = M._build_shell_cmd(broot_args, out_file)

  vim.fn.termopen(shell_cmd, {
    cwd = cwd,
    on_exit = function(_, exit_code)
      -- Clean up verb file
      vim.fn.delete(verb_file)

      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end

      -- Read the selected file path from stdout redirect
      if vim.fn.filereadable(out_file) == 1 then
        local lines = vim.fn.readfile(out_file)
        vim.fn.delete(out_file)
        if #lines > 0 then
          local selected = vim.trim(lines[1])
          if selected ~= "" then
            vim.cmd.edit(selected)
          end
        end
      end

      if exit_code ~= 0 then
        vim.notify("broot exited with code " .. exit_code, vim.log.levels.WARN)
      end
    end,
  })

  vim.cmd.startinsert()

  -- Resize the floating window if the editor resizes
  local augroup = vim.api.nvim_create_augroup("IshaatBroot", { clear = true })
  vim.api.nvim_create_autocmd("VimResized", {
    buffer = buf,
    group = augroup,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_width(win, vim.o.columns)
        vim.api.nvim_win_set_height(win, vim.o.lines - vim.o.cmdheight - (vim.o.laststatus ~= 0 and 1 or 0))
      end
    end,
  })
end

return M
