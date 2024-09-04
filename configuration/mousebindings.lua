---@diagnostic disable: undefined-global
local awful = require("awful")
local menu = require("ui.menu")

local function set_mousebindings()
	awful.mouse.append_global_mousebindings({
		awful.button({}, 3, function()
			menu.mainmenu:toggle()
		end),
	})

	client.connect_signal("request::default_mousebindings", function()
		awful.mouse.append_client_mousebindings({
			awful.button({}, 1, function(c)
				c:activate({ context = "mouse_click" })
			end),
			awful.button({ modkey }, 1, function(c)
				c:activate({ context = "mouse_click", action = "mouse_move" })
			end),
			awful.button({ modkey }, 3, function(c)
				c:activate({ context = "mouse_click", action = "mouse_resize" })
			end),
		})
	end)
end

awful.mouse.resize.add_leave_callback(function(c, _, args)
	if (not c.floating) and awful.layout.get(c.screen) ~= awful.layout.suit.floating then
		return
	end

	local coords = mouse.coords()
	local sg = c.screen.geometry
	local snap = awful.mouse.snap.default_distance

	if
		coords.x > snap + sg.x
		and coords.x < sg.x + sg.width - snap
		and coords.y <= snap + sg.y
		and coords.y >= sg.y
	then
		awful.placement.maximize(c, { honor_workarea = true })
	end
end, "mouse.move")

set_mousebindings()
