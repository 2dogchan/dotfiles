local wezterm = require("wezterm")

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- WezTerm configuration
---------------------------------------------------------------

config.window_close_confirmation = "NeverPrompt"
config.selection_word_boundary = " \t\n{}[]()\"'`,;:@│*"

-- Merge configs and return!
------------------------------------------
require("on")

local mytable = require("lib.table")
local full_config = mytable.merge_all(
	config,
	require("cfg_appearance"),
	require("cfg_fonts"),
	require("cfg_keys"),
	require("cfg_mouse"),
	require("cfg_ssh"),
	{} -- so the last table can have an ending comma for git diffs :)
)

return full_config
