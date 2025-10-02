local M = {}

function M.check_executable(cmd, opts)
  opts = opts or {}

  -- Set default value for warn_if_missing if not explicitly set
  if opts.warn_if_missing == nil then
    opts.warn_if_missing = true
  end

  local found = vim.fn.executable(cmd) == 1

  if not found and opts.warn_if_missing then
    vim.schedule(function()
        vim.notify(cmd .. " not found in PATH", vim.log.levels.WARN)
    end)
  end

  return found
end

return M