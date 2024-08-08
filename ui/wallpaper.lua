---@diagnostic disable: undefined-global
local beautiful = require 'beautiful'
local gears = require 'gears'
local awful = require 'awful'
local wibox = require 'wibox'

screen.connect_signal('request::wallpaper', function (s)
	if beautiful.wallpaper then
		awful.wallpaper {
			screen         = s,
			honor_workarea = true,
			bg             = beautiful.bg_normal,
			ontop = true,
			widget         = {
				{
					image                 = beautiful.wallpaper,
					valign                = "center",
					halign                = "center",
					horizontal_fit_policy = "cover",
					vertical_fit_policy   = "cover",
					widget                = wibox.widget.imagebox,
				},
				widget = wibox.container.background,
				-- GNOME style notches around the bar, this handles the corners to round depending on bar position
				bg     = beautiful.bg_normal,
				shape  = function(c, w, h)
					gears.shape.partially_rounded_rect(c, w, h, true, true, true, true, beautiful.border_radius)
				end,
				-- shape = gears.shape.rectangle
			}
		}
	end
end)
