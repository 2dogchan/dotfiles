-- SSH domains: one per Host in ~/.ssh/config (and config.d/), so the launcher can open them directly.
local wezterm = require("wezterm")

local ssh_domains = {}
for host, _ in pairs(wezterm.enumerate_ssh_hosts()) do
	table.insert(ssh_domains, {
		name = "SSH:" .. host,
		remote_address = host,
		multiplexing = "None",
		assume_shell = "Posix",
	})
end
table.sort(ssh_domains, function(a, b)
	return a.name < b.name
end)

return {
	ssh_domains = ssh_domains,
	unix_domains = {},
	wsl_domains = {}, -- events/new-tab-button.lua iterates all three lists
}
