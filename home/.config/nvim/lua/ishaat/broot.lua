local M = {}

-- Minimal broot config for neovim: Enter outputs the file path
-- instead of launching an editor inside the floating terminal.
local NVIM_CONF = [[
verbs: [
    {
        key: enter
        internal: ":print_path"
        apply_to: file
    }
]
]]

--- Open broot in a floating terminal.
--- When the user selects a file and presses Enter, broot exits
--- and neovim opens that file in the current window.
---@param opts? { dir?: string }
function M.open(opts)
  opts = opts or {}
  local dir = opts.dir or vim.fn.getcwd()
  local tmpfile = vim.fn.tempname()

  local conffile = vim.fn.tempname() .. ".hjson"
  vim.fn.writefile(vim.split(NVIM_CONF, "\n"), conffile)

  -- Create a floating window with a terminal buffer
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines * 0.85)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " broot ",
    title_pos = "center",
  })

  vim.fn.termopen({ "broot", "--outcmd", tmpfile, "--conf", conffile, dir }, {
    cwd = dir,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        -- Clean up floating window
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
        vim.fn.delete(conffile)

        if exit_code ~= 0 or vim.fn.filereadable(tmpfile) ~= 1 then
          return
        end
        local lines = vim.fn.readfile(tmpfile)
        vim.fn.delete(tmpfile)

        for _, line in ipairs(lines) do
          local path = line:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
          if path ~= "" then
            vim.cmd("edit " .. vim.fn.fnameescape(path))
          end
        end
      end)
    end,
  })

  vim.cmd("startinsert")
end

return M

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
