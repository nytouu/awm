local naughty = require "naughty"
local gears = require 'gears'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local helpers = require 'helpers'
local animation = require 'modules.animation'

local dpi = beautiful.xresources.apply_dpi

-- display errors
naughty.connect_signal('request::display_error', function(message, startup)
	naughty.notification {
		urgency = 'critical',
		title = 'An error happened' .. (startup and ' during startup' or ''),
		message = message,
	}
end)

-- display notification
naughty.connect_signal('request::display', function(n)
	local timeout_bar = wibox.widget({
		forced_height = dpi(3),
		max_value = 100,
		min_value = 0,
		value = 100,
		thickness = dpi(3),
		background_color = beautiful.bg_normal,
		color = beautiful.blue,
		widget = wibox.widget.progressbar,
	})

	naughty.layout.box {
		notification = n,
		position = 'bottom_right',
		border_width = beautiful.border_widget,
		border_color = beautiful.grey,
		bg = beautiful.bg_normal .. '00',
		fg = beautiful.fg_normal,
		shape = helpers.mkroundedrect(8),
		minimum_width = dpi(440),
		maximum_width = dpi(640),
		widget_template = {
			{
				{
					{
						{
							{
								{
									{
										image = n.icon or beautiful.fallback_notif_icon,
										forced_height = 28,
										forced_width = 28,
										valign = 'center',
										align = 'center',
										clip_shape = gears.shape.circle,
										widget = wibox.widget.imagebox,
									},
									{
										markup = helpers.complex_capitalizing(n.app_name == '' and 'Notification' or n.app_name),
										align = 'left',
										valign = 'center',
										widget = wibox.widget.textbox,
									},
									spacing = dpi(5),
									layout = wibox.layout.fixed.horizontal,
								},
								margins = dpi(5),
								widget = wibox.container.margin,
							},
							{
								{
									{
										markup = '',
										widget = wibox.widget.textbox,
									},
									top = 1,
									widget = wibox.container.margin,
								},
								bg = beautiful.light_black,
								widget = wibox.container.background,
							},
							layout = wibox.layout.fixed.vertical,
						},
						{
							{
								n.title == '' and nil or {
									markup = '<b>' .. helpers.complex_capitalizing(n.title) .. '</b>',
									align = 'center',
									valign = 'center',
									widget = wibox.widget.textbox,
								},
								{
									markup = n.title == '' and '<b>' .. n.message .. '</b>' or n.message,
									align = 'center',
									valign = 'center',
									widget = wibox.widget.textbox,
								},
								spacing = dpi(3),
								layout = wibox.layout.fixed.vertical,
							},
							top = dpi(15),
							left = dpi(6),
							right = dpi(6),
							bottom = dpi(10),
							widget = wibox.container.margin,
						},
						{
							{
								notification = n,
								base_layout = wibox.widget {
									spacing = dpi(6),
									layout = wibox.layout.flex.horizontal,
								},
								widget_template = {
									{
										{
											{
												id = 'text_role',
												widget = wibox.widget.textbox,
											},
											widget = wibox.container.place,
										},
										top = dpi(4),
										bottom = dpi(4),
										left = dpi(2),
										right = dpi(2),
										widget = wibox.container.margin,
									},
									shape = gears.shape.rounded_bar,
									bg = beautiful.black,
									widget = wibox.container.background,
								},
								widget = naughty.list.actions,
							},
							margins = dpi(6),
							widget = wibox.container.margin,
						},
						layout = wibox.layout.fixed.vertical,
					},
					left   = dpi(10),
					right  = dpi(10),
					top    = dpi(5),
					bottom = dpi(5),
					widget = wibox.container.margin,
				},
				timeout_bar,
				layout = wibox.layout.fixed.vertical,
			},
			bg = beautiful.bg_normal,
			forced_width = dpi(275),
			widget = wibox.container.background,
		}
	}
	local function new_anim()
		return animation:new({
			duration = n.timeout,
			target = 0,
			easing = animation.easing.linear,
			reset_on_stop = false,
			update = function(self, pos)
				timeout_bar.value = 100 - dpi(pos)
			end
		})
	end
	local anim = new_anim()
	if n.timeout > 0 then
		anim:set(100)
	end
end)
