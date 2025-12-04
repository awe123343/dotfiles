-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- config.animation_fps = 60
-- config.max_fps = 60
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'

-- For example, changing the color scheme:
config.color_scheme = 'Everblush'
config.colors = {
  selection_fg = '#9da2a2',
  selection_bg = '#2f343f',
  -- selection_bg = '#141b1e',
}

config.window_background_opacity = 0.98
config.window_decorations = 'RESIZE'

config.enable_tab_bar = false
config.native_macos_fullscreen_mode = true

config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = true
config.use_fancy_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_bar_at_bottom = true

config.font = wezterm.font_with_fallback({
  'JetBrains Mono',
  'Symbols Nerd Font',
})

config.bold_brightens_ansi_colors = 'BrightAndBold'

-- Simplified rule: explicitly map the 'Bold' text style to the Bold font weight.
-- This is the cleanest way to ensure WezTerm uses the correct font variant.
config.font_rules = {
  {
    intensity = 'Bold',
    font = wezterm.font_with_fallback({
      { family = 'JetBrains Mono', weight = 'Bold' },
      'Symbols Nerd Font',
    }),
  },
}
config.font_size = 13.0
config.line_height = 1.15

-- -- Session resurrection plugin (like tmux-resurrect + continuum)
-- local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
--
-- -- Workspace switcher plugin (like tmux sessions)
-- local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
-- workspace_switcher.apply_to_config(config)
--
-- -- Enable periodic auto-save every 5 minutes
-- resurrect.state_manager.periodic_save({
--   interval_seconds = 300,
--   save_workspaces = true,
--   save_windows = true,
--   save_tabs = true,
-- })
--
-- -- Auto-save workspace when switching away
-- wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, workspace)
--   local state = resurrect.workspace_state.get_workspace_state()
--   resurrect.state_manager.save_state(state)
-- end)
--
-- -- Auto-restore workspace when switching to it
-- wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, workspace)
--   local state = resurrect.state_manager.load_state(workspace, "workspace")
--   if state and state.workspace then
--     resurrect.workspace_state.restore_workspace(state, {
--       window = window,
--       relative = true,
--       restore_text = true,
--       on_pane_restore = resurrect.tab_state.default_on_pane_restore,
--     })
--   end
-- end)
--
-- -- Auto-restore "default" workspace on startup
-- wezterm.on("gui-startup", function()
--   local state = resurrect.state_manager.load_state("default", "workspace")
--   if state and state.workspace then
--     resurrect.workspace_state.restore_workspace(state, {
--       relative = true,
--       restore_text = true,
--       on_pane_restore = resurrect.tab_state.default_on_pane_restore,
--     })
--   end
-- end)

config.keys = {
  {
    key = '/',
    mods = 'CMD',
    action = wezterm.action({ SendString = '\x20/' }),
  },
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.Multiple({
      wezterm.action.ClearScrollback('ScrollbackAndViewport'),
      wezterm.action.SendKey({ key = 'L', mods = 'CTRL' }),
    }),
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },
  -- Resurrect: Save current workspace (Cmd+Shift+S)
  -- {
  --   key = "s",
  --   mods = "CMD|SHIFT",
  --   action = wezterm.action_callback(function(win, pane)
  --     local state = resurrect.workspace_state.get_workspace_state()
  --     resurrect.state_manager.save_state(state)
  --     wezterm.log_info("Workspace saved: " .. (state.workspace or "unknown"))
  --     win:toast_notification("WezTerm", "✓ Session saved: " .. (state.workspace or "default"), nil, 2000)
  --   end),
  -- },
  -- -- Workspace Switcher: Switch/create workspaces like tmux sessions (Cmd+Shift+T)
  -- {
  --   key = "t",
  --   mods = "CMD|SHIFT",
  --   action = workspace_switcher.switch_workspace(),
  -- },
}

-- config.scrollback_lines = 99999
config.enable_scroll_bar = false
-- config.alternate_buffer_wheel_scroll_speed = 10

config.window_close_confirmation = 'NeverPrompt'

-- Tabline plugin
-- local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
-- tabline.setup({
--   options = {
--     -- theme_overrides = {
--     -- Everblush colors following lualine.lua pattern
--     --   normal_mode = { -- like lualine normal
--     --     a = { fg = "#141b1e", bg = "#8ccf7e" }, -- green
--     --     b = { fg = "#8ccf7e", bg = "#232a2d" },
--     --     c = { fg = "#dadada", bg = "#141b1e" },
--     --   },
--     --   copy_mode = { -- like lualine visual (selecting)
--     --     a = { fg = "#141b1e", bg = "#c47fd5" }, -- purple
--     --     b = { fg = "#c47fd5", bg = "#232a2d" },
--     --     c = { fg = "#dadada", bg = "#141b1e" },
--     --   },
--     --   search_mode = { -- like lualine insert (active input)
--     --     a = { fg = "#141b1e", bg = "#67b0e8" }, -- blue
--     --     b = { fg = "#67b0e8", bg = "#232a2d" },
--     --     c = { fg = "#dadada", bg = "#141b1e" },
--     --   },
--     --   window_mode = { -- like lualine command (managing)
--     --     a = { fg = "#141b1e", bg = "#e5c76b" }, -- yellow
--     --     b = { fg = "#e5c76b", bg = "#232a2d" },
--     --     c = { fg = "#dadada", bg = "#141b1e" },
--     --   },
--     --   tab = {
--     --     active = { fg = "#8ccf7e", bg = "#232a2d" }, -- green (normal)
--     --     inactive = { fg = "#dadada", bg = "#141b1e" }, -- white on black (inactive)
--     --     inactive_hover = { fg = "#6cbfbf", bg = "#232a2d" }, -- cyan
--     --   },
--     -- },
--     theme = "Everblush",
--   },
--   extensions = { "resurrect", "smart_workspace_switcher" }, -- Show status in tabline
-- })
-- tabline.apply_to_config(config)

config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '0.5cell',
  bottom = '0.5cell',
}

-- and finally, return the configuration to wezterm
return config
