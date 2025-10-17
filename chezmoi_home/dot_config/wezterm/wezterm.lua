local wezterm = require 'wezterm'

local config = {}
local is_windows = wezterm.target_triple:find("windows") ~= nil

if is_windows then
else
end

return config