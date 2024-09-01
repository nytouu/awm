local awful = require 'awful'
local helpers = require 'helpers'
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'

require 'ui.calendar.listener'

awful.screen.connect_for_each_screen(function()
	screen.primary.calendar = {}

	local dimensions = {
		width = 300,
		height = 265
	}

	screen.primary.calendar.popup = wibox {
		visible = false,
		ontop = true,
		width = dimensions.width,
		height = dimensions.height,
		x = 1920 / 2 - dimensions.width / 2,
		y = beautiful.bar_height + beautiful.useless_gap * 2,
		bg = beautiful.bg_normal .. '00',
		fg = beautiful.fg_normal,
		shape = helpers.mkroundedrect(8),
		border_width = beautiful.border_widget,
		border_color = beautiful.grey,
		screen = screen.primary,
		type = "utility"
	}

	local self = screen.primary.calendar.popup

	self:setup {
		{
			{
				{
					date = os.date('*t'),
					font = beautiful.font_name .. ' 10',
					spacing = 2,
					widget = wibox.widget.calendar.month,
					fn_embed = function(widget, flag, date)
						local focus_widget = wibox.widget {
							text = date.day,
							align = 'center',
							widget = wibox.widget.textbox,
						}

						local torender = flag == 'focus' and focus_widget or widget

						local colors = {
							header = beautiful.blue,
							focus = beautiful.blue,
							weekday = beautiful.blue
						}

						local color = colors[flag] or beautiful.fg_normal

						return wibox.widget {
							{
								torender,
								margins = 7,
								widget = wibox.container.margin,
							},
							bg = flag == 'focus' and beautiful.black or beautiful.bg_normal,
							fg = color,
							widget = wibox.container.background,
							shape = flag == 'focus' and gears.shape.circle or nil,
						}
					end
				},
				spacing = beautiful.useless_gap * 2,
				layout = wibox.layout.fixed.vertical,
			},
			margins = beautiful.useless_gap * 2,
			widget = wibox.container.margin,
		},
		bg = beautiful.bg_normal,
		fg = beautiful.fg_normal,
		widget = wibox.container.background,
	}

	function screen.primary.calendar.open()
		self.visible = true
	end

	function screen.primary.calendar.hide()
		self.visible = false
	end

	function screen.primary.calendar.toggle()
		if self.visible then
			screen.primary.calendar.hide()
		else
			screen.primary.calendar.open()
		end
	end
end)
