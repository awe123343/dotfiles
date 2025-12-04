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

config.automatically_reload_config = true

-- config.animation_fps = 60
-- config.max_fps = 60
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'

-- For example, changing the color scheme:
config.color_scheme = 'Everblush'
config.colors = {
  -- selection_fg = "#f5c2e7",
  selection_fg = '#67b0e8',
  selection_bg = '#485254',
  -- selection_fg = "#9da2a2",
  -- selection_bg = '#141b1e',
}

config.window_padding = {
  left = 8,
  right = 8,
  top = 24,
  bottom = 8,
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

config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 13.0
config.line_height = 1.15

-- Weight: Regular=400, DemiBold=600, Bold=700, ExtraBold=800
config.font_rules = {
  {
    intensity = 'Bold',
    italic = false,
    font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Bold' }),
  },
  {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font('JetBrainsMono Nerd Font', { style = 'Italic' }),
  },
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Bold', style = 'Italic' }),
  },
}

-- Copy on select to system clipboard (and handle hyperlinks)
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.Multiple({
      wezterm.action.CompleteSelection('ClipboardAndPrimarySelection'),
      wezterm.action.OpenLinkAtMouseCursor,
    }),
  },
  -- Allow Cmd+Click to force open link (using SUPER for macOS Cmd)
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

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
}

-- config.scrollback_lines = 99999
config.enable_scroll_bar = false
-- config.alternate_buffer_wheel_scroll_speed = 10

config.window_close_confirmation = 'NeverPrompt'

-- and finally, return the configuration to wezterm
return config
