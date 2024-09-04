local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

-- listening awesomewm events
require("ui.systray.listener")

awful.screen.connect_for_each_screen(function()
	screen.primary.systray = {}

	local capi = {
		awesome = awesome,
		screen = screen.primary,
	}
	local num_entries = capi.awesome.systray()

	local dimensions = {
		width = 100,
		height = 38,
	}

	screen.primary.systray.popup = wibox({
		visible = false,
		ontop = true,
		type = "popup_menu",
		width = dimensions.width,
		height = dimensions.height,
		bg = beautiful.bg_normal .. "00",
		fg = beautiful.fg_normal,
		x = screen.primary.geometry.x + 1406,
		y = -2,
	})

	local self = screen.primary.systray.popup

	self:setup({
		{
			{
				{
					widget = wibox.widget.systray,
					horizontal = false,
					screen = screen.primary,
					base_size = 24,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			margins = 12,
			widget = wibox.container.margin,
		},
		bg = beautiful.bg_normal,
		fg = beautiful.fg_normal,
		widget = wibox.container.background,
	})

	function screen.primary.systray.toggle()
		if self.visible then
			screen.primary.systray.hide()
		else
			screen.primary.systray.show()
		end
	end

	function screen.primary.systray.show()
		self.visible = true
	end

	function screen.primary.systray.hide()
		self.visible = false
	end
end)
