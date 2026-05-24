-- Broot integration for neovim.
-- Opens broot in a floating terminal window. When the user selects a file
-- (Enter), broot's `print_path` internal verb prints the path to stdout
-- and exits. Since broot renders its TUI on stderr, we redirect stdout to
-- a temp file to capture the selected path, then open it in neovim.
--
-- Architecture: broot (floating terminal) → stdout redirect → lua reads
-- path → vim.cmd.edit(). No external commands through broot, no RPC.
--
-- Broot is launched with --conf pointing at conf-nvim.hjson in the
-- standard broot config directory. That file imports conf-base.hjson
-- (shared settings/skin) and verbs-nvim.hjson (Enter → print_path).

local M = {
  config = {
    broot_binary = "broot",
    extra_args = {},
    conf_path = nil, ---@type string? path to conf-nvim.hjson
    default_directory = vim.fn.getcwd,
  },
}

--- @class ishaat.broot.SetupOpts
--- @field broot_binary? string
--- @field extra_args? string[]
--- @field conf_path? string path to conf-nvim.hjson in the broot config dir
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

--- @class ishaat.broot.BrootOpts
--- @field extra_args? string[]
--- @field directory? string

--- Build a shell command string that runs broot and redirects stdout to a file.
--- @param broot_args string[] arguments for broot
--- @param out_file string path to capture stdout
--- @return string shell command
function M._build_shell_cmd(broot_args, out_file)
  local parts = {}
  for _, arg in ipairs(broot_args) do
    if arg:find("[%s;\"'|&<>%%$(){}]") then
      if vim.fn.has("win32") == 1 then
        table.insert(parts, "'" .. arg:gsub("'", "''") .. "'")
      else
        table.insert(parts, "'" .. arg:gsub("'", "'\\''") .. "'")
      end
    else
      table.insert(parts, arg)
    end
  end

  if vim.fn.has("win32") == 1 then
    return table.concat(parts, " ") .. " > '" .. out_file:gsub("'", "''") .. "'"
  else
    return table.concat(parts, " ") .. " > '" .. out_file:gsub("'", "'\\''") .. "'"
  end
end

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

  -- Temp file to capture broot's stdout (the selected path from print_path)
  local out_file = vim.fn.tempname()

  -- Build broot arguments
  local broot_args = { M.config.broot_binary }

  if M.config.conf_path then
    table.insert(broot_args, "--conf")
    table.insert(broot_args, M.config.conf_path)
  end

  for _, arg in ipairs(M.config.extra_args) do
    table.insert(broot_args, arg)
  end
  for _, arg in ipairs(opts.extra_args or {}) do
    table.insert(broot_args, arg)
  end

  -- Build shell command with stdout redirect to capture print_path output.
  -- Broot renders on stderr so the TUI is unaffected; print_path writes to stdout.
  local shell_cmd = M._build_shell_cmd(broot_args, out_file)

  vim.fn.termopen(shell_cmd, {
    cwd = cwd,
    on_exit = function(_, exit_code)
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
