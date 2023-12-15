---@diagnostic disable: undefined-global
--[[
--  background on icon hover ?
--  macos-like behavior ?
--  multi selecting ?
--  multi screen ?
--]]

local awful = require("awful")
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local json = require("modules.json")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
-- local appicons = "/usr/share/icons/Papirus/64x64/"
-- local foldericons = "/usr/share/icons/" .. beautiful.icons .. "/64x64/places/"
local appicons =
"/nix/store/ggkfpmvs41rpjdg5byr7p0wbrjqhd33g-papirus-icon-theme-20230301/share/icons/Papirus-Dark/48x48/"


local foldericons =
"/nix/store/ggkfpmvs41rpjdg5byr7p0wbrjqhd33g-papirus-icon-theme-20230301/share/icons/Papirus-Dark/48x48/places/"

function hovercursor(widget)
	local oldcursor, oldwibox
	widget:connect_signal("mouse::enter", function()
		local wb = mouse.current_wibox
		if wb == nil then return end
		oldcursor, oldwibox = wb.cursor, wb
		wb.cursor = "hand2"
	end)
	widget:connect_signal("mouse::leave", function()
		if oldwibox then
			oldwibox.cursor = oldcursor
			oldwibox = nil
		end
	end)
	return widget
end

local grid = wibox.widget {
	forced_num_rows = 8,
	forced_num_cols = 16,
	orientation = "horizontal",
	layout = wibox.layout.grid
}

local manual = wibox.layout {
	layout = wibox.layout.manual
}

local desktopdisplay = wibox {
	visible = true,
	ontop = false,
	bgimage = beautiful.wallpaper,
	type = "desktop",
	screen = s,
	widget = wibox.widget {
		{
			grid,
			margins = dpi(30),
			widget = wibox.container.margin
		},
		manual,
		layout = wibox.layout.stack
	}
}

awful.placement.maximize(desktopdisplay)

local function gen()
	local shortcuts = {}
	local folders = {}
	local files = {}
	local entries = {}

	for entry in io.popen([[ls ~/docs/desktop | sed '']]):lines() do
		local label = entry
		local exec = nil
		local icon = appicons .. "mimetypes/text-x-generic.svg"
		local ext = label:match("^.+(%..+)$")

		if ext == ".desktop" then
			for line in io.popen("cat ~/docs/desktop/'" .. entry .. "'"):lines() do
				if line:match("Name=") and label == entry then
					label = line:gsub("Name=", "")
				end
				if line:match("Exec=") and exec == nil then
					local cmd = line:gsub("Exec=", "")
					exec = cmd
				end
				if line:match("CustomIcon=") then
					icon = line:gsub("CustomIcon=", "")
				elseif line:match("Icon=") then
					icon = appicons .. "apps/" .. line:gsub("Icon=", "") .. ".svg"
				end
			end
			table.insert(entries, { icon = icon, label = label, exec = exec })
		elseif os.execute("cd ~/docs/desktop/'" .. entry .. "'") then
			icon = foldericons .. "folder.svg"
			exec = "thunar ~/docs/desktop/'" .. entry .. "'"
			table.insert(entries, { icon = icon, label = label, exec = exec })
		elseif os.execute("wc -c < ~/docs/desktop/'" .. entry .. "'") then
			icon = appicons .. "mimetypes/application-x-zerosize.svg"
			exec = user.editorcmd .. " ~/docs/desktop/'" .. entry .. "'"
			table.insert(entries, { icon = icon, label = label, exec = exec })
		else
			exec = "xdg-open " .. os.getenv("HOME") .. "/docs/desktop/'" .. label .. "'"
			table.insert(entries, { icon = icon, label = label, exec = exec })
		end
	end

	return entries
end

local function save()
	layout = {}

	for i, widget in ipairs(grid.children) do
		local pos = grid:get_widget_position(widget)

		layout[i] = {
			row = pos.row,
			col = pos.col,
			widget = {
				icon = widget.icon,
				label = widget.label,
				exec = widget.exec
			}
		}
	end

	local w = assert(io.open(".cache/awesome/json/desktop.json", "w"))
	w:write(json:encode_pretty(layout, nil, { pretty = true, indent = "	", align_keys = false, array_newline = true }))
	w:close()
end

local function gridindexat(y, x)
	local margin = dpi(30)
	local cellwidth, cellheight = dpi(115), dpi(125)

	local row = math.ceil((y - margin) / cellheight)
	row = math.min(row, 8)
	row = math.max(row, 1)

	local col = math.ceil((x - margin) / cellwidth)
	col = math.min(col, 16)
	col = math.max(col, 1)

	return row, col
end

local function createicon(icon, label, exec)
	local widget = hovercursor(wibox.widget {
		{
			{
				{
					image = icon,
					halign = "center",
					widget = wibox.widget.imagebox
				},
				strategy = "exact",
				width = dpi(50),
				height = dpi(50),
				widget = wibox.container.constraint
			},
			{
				{
					{
						text = label,
						valign = "top",
						align = "center",
						widget = wibox.widget.textbox
					},
					margins = dpi(5),
					widget = wibox.container.margin
				},
				strategy = "max",
				width = dpi(100),
				height = dpi(50),
				widget = wibox.container.constraint
			},
			spacing = dpi(5),
			layout = wibox.layout.fixed.vertical
		},
		icon = icon,
		label = label,
		exec = exec,
		forced_width = dpi(115),
		forced_height = dpi(125),
		margins = dpi(10),
		widget = wibox.container.margin
	})

	local iconmenu = awful.menu({
		items = {
			{ "Open", exec },
			{ "Delete", function()
				awful.spawn.with_shell("rm -rf " .. os.getenv("HOME") .. "/docs/desktop/'" .. label .. "'")
			end },
		}
	})

	awesome.connect_signal("iconmenu::hide", function()
		iconmenu:hide()
	end)

	widget:connect_signal("button::press", function(_, _, _, button)
		if not mousegrabber.isrunning() then

			local heldwidget = wibox.widget {
				{
					{
						image = icon,
						opacity = 0.5,
						halign = "center",
						widget = wibox.widget.imagebox
					},
					strategy = "exact",
					width = dpi(50),
					height = dpi(50),
					widget = wibox.container.constraint
				},
				{
					{
						{
							text = label,
							opacity = 0.5,
							valign = "top",
							align = "center",
							widget = wibox.widget.textbox
						},
						margins = dpi(5),
						widget = wibox.container.margin
					},
					strategy = "max",
					width = dpi(100),
					height = dpi(50),
					widget = wibox.container.constraint
				},
				forced_height = dpi(105),
				forced_width = dpi(100),
				spacing = dpi(5),
				visible = false,
				layout = wibox.layout.fixed.vertical
			}

			local startpos = mouse.coords()
			heldwidget.point = { x = startpos.x, y = startpos.y }
			local oldpos = grid:get_widget_position(widget)
			manual:add(heldwidget)

			mousegrabber.run(function(mouse)
				if (math.abs(mouse.x - startpos.x) > 10 or
					math.abs(mouse.y - startpos.y) > 10) and
					mouse.buttons[1] then

					grid:remove(widget)
					heldwidget.visible = true

					manual:move_widget(heldwidget, {
						x = mouse.x - dpi(50),
						y = mouse.y - dpi(50)
					})
				end

				if not mouse.buttons[1] then
					if button == 1 then
						if heldwidget.visible then
							heldwidget.visible = false

							local newrow, newcol = gridindexat(
								mouse.y,
								mouse.x
							)
							if not grid:get_widgets_at(newrow, newcol) then
								grid:add_widget_at(widget, newrow, newcol)
								save()
							else
								grid:add_widget_at(widget, oldpos.row, oldpos.col)
							end
						else
							awful.spawn.with_shell(exec)
							manual:reset()
						end
						mousegrabber.stop()
					elseif button == 3 then
						awesome.emit_signal("iconmenu::hide")
						iconmenu:toggle()
						mousegrabber.stop()
					end
				end
				return mouse.buttons[1]
			end, "hand2")
		end
	end)

	return widget
end

local function load()
	local layoutfile = gears.filesystem.get_configuration_dir() .. 'json/desktop.json'
	if not gears.filesystem.file_readable(layoutfile) then
		local entries = gen()
		for _, entry in ipairs(entries) do
			grid:add(createicon(entry.icon, entry.label, entry.exec))
		end
		save()
		return
	end

	local awmmenu = {
		{ "Config", user.config },
		{ "Restart", awesome.restart }
	}

	local createmenu = {
		{ "File", function()
			local filename = "New File"
			local filepath = os.getenv("HOME") .. "/docs/desktop/" .. filename
			local i = 1
			while gears.filesystem.file_readable(filepath) do
				filename = "New File " .. "(" .. i .. ")"
				filepath = os.getenv("HOME") .. "/docs/desktop/" .. filename
				i = i + 1
			end
			awful.spawn.with_shell("touch '" .. filepath .. "'")
		end },
		{ "Folder", function()
			local foldername = "New Folder"
			local folderpath = os.getenv("HOME") .. "/docs/desktop/" .. foldername
			local i = 1
			while gears.filesystem.dir_readable(folderpath) do
				foldername = "New Folder " .. "(" .. i .. ")"
				folderpath = os.getenv("HOME") .. "/docs/desktop/" .. foldername
				i = i + 1
			end
			gears.filesystem.make_directories(folderpath)
		end }
	}

	local rootmenu = awful.menu({
		items = {
			{ "Awesome", awmmenu },
			{ "Create", createmenu },
			{ "Terminal", terminal },
			{ "Browser", browser },
			{ "Files", "thunar" },
			-- { "Editor", editorcmd }
		}
	})

	manual:buttons {
		awful.button({}, 1, function()
			awesome.emit_signal("iconmenu::hide")
			rootmenu:hide()
		end),
		awful.button({}, 3, function()
			if mouse.current_widgets[4] == manual then
				awesome.emit_signal("iconmenu::hide")
				rootmenu:toggle()
			end
		end)
	}

	local r = assert(io.open(".config/awesome/json/desktop.json", "r"))
	local table = r:read("*all")
	r:close()
	local layout = json:decode(table)

	for _, entry in ipairs(layout) do
		grid:add_widget_at(createicon(entry.widget.icon, entry.widget.label, entry.widget.exec), entry.row, entry.col)
	end
end

load()

awesome.connect_signal("signal::desktop", function(type) 
	local entries = gen()
	local check = false

	if type == add then
		for _, entry in ipairs(entries) do
			for _, widget in ipairs(grid.children) do
				if entry.label == widget.label then
					check = true
				end
			end
			if check == false then
				grid:add(createicon(entry.icon, entry.label, entry.exec))
			end
			check = false
		end
	end

	if type == remove then
		for _, widget in ipairs(grid.children) do
			for _, entry in ipairs(entries) do
				if entry.label == widget.label then
					check = true
				end
			end
			if check == false then
				grid:remove(widget)
			end
			check = false
		end
	end

	save()
end)
