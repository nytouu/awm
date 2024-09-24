local beautiful = require("beautiful")
local nice = require("modules.nice")

nice({
	titlebar_color = beautiful.bg_normal,

	titlebar_radius = beautiful.border_radius,
	bottom_rounding_radius = beautiful.border_radius,
	win_shade_enabled = false,
	mb_win_shade_rollup = nil,
	mb_win_shade_rolldown = nil,

	close_color = "#ffcccc",
	maximize_color = "#ccffcc",

	context_menu_theme = {
		bg_focus = beautiful.blue,
		bg_normal = beautiful.bg_normal,
		border_color = "#00000000",
		border_width = 0,
		fg_focus = beautiful.fg_normal,
		fg_normal = beautiful.fg_normal,
		font = beautiful.font_name .. " 11",
	},

	titlebar_items = {
		left = {},
		middle = "title",
		right = { "maximize", "close" },
	},
	titlebar_font = beautiful.font_name .. " 12",
	button_size = 14,

	-- Swap the designated buttons for resizing, and opening the context menu
	mb_resize = nice.MB_MIDDLE,
	mb_contextmenu = nice.MB_RIGHT,
})
