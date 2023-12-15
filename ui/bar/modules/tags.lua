---@diagnostic disable: undefined-global
local awful = require 'awful'
local wibox = require 'wibox'
local gears = require 'gears'
local beautiful = require 'beautiful'
local helpers = require 'helpers'
local rubato = require 'modules.rubato'

local function gettaglist(s)
    return awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		style = {
			shape = gears.shape.rounded_bar,
		},
		layout = {
			spacing = 12,
			layout = wibox.layout.fixed.horizontal,
		},
		buttons = {
			awful.button({}, 1, function (t)
				t:view_only()
			end),
			awful.button({}, 3, function (t)
				awful.tag.viewtoggle(t)
			end),
		},
		widget_template = {
			{
				markup = '',
				widget = wibox.widget.textbox,
			},
			id = 'background_role',
			forced_width = 38,
			forced_height = 8,
			widget = wibox.container.background,
			create_callback = function (self, tag)
				self.animate = rubato.timed {
					duration = 0.25,
					subscribed = function (h)
						self:get_children_by_id('background_role')[1].forced_width = h
					end
				}

				self.update = function ()
				if tag.selected then
						self.animate.target = 22
					elseif #tag:clients() > 0 then
						self.animate.target = 18
					else
						self.animate.target = 12
					end
				end

				self.update()
			end,
			update_callback = function (self)
				self.update()
			end,
		}
	}
end

return gettaglist
