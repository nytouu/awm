---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local awful = require 'awful'
local gears = require 'gears'
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local tasklist = awful.widget.tasklist {
	screen = s,
	filter = awful.widget.tasklist.filter.allscreen,
	-- sort clients by tags
	source = function()
		local ret = {}

		for _, t in ipairs(s.tags) do
			gears.table.merge(ret, t:clients())
		end

		return ret
	end,
	buttons = {
		awful.button({}, 1, function (c)
			if not c.active then
				c:activate {
					context = 'through_dock',
					switch_to_tag = true,
				}
			else
				c.minimized = true
			end
		end),
		awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
		awful.button({}, 5, function() awful.client.focus.byidx( 1) end),
	},
	style = {
		shape = gears.shape.circle,
	},
	layout = {
		spacing = dpi(5),
		layout = wibox.layout.fixed.horizontal
	},
	widget_template = {
		{
			{
				{
					id = "icon_role",
					widget = wibox.widget.imagebox,
				},
				margins = 2,
				widget = wibox.container.margin,
			},
			margins = dpi(4),
			widget = wibox.container.margin
		},
		id = "background_role",
		widget = wibox.container.background,
		create_callback = function (self, c, _, _)
			self:connect_signal('mouse::enter', function ()
				awesome.emit_signal('bling::task_preview::visibility', s, true, c)
			end)
			self:connect_signal('mouse::leave', function ()
				awesome.emit_signal('bling::task_preview::visibility', s, false, c)
			end)
		end
	},
}

return tasklist
