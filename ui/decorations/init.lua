---@diagnostic disable: undefined-global, unused-local
local ruled = require("ruled")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
-- require 'ui.decorations.nice'

-- rounded corners
client.connect_signal("manage", function(c)
	if not c.fullscreen then
		c.shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
		end
	end
end)

client.connect_signal("property::fullscreen", function(c)
	if c.fullscreen then
		c.shape = nil
	else
		c.shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
		end
	end
end)
