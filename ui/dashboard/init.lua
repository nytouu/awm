local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")

local calendar = require("ui.dashboard.mods.calendar")
-- local weather = require("ui.dashboard.mods.weather")
local notif_center = require("ui.dashboard.notif-center")

require("ui.dashboard.listener")

awful.screen.connect_for_each_screen(function()
	screen.primary.dashboard = {}

	local dimensions = {
		width = 700,
		height = 310,
	}

	screen.primary.dashboard.popup = wibox({
		visible = false,
		ontop = true,
		width = dimensions.width,
		height = dimensions.height,
		x = 1920 / 2 - dimensions.width / 2,
		y = beautiful.bar_height + beautiful.useless_gap,
		bg = beautiful.bg_normal .. "00",
		fg = beautiful.fg_normal,
		shape = helpers.mkroundedrect(beautiful.border_radius),
		border_width = beautiful.border_widget,
		border_color = beautiful.grey,
		screen = screen.primary,
		type = "utility",
	})

	local self = screen.primary.dashboard.popup

	self:setup({
		{
			calendar,
			bg = beautiful.bg_normal,
			widget = wibox.container.background,
		},
        {
            {
                {
                    notif_center(screen.primary),
                    bg = beautiful.bg_normal,
                    widget = wibox.container.background,
                },
                widget = wibox.container.margin,
                top = beautiful.useless_gap,
                right = beautiful.useless_gap,
                bottom = beautiful.useless_gap,
            },
            bg = beautiful.bg_normal,
            widget = wibox.container.background,
        },
		layout = wibox.layout.align.horizontal,
	})

	function screen.primary.dashboard.open()
		self.visible = true
	end

	function screen.primary.dashboard.hide()
		self.visible = false
	end

	function screen.primary.dashboard.toggle()
		if self.visible then
			screen.primary.dashboard.hide()
		else
			screen.primary.dashboard.open()
		end
	end
end)
