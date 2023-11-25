-- ---@diagnostic disable: undefined-global
-- local wibox = require("wibox")
-- local helpers = require("helpers")
-- local beautiful = require("beautiful")
-- -- local awful = require("awful")
-- local gears = require("gears")
--
-- local battery = wibox.widget {
--     {
--         max_value        = 100,
--         value            = 69,
--         id               = "prog",
--         forced_height    = 20,
--         forced_width     = 35,
--         paddings         = 3,
--         border_color     = beautiful.fg_normal .. "99",
--         background_color = beautiful.bg_normal,
--         bar_shape        = helpers.mkroundedrect(3),
--         -- bar_shape        = gears.shape.rectangle,
--         color            = beautiful.blue,
--         border_width     = 1.25,
--         shape            = helpers.mkroundedrect(5),
--         widget           = wibox.widget.progressbar
--     },
--     {
--         {
--             bg = beautiful.fg_normal .. "99",
--             forced_height = 10,
--             forced_width = 2,
--             shape = helpers.mkroundedrect(10),
--             widget = wibox.container.background,
--         },
--         widget = wibox.container.place,
--         valign = "center",
--     },
--     spacing = 3,
--     layout = wibox.layout.fixed.horizontal
-- }
--
-- awesome.connect_signal("signal::battery", function(value, status)
--     local b = battery:get_children_by_id("prog")[1]
--     b.value = value
-- 	b.status = status
--     if value > 80 then
--         b.color = beautiful.green
--     elseif value > 20 then
--         b.color = beautiful.blue
--     else
--         b.color = beautiful.red
--     end
--
-- 	if b.status == "Charging" then
-- 		b.color = beautiful.yellow
-- 	end
-- end)
--
-- return battery


---@diagnostic disable: undefined-global
local gears     = require('gears')
local wibox     = require("wibox")
local beautiful = require("beautiful")
local helpers   = require("helpers")
local dpi       = beautiful.xresources.apply_dpi

-- Stolen from chadcat7
-- https://github.com/chadcat7/crystal/tree/the-awesome-config

-- le batterie
local battery   = wibox.widget {
	id            = "battery",
	widget        = wibox.widget.progressbar,
	max_value     = 100,
	forced_width  = 29,
	forced_height = 14,
	shape         = helpers.mkroundedrect(4),
}

-- le batterie widgetté
local batstatus = wibox.widget {
	{
		{
			{
				{
					battery,
					{
						{
							id = "text",
							font   = beautiful.font_name .. "16",
							markup = helpers.colorize_text("󱐋", beautiful.bg_normal),
							widget = wibox.widget.textbox,
							border_width     = 1.25,
							valign = "center",
							align  = "center"
						},
						direction = "east",
						widget    = wibox.container.rotate
					},
					layout = wibox.layout.stack
				},
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(15)
			},
			margins = dpi(4),
			widget = wibox.container.margin
		},
		{
			{
				forced_width = 35,
				forced_height = 20,
				border_width = 1.25,
				fg = beautiful.grey,
				shape = helpers.mkroundedrect(5),
				widget = wibox.container.background,
			},
			widget = wibox.container.place,
			valign = "center",
		},
		layout = wibox.layout.stack
	},
	visible = true,
	bg      = beautiful.bg_dark,
	widget  = wibox.container.background,
	shape   = helpers.mkroundedrect(2),
}

local vbar_batstatus = wibox.widget {
	batstatus,
	direction = "north",
	widget    = wibox.container.rotate
}

awesome.connect_signal("signal::battery", function(value, state)
	local b = battery
	b.state = state
	b.value = value
	if state then
		b.color = beautiful.green
		b.background_color = beautiful.green .. '80'
	elseif value < 20 then
		b.color = beautiful.red
		b.background_color = beautiful.red .. '80'
	elseif value < 40 then
		b.color = beautiful.orange
		b.background_color = beautiful.orange .. '80'
	elseif value < 60 then
		b.color = beautiful.yellow
		b.background_color = beautiful.yellow .. '80'
	else
		b.color = beautiful.green
		b.background_color = beautiful.green .. '80'
	end
end)

return vbar_batstatus
