local wezterm = require "wezterm"

local cfg = {}

cfg.ssh_domains = {}

for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
	table.insert(cfg.ssh_domains, {
		name = host,
		remote_address = config.hostname .. ":" .. config.port,
		username = config.user,
		multiplexing = "None",
		assume_shell = "Posix",
	})
end

return cfg