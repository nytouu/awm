---@diagnostic disable: undefined-global
local awful = require("awful")
local naughty = require("naughty")

local function set_keybindings()
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
		awful.key({ modkey, "Shift" }, "e", function()
			awesome.emit_signal("toggle::exit")
		end, { description = "quit awesome", group = "awesome" }),
		awful.key({ modkey }, "Return", function()
			awful.spawn(terminal)
		end, { description = "open a terminal", group = "launcher" }),
		awful.key({ modkey, "Shift" }, "d", function()
			awesome.emit_signal("toggle::dashboard")
		end, { description = "toggle the dashboard", group = "launcher " }),
		awful.key({ modkey }, "c", function()
			awesome.emit_signal("toggle::control")
		end, { description = "toggle control", group = "launcher" }),
		awful.key({ modkey }, "d", function()
			awful.spawn(launcher)
		end, { description = "Open rofi", group = "launcher" }),
	})

	-- Tags related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey, "Shift" }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
		awful.key({ modkey, "Shift" }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
		awful.key({ modkey, "Shift" }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
	})

	-- center a floating window
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey }, "Down", function()
			awful.placement.centered(client.focus, {
				honor_workarea = true,
			})
		end, { description = "Center a floating window", group = "client" }),
	})

	-- audio
	awful.keyboard.append_global_keybindings({
		awful.key({}, "XF86AudioRaiseVolume", function()
			awful.spawn("pamixer -i 1")
			awesome.emit_signal("open::osd")
		end, { description = "raise volume", group = "audio" }),
		awful.key({}, "XF86AudioLowerVolume", function()
			awful.spawn("pamixer -d 1")
			awesome.emit_signal("open::osd")
		end, { description = "lower volume", group = "audio" }),
		awful.key({}, "XF86AudioMute", function()
			awful.spawn("pamixer -t")
			awesome.emit_signal("open::osd")
		end, { description = "toggle mute", group = "audio" }),

		-- utilities
		awful.key({ modkey }, "p", function()
			awful.spawn("takescreenshot")
		end, { description = "screenshot", group = "utils" }),
		awful.key({ modkey, "Shift" }, "p", function()
			awful.spawn("takescreenshot slop")
		end, { description = "slop screenshot", group = "utils" }),
		awful.key({ modkey, "Shift" }, "r", function()
			awful.spawn("dmenurecord")
		end, { description = "slop screenshot", group = "utils" }),
		awful.key({ modkey, "Shift" }, "c", function()
			awful.spawn("sh -c '[ ! $(pgrep picom) ] && picom || pkill picom'")
		end, { description = "toggle compositor", group = "utils" }),
		awful.key({}, "XF86MonBrightnessDown", function()
			awful.spawn("brightnessctl s 3-")
			awesome.emit_signal("open::osdb")
		end, { description = "reduce brightness", group = "utils" }),
		awful.key({}, "XF86MonBrightnessUp", function()
			awful.spawn("brightnessctl s +3")
			awesome.emit_signal("open::osdb")
		end, { description = "increase brightness", group = "utils" }),
		awful.key({ modkey, "Shift" }, "h", function()
			awful.spawn("colorpicknotify")
		end, { description = "copy color to clipboard", group = "utils" }),
		awful.key({ modkey, "Shift" }, "o", function()
			awful.spawn("ocrselect")
		end, { description = "OCR selection", group = "utils" }),
		awful.key({ modkey }, "x", function()
			awful.spawn("xkill")
		end, { description = "kill window", group = "utils" }),

		awful.key({ "Mod1" }, "Tab", function()
			awful.spawn("skippy-xd --switch --next")
		end, { description = "alt tab", group = "utils" }),
		awful.key({ "Mod1", "Shift" }, "Tab", function()
			awful.spawn("skippy-xd --switch --prev")
		end, { description = "alt tab reversed", group = "utils" }),


		-- music
		awful.key({}, "XF86AudioPrev", function()
			awful.spawn("playerctl previous")
		end, { description = "previous song", group = "music" }),
		awful.key({}, "XF86AudioNext", function()
			awful.spawn("playerctl next")
		end, { description = "next song", group = "music" }),
		awful.key({}, "XF86AudioPlay", function()
			awful.spawn("playerctl play-pause")
		end, { description = "toggle mute", group = "music" }),
		awful.key({ "Shift" }, "XF86AudioRaiseVolume", function()
			awful.spawn("mpc volume +2")
		end, { description = "raise volume", group = "music" }),
		awful.key({ "Shift" }, "XF86AudioLowerVolume", function()
			awful.spawn("mpc volume -2")
		end, { description = "lower volume", group = "music" }),

		awful.key({ modkey }, "n", function()
			awful.spawn(explorer)
		end, { description = "open file browser", group = "launcher" }),
		awful.key({ modkey }, "b", function()
			awful.spawn(browser)
		end, { description = "open browser", group = "launcher" }),
		awful.key({ modkey, "Shift" }, "m", function()
			awful.spawn(music_client)
		end, { description = "open music", group = "launcher" }),
	})

	-- Focus related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey }, "j", function()
			awful.client.focus.byidx(1)
		end, { description = "focus next by index", group = "client" }),
		awful.key({ modkey }, "k", function()
			awful.client.focus.byidx(-1)
		end, { description = "focus previous by index", group = "client" }),
		awful.key({ modkey }, "Tab", function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end, { description = "go back", group = "client" }),
		awful.key({ modkey }, "v", function()
			awful.screen.focus_relative(1)
		end, { description = "focus the next screen", group = "screen" }),
	})

	-- Layout related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey, "Shift" }, "j", function()
			awful.client.swap.byidx(1)
		end, { description = "swap with next client by index", group = "client" }),
		awful.key({ modkey, "Shift" }, "k", function()
			awful.client.swap.byidx(-1)
		end, { description = "swap with previous client by index", group = "client" }),
		awful.key(
			{ modkey },
			"u",
			awful.client.urgent.jumpto,
			{ description = "jump to urgent client", group = "client" }
		),
		awful.key({ modkey }, "l", function()
			awful.tag.incmwfact(0.05)
		end, { description = "increase master width factor", group = "layout" }),
		awful.key({ modkey }, "h", function()
			awful.tag.incmwfact(-0.05)
		end, { description = "decrease master width factor", group = "layout" }),
		-- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
		--           {description = "increase the number of master clients", group = "layout"}),
		-- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
		--           {description = "decrease the number of master clients", group = "layout"}),
		-- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
		--           {description = "increase the number of columns", group = "layout"}),
		-- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
		--           {description = "decrease the number of columns", group = "layout"}),
		awful.key({ modkey }, "w", function()
			awful.layout.inc(1)
		end, { description = "select next", group = "layout" }),
		awful.key({ modkey, "Shift" }, "w", function()
			awful.layout.inc(-1)
		end, { description = "select previous", group = "layout" }),
	})

	-- @DOC_NUMBER_KEYBINDINGS@

	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = { modkey },
			keygroup = "numrow",
			description = "only view tag",
			group = "tag",
			on_press = function(index)
				local screen = awful.screen.focused()
				local tag = screen.tags[index]
				if tag then
					tag:view_only()
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Control" },
			keygroup = "numrow",
			description = "toggle tag",
			group = "tag",
			on_press = function(index)
				local screen = awful.screen.focused()
				local tag = screen.tags[index]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			keygroup = "numrow",
			description = "move focused client to tag",
			group = "tag",
			on_press = function(index)
				if client.focus then
					local tag = client.focus.screen.tags[index]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Control", "Shift" },
			keygroup = "numrow",
			description = "toggle focused client on tag",
			group = "tag",
			on_press = function(index)
				if client.focus then
					local tag = client.focus.screen.tags[index]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
		}),
		awful.key({
			modifiers = { modkey },
			keygroup = "numpad",
			description = "select layout directly",
			group = "layout",
			on_press = function(index)
				local t = awful.screen.focused().selected_tag
				if t then
					t.layout = t.layouts[index] or t.layout
				end
			end,
		}),
	})

	-- @DOC_CLIENT_KEYBINDINGS@
	client.connect_signal("request::default_keybindings", function()
		awful.keyboard.append_client_keybindings({
			awful.key({ modkey }, "f", function(c)
				c.fullscreen = not c.fullscreen
				c:raise()
			end, { description = "toggle fullscreen", group = "client" }),
			awful.key({ modkey }, "a", function(c)
				c:kill()
			end, { description = "close", group = "client" }),
			awful.key(
				{ modkey },
				"space",
				awful.client.floating.toggle,
				{ description = "toggle floating", group = "client" }
			),
			awful.key({ modkey, "Shift" }, "Return", function(c)
				c:swap(awful.client.getmaster())
			end, { description = "move to master", group = "client" }),
			awful.key({ modkey, "Shift" }, "v", function(c)
				c:move_to_screen()
			end, { description = "move to screen", group = "client" }),
			awful.key({ modkey }, "s", function(c)
				c.sticky = not c.sticky
			end, { description = "toggle sticky", group = "client" }),
			awful.key({ modkey }, "t", function(c)
				c.ontop = not c.ontop
			end, { description = "toggle on top", group = "client" }),
			awful.key({ modkey }, "m", function(c)
				c.maximized = not c.maximized
				c:raise()
			end, { description = "(un)maximize", group = "client" }),
			-- awful.key({ modkey,           }, "i",
			--     function (c)
			--         c.minimized = not c.minimized
			--         c:raise()
			--     end ,
			-- {description = "(un)maximize", group = "client"}),
			-- awful.key({ modkey, "Control" }, "m",
			--     function (c)
			--         c.maximized_vertical = not c.maximized_vertical
			--         c:raise()
			--     end ,
			--     {description = "(un)maximize vertically", group = "client"}),
			-- awful.key({ modkey, "Shift"   }, "m",
			--     function (c)
			--         c.maximized_horizontal = not c.maximized_horizontal
			--         c:raise()
			--     end ,
			--     {description = "(un)maximize horizontally", group = "client"}),
		})
	end)
end

set_keybindings()
