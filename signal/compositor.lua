local awful = require("awful")
local gears = require("gears")

local function compositor_emit()
	awful.spawn.easy_async_with_shell("sh -c '[ $(pgrep picom) ] && echo yes || echo no'", function(stdout)
		local status = stdout:match("yes") -- boolean
		awesome.emit_signal("signal::compositor", status)
	end)
end

gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = function()
		compositor_emit()
	end,
})
