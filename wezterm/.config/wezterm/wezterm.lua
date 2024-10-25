-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme
-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Light'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Frappe'
  else
    return 'Catppuccin Latte'
  end
end
config.color_scheme = scheme_for_appearance(get_appearance())

-- Remove all path components and return only the last value
local function remove_abs_path(path) return path:gsub("(.*[/\\])(.*)", "%2") end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- current working directory
function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then return title end
	local pwd_path = tab_info.active_pane.current_working_dir.file_path
	return remove_abs_path(pwd_path)
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local title = tab_title(tab)
    if tab.is_active then
      return {
        { Background = { Color = 'blue' } },
        { Text = ' ' .. title .. ' ' },
      }
    end
    return title
  end
)


-- mouse bindings
-- https://wezfurlong.org/wezterm/config/mouse.html
config.disable_default_mouse_bindings = false
config.mouse_bindings = {
	-- only allowed to open links, not copy selection
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'NONE',
		action = wezterm.action.OpenLinkAtMouseCursor
	},
	-- this is so copy doesn't happen on highlight when i double/triple click
	{
		event = { Up = { streak = 2, button = 'Left' } },
		mods = 'NONE',
		action = wezterm.action.Nop
	},
	{
    event = { Up = { streak = 3, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.Nop
  }
}

-- keyDisableDefaultAssignmentbindings
config.keys = {
	-- disable ctrl+ - for emacs to use for undo
	{
		mods = 'CTRL',
		key = '-',
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		mods = 'CTRL',
		key = '=',
		action = wezterm.action.Nop,
	},
	{
		mods = 'CMD',
		key = 'k',
		action = wezterm.action.ClearScrollback 'ScrollbackAndViewport'
	},
	-- move tabs around. shift + option key on mac
	{ key = '{', mods = 'SHIFT|ALT', action = wezterm.action.MoveTabRelative(-1) },
	{ key = '}', mods = 'SHIFT|ALT', action = wezterm.action.MoveTabRelative(1) },
	 {
		 key =  "a",
		 mods = "CMD",
		 action = wezterm.action_callback(function(window, pane)
				 local selected = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
				 window:copy_to_clipboard(selected, 'Clipboard')
		 end)
	 },
}

-- How many lines of scrollback you want to retain per tab
config.scrollback_lines = 100000

-- Don't close on command exit
config.exit_behavior = 'Hold'
config.exit_behavior_messaging = 'Brief'

-- ligatures suck
-- wezterm docs: https://wezfurlong.org/wezterm/config/font-shaping.html#advanced-font-shaping-options
-- https://harfbuzz.github.io/opentype-shaping-models.html <- had to use this for default
config.harfbuzz_features = { 'default=0', 'calt=0', 'clig=0', 'liga=0' }

-- and finally, return the configuration to wezterm
return config
