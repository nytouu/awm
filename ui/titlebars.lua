---@diagnostic disable: undefined-global, unused-local

local awful = require 'awful'
local wibox = require 'wibox'
local xresources = require 'beautiful.xresources'

local dpi = xresources.apply_dpi

client.connect_signal('request::titlebars', function (c)
    local titlebar = awful.titlebar(c, {
        position = 'top',
        size = 34
    })

    local titlebars_buttons = {
        awful.button({}, 1, function ()
            c:activate {
                context = 'titlebar',
                action = 'mouse_move',
            }
        end),
        awful.button({}, 3, function ()
            c:activate {
                context = 'titlebar',
                action = 'mouse_resize',
            }
        end)
    }

    local buttons_loader = {
        layout = wibox.layout.fixed.horizontal,
        buttons = titlebars_buttons,
    }

    local function paddined_button(button, margins)
        margins = margins or {
            top = 9,
            bottom = 9,
            left = 1,
            right = 1
        }

        return wibox.widget {
            button,
            top = margins.top,
            bottom = margins.bottom,
            left = margins.left,
            right = margins.right,
            widget = wibox.container.margin,
        }
    end

    titlebar:setup {
        {
            paddined_button(awful.titlebar.widget.closebutton(c), {
                top = 9,
                bottom = 9,
                right = 1,
                left = 10
            }),
			paddined_button(awful.titlebar.widget.minimizebutton(c)),
            paddined_button(awful.titlebar.widget.maximizedbutton(c)),
            layout = wibox.layout.fixed.horizontal,
        },
        buttons_loader,
        buttons_loader,
        layout = wibox.layout.align.horizontal
    }
end)

