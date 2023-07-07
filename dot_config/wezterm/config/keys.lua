local wezterm = require("wezterm")
local mytable = require("utils.table")
local mods = require("utils.mods").mods

local act = wezterm.action
local act_callback = wezterm.action_callback

local cfg = {}

-- Helper for keybind definition
local function keybind(mods, keys, action)
	local keys = (type(keys) == "table") and keys or { keys }
	local mods = mods
	local binds = {}
	for _, key in ipairs(keys) do
		table.insert(binds, { mods = mods, key = key, action = action })
	end
	return binds
end

cfg.disable_default_key_bindings = true

cfg.key_tables = {}
local function define_and_activate_keytable(spec)
	-- Flatten keys, and define the Key Table
	cfg.key_tables[spec.name] = mytable.flatten_list(spec.keys)

	-- Setup & return activation key bind
	local activation_opts = spec.activation or {}
	activation_opts.name = spec.name
	return act.ActivateKeyTable(activation_opts)
end

-- NOTE: About SHIFT and the keybind definition:
-- * For bindings with SHIFT and a letter, the `key` field (the letter)
--   can be lowercase and the mods should NOT contain 'SHIFT'.
-- * For bindings with SHIFT and something else, mod should contain SHIFT,
--   and key should be the shifted key that is going to reach the terminal.
--   (based on the keyboard-layout)
cfg.keys = {
	keybind(mods.M, "\\", "ToggleFullScreen"),
	keybind(mods.M, "u", act.ScrollByPage(-1)),
	keybind(mods.M, "d", act.ScrollByPage(1)),
	keybind(mods.M, "y", act.ScrollByLine(-3)),
	keybind(mods.M, "e", act.ScrollByLine(3)),
	keybind(mods.M, "f", act.Search({ CaseInSensitiveString = "" })),
	keybind(mods.M, "/", act.ActivateCopyMode),

	-- Copy/Paste to/from Clipboard
	keybind(mods.M, "c", act.CopyTo("ClipboardAndPrimarySelection")),
	keybind(mods.M, "v", act.PasteFrom("Clipboard")),

	-- Paste from PrimarySelection
	keybind(mods.S, "Insert", act.PasteFrom("PrimarySelection")),

	-- Smart copy with Alt-c:
	-- - If active selection, will copy it to Clipboard & Primary
	-- - If NO selection, sends Alt-c to the running program
	keybind(
		mods.A,
		"c",
		act_callback(function(win, pane)
			local has_selection = win:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				win:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
			else
				win:perform_action(act.SendKey({ mods = mods.A, key = "c" }), pane)
			end
		end)
	),

	keybind(mods.M, "x", act.ShowLauncher),

	-- Key Table: Tab Management
	keybind(mods.M, "o", act.SpawnTab("DefaultDomain")),
	keybind(mods.M, "n", act.ActivateTabRelative(1)),
	keybind(mods.M, "p", act.ActivateTabRelative(-1)),
	keybind(mods.MS, "<", act.MoveTabRelative(-1)),
	keybind(mods.MS, ">", act.MoveTabRelative(1)),
	keybind(mods.M, "w", act.CloseCurrentTab({ confirm = false })),
	-- Renaming Tab
	keybind(
		mods.M,
		"t",
		act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		})
	),

	-- Font size
	keybind(mods.M, "0", act.ResetFontSize), -- Ctrl-Shift-0
	keybind(mods.M, "-", act.DecreaseFontSize), -- Ctrl-Shift-- (key with -)
	keybind(mods.M, "=", act.IncreaseFontSize), -- Ctrl-Shift-+ (key with +)

	-- Toggle font ligatures
	keybind(
		mods.CS,
		"g",
		act_callback(function(win, _)
			local overrides = win:get_config_overrides() or {}
			if not overrides.harfbuzz_features then
				-- If we haven't overriden it yet, then override with ligatures disabled
				overrides.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
			else
				-- else we did already, and we should disable the override now
				overrides.harfbuzz_features = nil
			end
			win:set_config_overrides(overrides)
		end)
	),

	-- Key Table: Panes Management
	keybind(
		mods.MS,
		"p",
		define_and_activate_keytable({
			name = "my-panes-management",
			activation = { one_shot = false },
			keys = {
				keybind(mods._, "Escape", act.PopKeyTable),
				keybind(mods.M, "p", act.PopKeyTable),

				keybind(mods.M, "q", act.CloseCurrentPane({ confirm = true })),

				-- Create
				keybind(mods.S, { "h", "LeftArrow" }, act.SplitPane({ direction = "Left" })),
				keybind(mods.S, { "j", "DownArrow" }, act.SplitPane({ direction = "Down" })),
				keybind(mods.S, { "k", "UpArrow" }, act.SplitPane({ direction = "Up" })),
				keybind(mods.S, { "l", "RightArrow" }, act.SplitPane({ direction = "Right" })),

				-- Navigation
				keybind(mods.M, { "h", "LeftArrow" }, act.ActivatePaneDirection("Left")),
				keybind(mods.M, { "j", "DownArrow" }, act.ActivatePaneDirection("Down")),
				keybind(mods.M, { "k", "UpArrow" }, act.ActivatePaneDirection("Up")),
				keybind(mods.M, { "l", "RightArrow" }, act.ActivatePaneDirection("Right")),
				keybind(mods.M, "r", act.RotatePanes("Clockwise")),
				keybind(mods.MS, "r", act.RotatePanes("CounterClockwise")),

				-- Manipulation
				keybind(mods.S, "Space", act.TogglePaneZoomState),
			},
		})
	),

	-- Quick Split
	keybind(mods.M, { "Enter" }, act.SplitPane({ direction = "Right" })),
	keybind(mods.MS, { "Enter" }, act.SplitPane({ direction = "Down" })),

	-- Quick Navigate
	keybind(mods.M, { "h", "LeftArrow" }, act.ActivatePaneDirection("Left")),
	keybind(mods.M, { "j", "DownArrow" }, act.ActivatePaneDirection("Down")),
	keybind(mods.M, { "k", "UpArrow" }, act.ActivatePaneDirection("Up")),
	keybind(mods.M, { "l", "RightArrow" }, act.ActivatePaneDirection("Right")),
	keybind(mods.MS, "Space", act.TogglePaneZoomState),
	keybind(mods.M, "r", act.RotatePanes("Clockwise")),
	keybind(mods.MS, "r", act.RotatePanes("CounterClockwise")),

	-- Adjust Pane Size
	keybind(mods.MS, { "h", "LeftArrow" }, act.AdjustPaneSize({ "Left", 5 })),
	keybind(mods.MS, { "j", "DownArrow" }, act.AdjustPaneSize({ "Down", 5 })),
	keybind(mods.MS, { "k", "UpArrow" }, act.AdjustPaneSize({ "Up", 5 })),
	keybind(mods.MS, { "l", "RightArrow" }, act.AdjustPaneSize({ "Right", 5 })),

	-- Pass keys to nvim
	keybind(mods.M, { "s" }, act({ SendString = "\x13" })),
}

-- Events related to config reloading
wezterm.on("my-reload-config-with-notify", function(win, pane)
	wezterm.GLOBAL.want_reload_notification = true
	win:perform_action(act.ReloadConfiguration, pane)
	-- Will trigger the builtin `window-config-reloaded` event, the notification is wired on
	-- that event, to make sure only a _valid_ config reload will display it.
end)
wezterm.on("window-config-reloaded", function(win, _)
	if wezterm.GLOBAL.want_reload_notification then
		win:toast_notification("wezterm", "Config successfully reloaded!", nil, 1000)
		wezterm.GLOBAL.want_reload_notification = false
	end
end)

-- To simplify config composability, `cfg.keys` is (initially) a
-- nested list of (bind or list of (bind or ...)), so we must
-- flatten the list to have a list of bind.
cfg.keys = mytable.flatten_list(cfg.keys)

return cfg
