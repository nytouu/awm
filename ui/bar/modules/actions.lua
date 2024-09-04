local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local helpers = require("helpers")
local rubato = require("modules.rubato")

local network = require("ui.bar.modules.actions-icons.network")
local volume = require("ui.bar.modules.actions-icons.volume")
local notification = require("ui.bar.modules.actions-icons.notification")

local actions = wibox.widget({
	{
		{
			{
				network,
				volume,
				notification,
				layout = wibox.layout.flex.horizontal,
			},
			-- top = 2,
			-- bottom = 2,
			--             left = 3,
			--             right = 3,
			widget = wibox.container.margin,
		},
		forced_width = 0,
		shape = helpers.mkroundedrect(),
		bg = beautiful.bg_lighter,
		widget = wibox.container.background,
	},
	left = beautiful.bar_height / 6,
	top = 3,
	right = beautiful.bar_height / 6,
	widget = wibox.container.margin,
})

local toggler = wibox.widget({
	markup = "   ",
	font = beautiful.nerd_font .. " 13",
	align = "center",
	widget = wibox.widget.textbox,
})

local self = toggler

local anim = rubato.timed({
	duration = 0.2,
	override_dt = true,
	rate = 120,
})

local max_width = 78

anim:subscribe(function(pos)
	actions.forced_width = pos
	if self.status == "revealing" and pos == max_width then
		self.status = "revealed"
	elseif self.status == "revealed" and pos == 0 then
		self.status = "revealing"
	end
end)

self:add_button(awful.button({}, 1, function()
	-- status could be just: 'revealing' or 'revealed'
	if not self.status then
		self.status = "revealing"
	end

	-- toggling
	if self.status == "revealing" then
		anim.target = max_width
	elseif self.status == "revealed" then
		anim.target = 0
	end
end))

local container = wibox.widget({
	actions,
	toggler,
	layout = wibox.layout.fixed.horizontal,
})

return container
