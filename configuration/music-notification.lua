local bling = require("modules.bling")
local beautiful = require("beautiful")
local naughty = require("naughty")
local playerctl = bling.signal.playerctl.lib({
	-- ignore = "firefox",
	--     player = {"mpd", "%any"}
})

local function notif(title, artist, album_path)
	local previous = naughty.action({ name = "󰒮" })
	previous:connect_signal("invoked", function()
		playerctl:previous()
	end)
	local pause = naughty.action({ name = "" })
	pause:connect_signal("invoked", function()
		playerctl:play_pause()
	end)
	local next = naughty.action({ name = "󰒭" })
	next:connect_signal("invoked", function()
		playerctl:next()
	end)

	naughty.notify({
		title = title,
		text = "by " .. artist:match(".+") or "Unknown",
		image = album_path:match("/") and album_path or beautiful.bg_light,
		actions = { previous, pause, next },
		-- timeout = 2
	})
end

local info_first = true
playerctl:connect_signal("metadata", function(_, title, artist, album_path, _, _, _)
	if info_first then
		info_first = false
	else
		notif(title, artist, album_path)
	end
end)
