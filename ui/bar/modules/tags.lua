---@diagnostic disable: undefined-global
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local rubato = require("modules.rubato")

local function gettaglist(s)
	return awful.widget.taglist({
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
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({}, 3, function(t)
				awful.tag.viewtoggle(t)
			end),
		},
		widget_template = {
			{
				markup = "",
				widget = wibox.widget.textbox,
			},
			id = "background_role",
			forced_width = 48,
			forced_height = 12,
			widget = wibox.container.background,
			create_callback = function(self, tag)
				self.animate_width = rubato.timed({
					duration = 0.25,
					subscribed = function(h)
						self:get_children_by_id("background_role")[1].forced_width = h
					end,
				})
				self.update = function()
					if tag.selected then
						self.animate_width.target = 28
					elseif #tag:clients() > 0 then
						self.animate_width.target = 16
					else
						self.animate_width.target = 12
					end
				end

				self.update()

				self:connect_signal("mouse::enter", function()
					if #tag:clients() > 0 then
						awesome.emit_signal("bling::tag_preview::update", tag)
						awesome.emit_signal("bling::tag_preview::visibility", s, true)
						awesome.emit_signal("bling::task_preview::visibility", s, true, tag)
					end
				end)
				self:connect_signal("mouse::leave", function()
					awesome.emit_signal("bling::tag_preview::visibility", s, false)
					awesome.emit_signal("bling::task_preview::visibility", s, false, tag)
				end)
			end,

			update_callback = function(self)
				self.update()
			end,
		},
	})
end

return gettaglist
