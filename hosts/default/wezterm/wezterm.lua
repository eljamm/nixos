local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action

-- --- Specify default font
-- config.font = wezterm.font 'FiraCode Nerd Font'
config.warn_about_missing_glyphs = false

--- Theme
local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Macchiato'
  else
    return 'Catppuccin Latte'
  end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

--- Spawn a fish shell in login mode
config.default_prog = { 'fish', '-l' }

--- Disable the title bar but enable the resizable border
config.window_decorations = 'RESIZE'

--- Customized Bar
config.hide_tab_bar_if_only_one_tab = true
wezterm.plugin.require('https://github.com/nekowinston/wezterm-bar').apply_to_config(config, {
  position = 'bottom',
  max_width = 32,
  dividers = 'slant_right', -- "slant_right" or "slant_left", "arrows", "rounded", false
  indicator = {
    leader = {
      enabled = false,
      off = ' ',
      on = ' ',
    },
    mode = {
      enabled = true,
      names = {
        resize_mode = 'RESIZE',
        copy_mode = 'VISUAL',
        search_mode = 'SEARCH',
      },
    },
  },
  tabs = {
    numerals = 'arabic', -- or "roman"
    pane_count = 'superscript', -- "superscript" or "subscript", false
    brackets = {
      active = { '󱄅 ', '' },
      inactive = { '', '' },
    },
    hide_inactive = {
      enabled = true,
      ignore_renamed = true,
    },
  },
  clock = { -- note that this overrides the whole set_right_status
    enabled = false,
    format = '%H:%M', -- use https://wezfurlong.org/wezterm/config/lua/wezterm.time/Time/format.html
  },
})

config.keys = {
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  -- Disable Alt+Enter fullscreen
  {
    key = 'Enter',
    mods = 'ALT',
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- Tab Movements
  {
    key = 'J',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.MoveTabRelative(-1),
  },
  {
    key = 'K',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.MoveTabRelative(1),
  },
  -- Tab Navigation
  {
    key = 'j',
    mods = 'CTRL|ALT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'k',
    mods = 'CTRL|ALT',
    action = wezterm.action.ActivateTabRelative(1),
  },
}

-- --- Remove padding
config.window_padding = {
  -- left = 0,
  -- right = 0,
  top = 0,
  bottom = 0,
}

--- Enable the scrollbar
config.enable_scroll_bar = true

--- Maximize on startup
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
