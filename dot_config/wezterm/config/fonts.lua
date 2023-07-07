local wezterm = require("wezterm")
local platform = require("utils.platform")

-- local font = 'Maple Mono SC NF'
local font_family = "JetBrainsMono Nerd Font Mono"
local font_size = platform.is_mac and 14 or 12

return {
	-- Disable annoying default behaviors
	adjust_window_size_when_changing_font_size = false,
	-- that one was opening a separate win on first unknown glyph, stealing windows focus (!!)
	-- warn_about_missing_glyphs = false,

	font = wezterm.font({
		family = font_family,
		weight = "Medium",
	}),
	font_size = font_size,

	--ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
	freetype_load_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
	freetype_render_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'

	-- Enable various OpenType features
	-- See https://docs.microsoft.com/en-us/typography/opentype/spec/featurelist
	harfbuzz_features = {
		"zero", -- Use a slashed zero '0' (instead of dotted)
		"kern", -- (default) kerning (todo check what is really is)

		-- disable ligatures
		"liga=0",
		"clig=0",
		"calt=0",
	},
}
