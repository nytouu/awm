local awful = require("awful")
local gears = require("gears")

-- Network Fetching and Signal Emitting
---------------------------------------
local function emit_network_status()
	awful.spawn.easy_async_with_shell("sh -c 'connmanctl technologies | grep Powered | sed \"3!d\"'", function(stdout)
		local status = stdout:match("True") -- boolean
		awesome.emit_signal("signal::network", status)
	end)
end

-- Refreshing
-------------
gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = function()
		emit_network_status()
	end,
})
