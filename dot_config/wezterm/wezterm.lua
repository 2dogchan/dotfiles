-- Entry point. Pieces live in config/ (options), events/ (status bar, tabs) and utils/ (helpers).
local Config = require("config")
local wezterm = require("wezterm")

-- Random wallpaper from ~/Pictures/wezterm-backdrops (kept out of the dotfiles repo; empty dir = no backdrop)
require("utils.backdrops"):set_images_dir(wezterm.home_dir .. "/Pictures/wezterm-backdrops"):set_images():random()

require("events.left-status").setup()
require("events.right-status").setup({ date_format = "%a %H:%M:%S" })
require("events.tab-title").setup({ hide_active_tab_unseen = false, unseen_icon = "circle" })
require("events.new-tab-button").setup()

return Config:init()
	:append(require("config.appearance"))
	:append(require("config.keys"))
	:append(require("config.mouse"))
	:append(require("config.domains"))
	:append(require("config.fonts"))
	:append(require("config.general"))
	:append(require("config.launch"))
	.options
