local wezterm = require('wezterm')
local platform = require('utils.platform')
local backdrops = require('utils.backdrops')
local act = wezterm.action

local mod = {}

if platform.is_mac then
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
   mod.CMD = 'CTRL'
elseif platform.is_win or platform.is_linux then
   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER_REV = 'ALT|CTRL'
   mod.CMD = 'CTRL'
end

-- stylua: ignore
---@type Key[]
local keys = {
   -- misc/useful --
   { key = 'F1', mods = 'NONE', action = act.ActivateCopyMode },
   { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   {
      key = 'F5',
      mods = 'NONE',
      action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
   },
   { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },

   --override
   { key = 'Enter', mods = mod.SUPER, action = act.ToggleFullScreen},

   { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
   { key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },
   {
      key = 'u',
      mods = mod.SUPER_REV,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
         },
         action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.log_info('opening: ' .. url)
            wezterm.open_with(url)
         end),
      }),
   },

   -- cursor movement --
   -- { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString('\u{1b}OH') },
   -- { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString('\u{1b}OF') },
   -- { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString('\u{15}') },
   -- override
   { key = 'LeftArrow',  mods = mod.CMD,     action = act.SendString('\u{1b}OH') },
   { key = 'RightArrow', mods = mod.CMD,     action = act.SendString('\u{1b}OF') },
   -- { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString('\u{15}') },

   -- copy/paste --
   { key = 'c',          mods = 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') },
   { key = 'v',          mods = 'CTRL|SHIFT',  action = act.PasteFrom('Clipboard') },

   -- tabs --
   -- tabs: spawn+close
   -- { key = 't',          mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },
   -- { key = 't',          mods = mod.SUPER_REV, action = act.SpawnTab({ DomainName = 'wsl:ubuntu-fish' }) },
   -- { key = 'w',          mods = mod.SUPER_REV, action = act.CloseCurrentTab({ confirm = false }) },
   -- overrided by inserting

   -- tabs: navigation
   -- { key = '[',          mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },
   -- { key = ']',          mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
   -- { key = '[',          mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
   -- { key = ']',          mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },
   -- override
   { key = '[',          mods = mod.CMD,     action = act.ActivateTabRelative(-1) },
   { key = ']',          mods = mod.CMD,     action = act.ActivateTabRelative(1) },
   { key = '[',          mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) },
   { key = ']',          mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1) },

   -- tab: title
   -- { key = '0',          mods = mod.SUPER,     action = act.EmitEvent('tabs.manual-update-tab-title') },
   -- { key = '0',          mods = mod.SUPER_REV, action = act.EmitEvent('tabs.reset-tab-title') },

   -- tab: hide tab-bar
   { key = '9',          mods = mod.SUPER,     action = act.EmitEvent('tabs.toggle-tab-bar'), },

   -- window --
   -- window: spawn windows
   -- { key = 'n',          mods = mod.SUPER,     action = act.SpawnWindow },
   -- overrided by inserting

   -- window: zoom window
   {
      key = '-',
      -- mods = mod.SUPER,
      -- override
      mods = mod.CMD,
      action = wezterm.action_callback(function(window, _pane)
         local dimensions = window:get_dimensions()
         -- on Windows 11 (the only OS I'm able to test this on), `is_full_screen` is always false (it's a bug).
         -- Calling `set_inner_size` when the window is actually in fullscreen will cause the
         -- program UI to completely freeze.
         if platform.is_win or dimensions.is_full_screen then
            return
         end
         local new_width = dimensions.pixel_width - 50
         local new_height = dimensions.pixel_height - 50
         window:set_inner_size(new_width, new_height)
      end)
   },
   {
      key = '=',
      -- mods = mod.SUPER,
      -- override
      mods = mod.CMD,
      action = wezterm.action_callback(function(window, _pane)
         local dimensions = window:get_dimensions()
         -- on Windows 11 (the only OS I'm able to test this on), `is_full_screen` is always false (it's a bug).
         -- Calling `set_inner_size` when the window is actually in fullscreen will cause the
         -- program UI to completely freeze.
         if platform.is_win or dimensions.is_full_screen then
            return
         end
         local new_width = dimensions.pixel_width + 50
         local new_height = dimensions.pixel_height + 50
         window:set_inner_size(new_width, new_height)
      end)
   },
   {
      key = 'Enter',
      mods = mod.SUPER_REV,
      action = wezterm.action_callback(function(window, _pane)
         window:maximize()
      end)
   },

   -- background controls --
   {
      key = [[/]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:random(window)
      end),
   },
   {
      key = [[,]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_back(window)
      end),
   },
   {
      key = [[.]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_forward(window)
      end),
   },
   {
      key = [[/]],
      mods = mod.SUPER_REV,
      action = act.InputSelector({
         title = 'InputSelector: Select Background',
         choices = backdrops:choices(),
         fuzzy = true,
         fuzzy_description = 'Select Background: ',
         action = wezterm.action_callback(function(window, _pane, idx)
            if not idx then
               return
            end
            ---@diagnostic disable-next-line: param-type-mismatch
            backdrops:set_img(window, tonumber(idx))
         end),
      }),
   },
   {
      key = 'b',
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:toggle_focus(window)
      end)
   },

   -- panes --
   -- panes: split panes
   -- {
   --    key = [[\]],
   --    mods = mod.SUPER,
   --    action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   -- },
   -- {
   --    key = [[\]],
   --    mods = mod.SUPER_REV,
   --    action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   -- },
   -- controlled by my behaviour

   -- panes: zoom+close pane
   -- { key = 'Enter', mods = mod.SUPER,     action = act.TogglePaneZoomState },
   -- use alt+enter for full screen
   { key = 'w',     mods = mod.SUPER,     action = act.CloseCurrentPane({ confirm = false }) },

   -- panes: navigation
   -- { key = 'k',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
   -- { key = 'j',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
   -- { key = 'h',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
   -- { key = 'l',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },
   -- controlled by my behaviour
   {
      key = 'p',
      -- mods = mod.SUPER_REV
      -- override
      mods = mod.CMD,
      action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
   },

   -- panes: scroll pane
   -- { key = 'u',        mods = mod.SUPER, action = act.ScrollByLine(-5) },
   -- { key = 'd',        mods = mod.SUPER, action = act.ScrollByLine(5) },
   -- { key = 'PageUp',   mods = 'NONE',    action = act.ScrollByPage(-0.75) },
   -- { key = 'PageDown', mods = 'NONE',    action = act.ScrollByPage(0.75) },
   -- controlled by my behaviour

   -- key-tables --
   -- resizes fonts
   -- {
   --    key = 'f',
   --    mods = 'LEADER',
   --    action = act.ActivateKeyTable({
   --       name = 'resize_font',
   --       one_shot = false,
   --       timeout_milliseconds = 1000,
   --    }),
   -- },
   -- -- resize panes
   -- {
   --    key = 'p',
   --    mods = 'LEADER',
   --    action = act.ActivateKeyTable({
   --       name = 'resize_pane',
   --       one_shot = false,
   --       timeout_milliseconds = 1000,
   --    }),
   -- },
   -- override undefined
}

-- ========== my key table ==========
table.insert(keys, { key = 'w', mods = 'CTRL',       action = act.CloseCurrentTab({ confirm = false }) })
table.insert(keys, { key = 'w', mods = 'CTRL|SHIFT', action = act.QuitApplication })
table.insert(keys, { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab('CurrentPaneDomain') })

table.insert(keys, {
   key = 'b', mods = 'CTRL',
   action = act.ActivateKeyTable({ name = 'pane_leader', one_shot = true }),
})

table.insert(keys, { key = 'LeftArrow',  mods = 'SHIFT', action = act.AdjustPaneSize({ 'Left', 1 }) })
table.insert(keys, { key = 'RightArrow', mods = 'SHIFT', action = act.AdjustPaneSize({ 'Right', 1 }) })
table.insert(keys, { key = 'UpArrow',    mods = 'SHIFT', action = act.AdjustPaneSize({ 'Up', 1 }) })
table.insert(keys, { key = 'DownArrow',  mods = 'SHIFT', action = act.AdjustPaneSize({ 'Down', 1 }) })
if platform.is_win then
   table.insert(keys, {
      key = '1', mods = 'CTRL',
      action = act.SpawnCommandInNewTab({ args = { 'pwsh.exe', '-NoLogo' } }),
   })
   table.insert(keys, {
      key = '2', mods = 'CTRL',
      action = act.SpawnCommandInNewTab({ args = { 'wsl.exe', '-d', 'Ubuntu' } }),
   })
elseif platform.is_mac then
   -- 
elseif platform.is_linux then
   --
end
-- ========== End of my key table ==========

-- stylua: ignore
---@type table<string, Key[]>
local key_tables = {
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize },
      { key = 'j',      action = act.DecreaseFontSize },
      { key = 'r',      action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   -- ========== my leader table ==========
   pane_leader = {
      { key = 'h', action = act.ActivatePaneDirection('Left') },
      { key = 'j', action = act.ActivatePaneDirection('Down') },
      { key = 'k', action = act.ActivatePaneDirection('Up') },
      { key = 'l', action = act.ActivatePaneDirection('Right') },
      { key = '.', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
      { key = ',', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
      { key = 'z', action = act.TogglePaneZoomState },
      { key = 'x', action = act.CloseCurrentPane({ confirm = true }) },
   },
   -- ========== End of my leader table ==========
}

---@type MouseBinding[]
local mouse_bindings = {
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
}

---@type Config
return {
   disable_default_key_bindings = true,
   -- disable_default_mouse_bindings = true,
   leader = { key = 'Space', mods = mod.SUPER_REV },
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
