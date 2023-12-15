---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local awful = require 'awful'

-- local launchers = require 'ui.bar.modules.launchers'
local gettaglist = require 'ui.bar.modules.tags'
local gettasklist = require 'ui.bar.modules.tasklist'
local systray_toggler = require 'ui.bar.modules.systray_toggler'
-- local dashboard_toggler = require 'ui.bar.modules.dashboard_toggler'
local actions = require 'ui.bar.modules.actions'
local clock = require 'ui.bar.modules.date'
local getlayoutbox = require 'ui.bar.modules.layoutbox'
-- local powerbutton = require 'ui.bar.modules.powerbutton'
local battery = require 'ui.bar.modules.battery'
local profile = require 'ui.bar.modules.profile'
local music = require 'ui.bar.modules.music'
local helpers = require 'helpers'

screen.connect_signal('request::desktop_decoration', function (s)
    awful.tag(
        {'1', '2', '3', '4', '5', '6', '7'},
        s, awful.layout.layouts[1]
    )

    local bar_content = wibox.widget {
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
		type = "dock",
        widget = wibox.container.background,
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            {
				{
					profile,
					widget = wibox.container.margin,
				},
				getlayoutbox(s),
				-- {
				-- 	gettasklist(s),
				-- 	align  = "center",
				-- 	widget = wibox.container.place
				-- },
				layout = wibox.layout.align.horizontal,
				widget = wibox.container.place,
            },
            nil,
            {
                {
                    {
                        systray_toggler,
                        spacing = 9,
                        right = 4,
                        widget = wibox.container.margin,
                    },
					{
						music,
                        right = 8,
						-- top = 4,
						-- bottom = 4,
						widget = wibox.container.margin,
					},
					{
						{
							battery,
							layout = wibox.container.place,
						},
						spacing = 2,
						widget = wibox.container.margin,
					},
                    {
                        clock,
						left = 8,
                        widget = wibox.container.margin,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = 4,
                right = 12,
                widget = wibox.container.margin,
            },
        },
        {
            {
                {
                    gettaglist(s),
                    widget = wibox.container.place,
                    halign = 'center',
                    valign = 'center',
                },
                widget = wibox.container.background,
                forced_height = 24,
                forced_width = s.geometry.width / 8,
                shape = helpers.mkroundedrect(24),
                bg = beautiful.dimblack,
                fg = beautiful.dimblack,
            },
            widget = wibox.container.place,
        },
        -- {
        --     -- layout = wibox.layout.fixed.horizontal,
        --     -- widget = wibox.container.background,
        --     widget = wibox.container.place,
        --     -- widget = wibox.container.margin,
        --     layout = wibox.layout.fixed.horizontal,
        -- },
    }

    local bar = awful.popup {
        visible = true,
        ontop = true,
        minimum_width = s.geometry.width,
        minimum_height = beautiful.bar_height,
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
		type = "dock",
        widget = bar_content,
        screen = s,
        -- placement = function (d)
        --     return awful.placement.left(d, {
        --         margins = {
        --             -- left = beautiful.useless_gap * 2
        --         }
        --     })
        -- end,
    }

	local function toggle_ontop(c)
		if c.fullscreen then
			bar.ontop = false
		else
			bar.ontop = true
		end
	end

	client.connect_signal("manage", toggle_ontop)
	client.connect_signal("focus", toggle_ontop)
	client.connect_signal("property::floating", toggle_ontop)
	client.connect_signal("property::fullscreen", toggle_ontop)

    bar:struts {
        top = beautiful.bar_height + beautiful.useless_gap,
        -- top = beautiful.bar_height + beautiful.useless_gap * 2,
		-- bottom = beautiful.useless_gap,
		-- left = beautiful.useless_gap,
		-- right = beautiful.useless_gap
    }
end)

