---@diagnostic disable: undefined-global
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- Stolen from chadcat7
-- https://github.com/chadcat7/crystal/tree/the-awesome-config

-- le batterie
local battery = wibox.widget({
	id = "battery",
	widget = wibox.widget.progressbar,
	max_value = 100,
	forced_width = 29,
	forced_height = 14,
	shape = helpers.mkroundedrect(4),
})

local text = wibox.widget({
	id = "text",
	font = beautiful.font_name .. "16",
	markup = helpers.colorize_text("󱐋", beautiful.bg_normal),
	widget = wibox.widget.textbox,
	border_width = 1.25,
	valign = "center",
	align = "center",
})

-- le batterie widgetté
local batstatus = wibox.widget({
	{
		{
			{
				{
					battery,
					{
						text,
						direction = "east",
						widget = wibox.container.rotate,
					},
					layout = wibox.layout.stack,
				},
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(15),
			},
			margins = dpi(4),
			widget = wibox.container.margin,
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
		layout = wibox.layout.stack,
	},
	visible = true,
	bg = beautiful.bg_dark,
	widget = wibox.container.background,
	shape = helpers.mkroundedrect(2),
})

local vbar_batstatus = wibox.widget({
	batstatus,
	direction = "north",
	widget = wibox.container.rotate,
})

local battery_tooltip = helpers.make_popup_tooltip("-1%", function(d)
	return awful.placement.top_right(d, {
		honor_workarea = true,
		margins = {
			right = beautiful.useless_gap,
			top = beautiful.useless_gap * 2,
		},
	})
end)

battery_tooltip.attach_to_object(battery)

local function update_content(t)
	battery_tooltip.widget.text = t
end

awesome.connect_signal("signal::battery", function(value, state)
	local b = battery
	b.state = state
	b.value = value

	local state_text
	if state then
		state_text = "Charging"
	else
		state_text = "Discharging"
	end

	update_content(state_text .. ": " .. value .. "%")
	if state then
		text.markup = helpers.colorize_text("󱐋", beautiful.bg_normal)
		b.color = beautiful.green
		b.background_color = beautiful.green .. "80"
	elseif value < 20 then
		text.markup = helpers.colorize_text(" ", beautiful.bg_normal)
		b.color = beautiful.red
		b.background_color = beautiful.red .. "80"
	elseif value < 40 then
		text.markup = helpers.colorize_text(" ", beautiful.bg_normal)
		b.color = beautiful.orange
		b.background_color = beautiful.orange .. "80"
	elseif value < 60 then
		text.markup = helpers.colorize_text(" ", beautiful.bg_normal)
		b.color = beautiful.yellow
		b.background_color = beautiful.yellow .. "80"
	else
		text.markup = helpers.colorize_text(" ", beautiful.bg_normal)
		b.color = beautiful.green
		b.background_color = beautiful.green .. "80"
	end
end)

return vbar_batstatus
