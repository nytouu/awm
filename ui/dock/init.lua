---@diagnostic disable: undefined-global
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local rubato    = require("modules.rubato")

local dpi       = beautiful.xresources.apply_dpi
local geticon   = require("ui.dock.geticon")

local placeDock = function(c, m)
	awful.placement.bottom(c, { margins = dpi(m) })
end

local layout     = wibox.layout.fixed.horizontal
local rlayout    = wibox.layout.fixed.vertical
local flexlayout = wibox.layout.flex.horizontal

local dock = function(s)
	-- this is the main dock
	local dock  = awful.popup {
		widget    = wibox.container.background,
		ontop     = true,
		bg        = beautiful.bg_normal,
		visible   = true,
		screen    = s,
		height    = 100,
		width     = 600,
		placement = function(c) placeDock(c, 10) end,
		shape     = helpers.mkroundedrect(10)
	}

	-- autohiding the dock
	local function check_for_dock_hide()
		if not awful.screen.focused().selected_tag then
			-- if not dock.visible then -- No tag selected, so make the dock visible
				-- local timed = rubato.timed {
				-- 	duration = 1 / 4,
				-- 	intro = 1 / 9,
				-- 	override_dt = true,
				-- 	subscribed = function(pos)
				-- 		dock.y = dpi(1135 - pos)
				-- 	end
				-- }
				-- timed.target = 120
				dock.visible = true
			-- end
			return
		end

		for _, client in ipairs(awful.screen.focused().selected_tag:clients()) do
			if client.fullscreen then
				-- if dock.visible then -- Disable dock on fullscreen
					-- local timed = rubato.timed {
					-- 	duration = 1 / 4,
					-- 	intro = 1 / 9,
					-- 	override_dt = true,
					-- 	subscribed = function(pos)
					-- 		dock.y = dpi(1225 + pos)
					-- 	end
					-- }
					-- timed.target = 120
					dock.visible = false
				-- end
				return
			end
		end

		-- Make dock visible if nothing is open
		if #awful.screen.focused().selected_tag:clients() < 1 then
			dock.visible = true
			return
		end

		if awful.screen.focused() == mouse.screen then
			local minimized

			for _, c in ipairs(awful.screen.focused().selected_tag:clients()) do
				if c.minimized then
					minimized = true
				end

				if c.fullscreen then
					dock.visible = false
					return
				end

				if not c.minimized then
					-- If the client enters the dock area, hide it
					local y = c:geometry().y
					local h = c.height

					if (y + h) >= awful.screen.focused().geometry.height - 65 then
						dock.visible = false
						return
					else
						dock.visible = true
					end
				end
			end

			if minimized then
				dock.visible = true
			end
		else
			dock.visible = false
            -- local timed = rubato.timed {
            --     duration = 1 / 4,
            --     override_dt = true,
            --     subscribed = function(pos)
            --         dock.y = dpi((1145 - 120) + pos)
            --     end
            -- }
            -- timed.target = 120
		end
	end

	-- a timer to check for dock hide
	local dockHide = gears.timer {
		timeout = 1,
		autostart = true,
		call_now = true,
		callback = function()
			check_for_dock_hide()
		end
	}

	dockHide:again()

	-- a hotarea at the bottom which will toggle the dock upon hover
	local hotpop = wibox({
		type    = "desktop",
		height  = 1,
		width   = 200,
		screen  = s,
		ontop   = true,
		visible = true,
		bg      = beautiful.border_focus .. 'ff'
	})

	placeDock(hotpop, 0)
	hotpop:setup {
		widget  = wibox.container.margin,
		margins = 10,
		layout  = layout
	}

	-- Window state indicators
	local createDockIndicators = function(data)
		local clients = data.clients
		local indicators = wibox.widget { layout = flexlayout, spacing = 4 }

		for _, v in ipairs(clients) do
			local bac
			local click

			if v == client.focus then
				bac = beautiful.blue
				click = function()
					v.minimized = true
				end

			elseif v.urgent then
				bac = beautiful.red

			elseif v.minimized then
				bac = beautiful.dimblack
				click = function()
					v.minimized = false
					v = client.focus
				end

			elseif v.maximized then
				bac = beautiful.green
				click = function()
					v.maximized = false
					v = client.focus
				end

			elseif v.fullscreen then
				bac = beautiful.yellow
				click = function()
					v.fullscreen = false
					v = client.focus
				end

			else
				bac = beautiful.dimblack
				click = function()
					v.minimized = true
				end

			end

			local widget = wibox.widget {
				bg            = bac,
				forced_height = dpi(5),
				forced_width  = dpi(10),
				shape         = helpers.mkroundedrect(50),
				widget        = wibox.container.background,
				buttons = {
					awful.button({}, 1, function()
						click()
					end)
				},
			}

			indicators:add(widget)
		end

		return wibox.widget {
			{
				{
					indicators,
					spacing   = 8,
					layout    = layout
				},
				widget      = wibox.container.place,
				halign      = 'center'
			},
			forced_height = 4,
			forced_width  = 45,
			widget        = wibox.container.background
		}

	end

	-- creating 1 icon on the dock
	local createDockElement = function(data)

		local class     = string.lower(data.class)
		local command   = string.lower(data.class)

		-- 
		local customIcons = {
			{
				name        = "nvim",
				convert     = "nvim",
				command     = terminal .. " nvim"
			},
			{
				name        = "tabbed",
				convert     = "kitty",
				class 		= "tabbed",
				command     = "tabbed -c -k -n st -b -r 2 st -w ''",
			},
			{
				name        = "steam",
				convert     = "steam",
				command     = "steam-native"
			},
			{
				name        = "neorg",
				convert     = "notes",
				command     = terminal .. " -d ~/notes -c neorg nvim +'Neorg workspace notes' ~/notes/index.norg"
			},
			{
				name        = "ncmpcpp",
				convert     = "musique",
				command     = terminal .. " -c ncmpcpp -T ncmpcpp ncmpcpp"
			},
			{
				name        = "thunar",
				convert     = "folder_doc_q4os_startmenu",
				command     = "thunar"
			},
		}

		for _, v in pairs(customIcons) do
			if class == v.name then
				class   = v.convert
				command = v.command
			end
		end

		local dockelement = wibox.widget {
			{
				{
					{
						forced_height = 34,
						forced_width  = 34,
						buttons = {
							awful.button({}, 1, function()
								awful.spawn.with_shell(command)
							end)
						},
						image      = geticon(nil, class, class, false),
						clip_shape = helpers.mkroundedrect(8),
						widget     = wibox.widget.imagebox,
					},
					layout = layout
				},
				createDockIndicators(data),
				layout = rlayout
			},
			forced_width = 34,
			widget = wibox.container.background
		}

		helpers.hover_cursor(dockelement)
		return dockelement
	end

	-- the main function
	local createDockElements = function()
		if not mouse.screen then
			return wibox.widget { layout = layout } -- No screen selected, return an empty widget
		end

		local clients = mouse.screen.selected_tag and mouse.screen.selected_tag:clients() or {}

		-- making some pinned apps
		local metadata = {
			{
				count   = 0,
				id      = 1,
				clients = {},
				name    = "tabbed",
				class   = "tabbed"
			},
			{
				count   = 0,
				id      = 2,
				clients = {},
				name    = "thunar",
				class   = "thunar"
			},
			{
				count   = 0,
				id      = 3,
				clients = {},
				name    = "firefox",
				class   = "firefox"
			},
			{
				count   = 0,
				id      = 4,
				clients = {},
				name    = "nvim",
				class   = "nvim"
			},
			{
				count   = 0,
				id      = 5,
				clients = {},
				name    = "discord",
				class   = "discord"
			},
			{
				count   = 0,
				id      = 6,
				clients = {},
				name    = "steam",
				class   = "steam"
			},
			{
				count   = 0,
				id      = 7,
				clients = {},
				name    = "ncmpcpp",
				class   = "ncmpcpp"
			},
			{
				count   = 0,
				id      = 8,
				clients = {},
				name    = "neorg",
				class   = "neorg"
			},
			{
				count   = 0,
				id      = 9,
				clients = {},
				name    = "libreoffice",
				class   = "libreoffice"
			},
			{
				count   = 0,
				id      = 10,
				clients = {},
				name    = "libresprite",
				class   = "libresprite"
			},
			{
				count   = 0,
				id      = 11,
				clients = {},
				name    = "unityhub",
				class   = "unityhub"
			},
		}

		local classes = { "tabbed", "st", "firefox", "discord", "thunar", "neorg", "ncmpcpp", "steam", "unityhub" }
		local dockElements = wibox.widget { layout = layout, spacing = 8 }

		-- generating the data
		for _, c in ipairs(clients) do
            local class = ""
            if c.class then
                class = string.lower(c.class)
            end

			if helpers.inTable(classes, class) then
				for _, j in pairs(metadata) do
					if j.name == class then
						table.insert(j.clients, c)
						j.count = j.count + 1
					end
				end

			else
				table.insert(classes, class)
				local toInsert = {
					count   = 1,
					id      = #classes + 1,
					clients = { c },
					class   = class,
					name    = class,
				}
				table.insert(metadata, toInsert)
			end
		end

		table.sort(metadata, function(a, b) return a.id < b.id end)
		for _, j in pairs(metadata) do
			dockElements:add(createDockElement(j))
		end

		return dockElements

	end

	local refresh = function()
		check_for_dock_hide()
		dock:setup {
			{
				createDockElements(),
				layout  = layout
			},
			widget    = wibox.container.margin,
			margins   = {
				top     = 10,
				bottom  = 7,
				left    = 10,
				right   = 10,
			},
		}
	end

	refresh()

	client.connect_signal("focus", function() refresh() end)
	client.connect_signal("property::minimized", function() refresh() end)
	client.connect_signal("property::maximized", function() refresh() end)
	client.connect_signal("manage", function() refresh() end)
	client.connect_signal("unmanage", function() refresh() end)

	hotpop:connect_signal("mouse::enter", function()
		dockHide:stop()
		dock.visible = true
	end)

	hotpop:connect_signal("mouse::leave", function() dockHide:again() end)

	dock:connect_signal("mouse::enter", function()
		dockHide:stop()
		dock.visible = true
	end)

	dock:connect_signal("mouse::leave", function() dockHide:again() end)
	tag.connect_signal("property::selected", function() refresh() end)

end

screen.connect_signal('request::desktop_decoration', function(s)
	dock(s)
end)
