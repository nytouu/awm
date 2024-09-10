---@diagnostic disable: undefined-global
local awful = require("awful")

local function _()
	return awful.screen.focused().dashboard
end

awesome.connect_signal("toggle::dashboard", function()
	_().toggle()
end)

awesome.connect_signal("visibility::dashboard", function(v)
	if v then
		_().open()
	else
		_().hide()
	end
end)
