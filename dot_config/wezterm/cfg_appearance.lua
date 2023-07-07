local cfg = {}

--cfg.enable_tab_bar = false
--cfg.hide_tab_bar_if_only_one_tab = true
cfg.native_macos_fullscreen_mode = true
cfg.window_decorations = "RESIZE"

-- Pad window to avoid the content to be too close to the border,
-- so it's easier to see and select.
cfg.window_padding = {
	left = 3,
	right = 3,
	top = 3,
	bottom = 3,
}

cfg.inactive_pane_hsb = {
	-- NOTE: these values are multipliers, applied on normal pane values
	-- saturation = 0.8,
	-- brightness = 0.7,
}

cfg.colors = {
	selection_bg = "rgba(100% 50% 50% 20%)",
}

cfg.color_scheme = "Solarized (dark) (terminal.sexy)"
cfg.window_background_opacity = 0.85

return cfg
