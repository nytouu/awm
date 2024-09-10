local awful = require("awful")
local gears = require("gears")

local function theme_emit()
	awful.spawn.easy_async_with_shell("sh -c 'cat ~/git/daynight/status'", function(value)
		local stringtoboolean = { ["day"] = true, ["night"] = false }
		value = value:gsub("%s+", "")
		value = stringtoboolean[value]
		awesome.emit_signal("signal::theme", value) -- integer
	end)
end

gears.timer({
	timeout = 5,
	call_now = true,
	autostart = true,
	callback = function()
		theme_emit()
	end,
})
