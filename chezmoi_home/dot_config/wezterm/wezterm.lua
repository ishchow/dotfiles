local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

local is_windows = wezterm.target_triple:find("windows") ~= nil
local keys = {}

if is_windows then
    -- See https://github.com/wezterm/wezterm/issues/1813 for context
    config.prefer_egl = true

    -- Helper: check if executable exists in Windows PATH
    local function exe_exists(name)
        local ok, _stdout, _stderr = wezterm.run_child_process {'where', name}
        return ok
    end

    local has_pwsh = exe_exists('pwsh.exe')
    local has_powershell = exe_exists('powershell.exe')
    local has_cmd = exe_exists('cmd.exe')

    -- Detect WSL distros and set default_cwd = "~" to start in Linux home
    local wsl_domains = wezterm.default_wsl_domains()
    local first_wsl_name = nil
    for _, dom in ipairs(wsl_domains) do
        dom.default_cwd = "~"
    end
    if #wsl_domains > 0 then
        first_wsl_name = wsl_domains[1].name -- e.g. "WSL:Ubuntu-22.04"
        config.default_domain = first_wsl_name
    end

    -- Launch menu entries
    local launch_menu = {}
    if has_pwsh then
        table.insert(launch_menu, {
            label = 'PowerShell (pwsh)',
            domain = {
                DomainName = "local"
            }, -- force Windows domain
            args = {'pwsh.exe', '-NoLogo'}
        })

        config.default_prog = {'pwsh.exe', '-NoLogo'}
    end
    if has_powershell then
        table.insert(launch_menu, {
            label = 'PowerShell (Windows)',
            domain = {
                DomainName = "local"
            },
            args = {'powershell.exe', '-NoLogo'}
        })

        if not has_pwsh then
            config.default_prog = {'powershell.exe', '-NoLogo'}
        end
    end
    if has_cmd then
        table.insert(launch_menu, {
            label = 'Command Prompt',
            domain = {
                DomainName = "local"
            },
            args = {'cmd.exe'}
        })
    end
    for _, dom in ipairs(wsl_domains) do
        table.insert(launch_menu, {
            label = 'WSL: ' .. dom.distribution,
            domain = {
                DomainName = dom.name
            }
        })
    end
    config.launch_menu = launch_menu

    -- Keybindings
    -- WSL new tab (SpawnTab with domain)
    if first_wsl_name then
        table.insert(keys, {
            key = 'w',
            mods = 'CTRL|ALT',
            action = act.SpawnTab {
                DomainName = first_wsl_name
            }
        })
    else
        table.insert(keys, {
            key = 'w',
            mods = 'CTRL|ALT',
            action = act.SpawnCommandInNewTab {
                args = {'wsl.exe'}
            }
        })
    end

    -- PowerShell new tab in Windows domain (no vanish)
    if has_pwsh then
        table.insert(keys, {
            key = 'p',
            mods = 'CTRL|ALT',
            action = act.SpawnCommandInNewTab {
                domain = {
                    DomainName = "local"
                },
                args = {'pwsh.exe', '-NoLogo'}
            }
        })
    elseif has_powershell then
        table.insert(keys, {
            key = 'p',
            mods = 'CTRL|ALT',
            action = act.SpawnCommandInNewTab {
                domain = {
                    DomainName = "local"
                },
                args = {'powershell.exe', '-NoLogo'}
            }
        })
    end

    -- cmd new tab in Windows domain (no vanish)
    if has_cmd then
        table.insert(keys, {
            key = 'c',
            mods = 'CTRL|ALT',
            action = act.SpawnCommandInNewTab {
                domain = {
                    DomainName = "local"
                },
                args = {'cmd.exe'}
            }
        })
    end
else
end

-- Spawn tab
table.insert(keys, {
    key = 't',
    mods = 'SHIFT|ALT',
    action = act.SpawnTab 'CurrentPaneDomain'
})

-- Split panes (inherit current domain)
table.insert(keys, {
    key = '\\',
    mods = 'CTRL|ALT',
    action = act.SplitHorizontal {
        domain = 'CurrentPaneDomain'
    }
})
table.insert(keys, {
    key = '-',
    mods = 'CTRL|ALT',
    action = act.SplitVertical {
        domain = 'CurrentPaneDomain'
    }
})

-- Tab switching
for i = 1, 9 do
    table.insert(keys, {
        key = tostring(i),
        mods = 'ALT',
        action = act.ActivateTab(i - 1)
    })
end
table.insert(keys, {
    key = 'Tab',
    mods = 'CTRL',
    action = act.ActivateTabRelative(1)
})
table.insert(keys, {
    key = 'Tab',
    mods = 'CTRL|SHIFT',
    action = act.ActivateTabRelative(-1)
})
table.insert(keys, {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = act.CloseCurrentTab {
        confirm = true
    }
})
table.insert(keys, {
    key = 'r',
    mods = 'CTRL|SHIFT',
    action = act.ReloadConfiguration
})

config.keys = keys

-- Appearance
config.font = wezterm.font('JetBrains Mono')
config.font_size = 12
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

return config