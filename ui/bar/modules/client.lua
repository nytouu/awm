local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local client_title = wibox.widget({
	font = beautiful.font_name .. " 10",
	widget = wibox.widget.textbox,
})
local client_icon = wibox.widget({
	client = client,
	forced_height = dpi(18),
	forced_width = dpi(18),
	widget = awful.widget.clienticon,
})

local client_info = wibox.widget({
	{
		client_icon,
		client_title,
		spacing = dpi(8),
		layout = wibox.layout.fixed.horizontal,
	},
	widget = wibox.container.place,
})

client.connect_signal("focus", function(c)
	client_icon.client = c

	local name, _ = c.name:match("(.*) [-—] (.*)")
	client_title:set_markup_silently(name or c.name)
end)

client.connect_signal("unfocus", function(c)
	client_icon.client = ""
	client_title:set_markup_silently("")
end)

client.connect_signal("property::name", function(c)
	local name, _ = c.name:match("(.*) [-—] (.*)")
	client_title:set_markup_silently(name or c.name)
end)

return {
	client_info,
	margins = dpi(4),
	widget = wibox.container.margin,
}
