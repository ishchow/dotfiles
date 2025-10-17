local wezterm = require 'wezterm'

local config = {}

local is_windows = wezterm.target_triple:find("windows") ~= nil

if is_windows then
  config.default_prog = { "powershell.exe", "-NoLogo" }
else
  -- Try to find the fish shell in PATH
  local function find_fish()
    local handle = io.popen("command -v fish")
    if handle then
      local result = handle:read("*a")
      handle:close()
      if result then
        result = result:gsub("%s+$", "") -- trim trailing whitespace/newlines
        if result ~= "" then
          return result
        end
      end
    end
    return nil
  end

  local fish_path = find_fish()

  if fish_path then
    config.default_prog = { fish_path, "-l" }
    wezterm.log_info("Using fish shell at: " .. fish_path)
  else
    wezterm.log_warn("Fish shell not found in PATH.")
  end
end

return config