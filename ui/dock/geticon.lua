local beautiful = require("beautiful")
local icon_cache = {}

local function Get_icon(client, program_string, class_string, is_steam)
	client = client or nil
	program_string = program_string or nil
	class_string = class_string or nil
	is_steam = is_steam or nil

	if client or program_string or class_string then
		local clientName
		if is_steam then
			clientName = "steam_icon_" .. tostring(client) .. ".svg"
		elseif client then
			if client.class then
				clientName = string.lower(client.class:gsub(" ", "")) .. ".svg"
			elseif client.name then
				clientName = string.lower(client.name:gsub(" ", "")) .. ".svg"
			else
				if client.icon then
					return client.icon
				else
					return beautiful.icon_theme .. "/apps/defcon.svg"
				end
			end
		else
			if program_string then
				clientName = program_string .. ".svg"
			else
				clientName = class_string .. ".svg"
			end
		end

		for index, icon in ipairs(icon_cache) do
			if icon:match(clientName) then
				return icon
			end
		end

		local iconDir = beautiful.icon_theme .. "/apps/"
		local ioStream = io.open(iconDir .. clientName, "r")
		if ioStream ~= nil then
			icon_cache[#icon_cache + 1] = iconDir .. clientName
			return iconDir .. clientName
		else
			clientName = clientName:gsub("^%l", string.upper)
			iconDir = beautiful.icon_theme .. "/apps/"
			ioStream = io.open(iconDir .. clientName, "r")
			if ioStream ~= nil then
				icon_cache[#icon_cache + 1] = iconDir .. clientName
				return iconDir .. clientName
			elseif not class_string then
				return beautiful.icon_theme .. "/apps/defcon.svg"
			else
				clientName = class_string .. ".svg"
				iconDir = beautiful.icon_theme .. "/apps/"
				ioStream = io.open(iconDir .. clientName, "r")
				if ioStream ~= nil then
					icon_cache[#icon_cache + 1] = iconDir .. clientName
					return iconDir .. clientName
				else
					return beautiful.icon_theme .. "/apps/default-application.svg"
				end
			end
		end
	end
	if client then
		return beautiful.icon_theme .. "/apps/default-application.svg"
	end
end

return Get_icon
