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
		act.EmitEvent("tabs.manual-update-tab-title")
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

	-- 截图贴给远端：框选截图 → 传到当前 pane 连着的 SSH 机器 /tmp → 把远端路径粘贴进来
	-- （终端只能传文字，Claude Code 收到图片路径会自己读图）。本机 pane 直接粘贴本地路径。
	keybind(mods.MS, "s", act.EmitEvent("my-screenshot-to-pane")),
}

-- 找出 pane 连着的 SSH 主机：SSH domain 的 pane，或前台进程是 `ssh <host>`
local function pane_ssh_host(pane)
	local domain = pane:get_domain_name() or ""
	if domain:sub(1, 4) == "SSH:" then
		return domain:sub(5)
	end
	local info = pane:get_foreground_process_info()
	if not info or not (info.name or ""):match("ssh$") then
		return nil
	end
	-- 跳过带参数的选项（-p 22、-i key、-J jump 等），第一个非选项参数就是主机
	local takes_value = "bcDEeFIiJLlmOoPpQRSWw"
	local i = 2
	while i <= #info.argv do
		local a = info.argv[i]
		if a:sub(1, 1) ~= "-" then
			return a
		end
		if #a == 2 and takes_value:find(a:sub(2, 2), 1, true) then
			i = i + 1
		end
		i = i + 1
	end
	return nil
end

wezterm.on("my-screenshot-to-pane", function(win, pane)
	local name = "shot-" .. os.date("%m%d-%H%M%S") .. ".png"
	local path = "/tmp/" .. name
	wezterm.run_child_process({ "/usr/sbin/screencapture", "-i", path })
	local f = io.open(path, "r")
	if not f then
		return -- 按了 Esc 取消
	end
	f:close()

	local host = pane_ssh_host(pane)
	if not host then
		pane:send_paste(path .. " ")
		return
	end
	local ok, _, err = wezterm.run_child_process({ "/usr/bin/scp", "-q", path, host .. ":/tmp/" .. name })
	if ok then
		pane:send_paste("/tmp/" .. name .. " ")
	else
		win:toast_notification("截图上传失败", host .. ": " .. (err or ""), nil, 4000)
	end
end)

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
