local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- define OS
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_macos   = wezterm.target_triple:find("apple") ~= nil
local is_linux   = wezterm.target_triple:find("linux") ~= nil

-- font settings
config.font_size = 14
config.font = wezterm.font("Maple Mono NF")
config.color_scheme = "OneHalfDark"
config.font = wezterm.font_with_fallback ({
        "Maple Mono",
        "Microsoft YaHei",
})

-- window settings
config.initial_cols = 120
config.initial_rows = 30
config.window_background_opacity = 1
config.text_background_opacity = 1
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.enable_scroll_bar = true
config.window_frame = {
    font = wezterm.font("Maple Mono NF"),
    font_size = 10,
}
config.tab_max_width = 40

-- shell
if is_windows then
    config.default_prog = {
        "pwsh.exe",
    }
    config.launch_menu = {
        {label="PowerShell", args={"pwsh.exe"},},
        {label="Ubuntu WSL", args={"wsl.exe", "-d", "Ubuntu"},},
    }
elseif is_macos then
    -- 
elseif is_linux then
    -- 
end

-- history
config.scrollback_lines = 10000

-- animation
config.animation_fps = 60

-- key
config.use_dead_keys = true
local my_config_keys = {
    -- Ctrl + W: close current tab 
    {
        key = 'w', mods = 'CTRL',
        action = wezterm.action.CloseCurrentTab{confirm=false},
    },
    -- Ctrl + Shift + W: close current window
    {
        key = 'w', mods = 'CTRL|SHIFT',
        action = wezterm.action.QuitApplication,
    },
    -- Ctrl + Shift + T: new tab
    {
        key = "t", mods = "CTRL|SHIFT",
        action = wezterm.action.SpawnTab "CurrentPaneDomain",
    },
    -- -- Ctrl + Shift + C: copy
    -- {
    --     key = "c", mods = "CTRL|SHIFT",
    --     action = wezterm.action.CopyTo "Clipboard",
    -- },
    -- -- Ctrl + Shift + V: paste
    -- {
    --     key = "v", mods = "CTRL|SHIFT",
    --     action = wezterm.action.PasteFrom "Clipboard",
    -- },
    -- -- Ctrl + 1: Powershell
    -- {
    --     key = "1", mods = "CTRL",
    --     action = wezterm.action.SpawnCommandInNewTab{args={"pwsh.exe","-NoLogo",},},
    -- },
    -- -- Ctrl + 2: Ubuntu
    -- {
    --     key="2", mods="CTRL",
    --     action=wezterm.action.SpawnCommandInNewTab{args={"wsl.exe","-d","Ubuntu"},},
    -- },
    -- Leader Ctrl+B (pane control)
    {
        key = "b", mods = "CTRL",
        action = wezterm.action.ActivateKeyTable {
            name = "pane_leader", one_shot = true;
        }
    },
    {key="LeftArrow", mods = "SHIFT", action=wezterm.action.AdjustPaneSize{"Left",1},},
    {key="RightArrow", mods = "SHIFT", action=wezterm.action.AdjustPaneSize{"Right",1},},
    {key="UpArrow", mods = "SHIFT", action=wezterm.action.AdjustPaneSize{"Up",1},},
    {key="DownArrow", mods = "SHIFT", action=wezterm.action.AdjustPaneSize{"Down",1},},
    -- -- emacs
    -- {key='a', mods='CTRL', action=wezterm.action.SendString('\x01')},
    -- {key='e', mods='CTRL', action=wezterm.action.SendString('\x05')},
    -- {key='u', mods='CTRL', action=wezterm.action.SendString('\x15')},
    -- {key='k', mods='CTRL', action=wezterm.action.SendString('\x0b')},
}
if is_windows then
    -- Ctrl + 1: PowerShell
    table.insert(my_config_keys, {
        key = "1", mods = "CTRL",
        action = wezterm.action.SpawnCommandInNewTab{args={"pwsh.exe","-NoLogo",},},
    })
    -- Ctrl + 2: Ubuntu (WSL)
    table.insert(my_config_keys, {
        key = "2", mods = "CTRL",
        action = wezterm.action.SpawnCommandInNewTab{args={"wsl.exe","-d","Ubuntu"},},
    })
elseif is_macos then
    -- 
elseif is_linux then
    -- 
end
config.keys = my_config_keys

config.key_tables = {
    pane_leader = {
        -- activate pane
        {key="h", action=wezterm.action.ActivatePaneDirection "Left",},
        {key="j", action=wezterm.action.ActivatePaneDirection "Down",},
        {key="k", action=wezterm.action.ActivatePaneDirection "Up",},
        {key="l", action=wezterm.action.ActivatePaneDirection "Right",},
        -- split
        {
            key=".",
            action=wezterm.action.SplitHorizontal{domain="CurrentPaneDomain",},
        },
        {
            key=",",
            action=wezterm.action.SplitVertical{domain="CurrentPaneDomain",},
        },
        -- pane control
        -- maximise current pane
        {key="z", action=wezterm.action.TogglePaneZoomState,},
        -- close current pane
        {key="x", action=wezterm.action.CloseCurrentPane{confirm=true,},},
    },
}

return config
