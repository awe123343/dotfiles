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
config.native_macos_fullscreen_mode = true

config.font = wezterm.font_with_fallback({
  'JetBrains Mono',
  'Symbols Nerd Font',
})
config.font_size = 13.0
config.line_height = 1.15

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
}

-- config.scrollback_lines = 99999
config.enable_scroll_bar = true
-- config.alternate_buffer_wheel_scroll_speed = 10

config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = true
config.use_fancy_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true

config.window_close_confirmation = 'NeverPrompt'

-- and finally, return the configuration to wezterm
return config
