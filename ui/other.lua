local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local bling = require("modules.bling")
local wibox = require("wibox")
local helpers = require("helpers")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- tag preview
bling.widget.tag_preview.enable({
	show_client_content = true,
	placement_fn = function(c)
		awful.placement.top_left(c, {
			margins = {
				top = beautiful.bar_height + beautiful.useless_gap,
				left = 116,
			},
		})
	end,
	scale = 0.15,
	honor_padding = true,
	honor_workarea = true,
	background_widget = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.wallpaper,
	}),
})

bling.module.flash_focus.enable()

require("modules.better-resize")
