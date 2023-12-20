local wibox = require 'wibox'
local awful = require 'awful'
local beautiful = require 'beautiful'

-- listening awesomewm events
require 'ui.systray.listener'

awful.screen.connect_for_each_screen(function (s)
    s.systray = {}

    local capi = {
        awesome = awesome,
        screen = s,
    }
    local num_entries = capi.awesome.systray()

    local dimensions = {
        width = 100,
        height = 38,
    }


    s.systray.popup = wibox {
        visible = false,
        ontop = true,
		type = "popup_menu",
        width = dimensions.width,
        height = dimensions.height,
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        x = s.geometry.x + 1456,
        y = -2,
    }

    local self = s.systray.popup

    self:setup {
        {
            {
                {
                    widget = wibox.widget.systray,
                    horizontal = false,
                    screen = s,
                    base_size = 24,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            margins = 12,
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        widget = wibox.container.background,
    }

    function s.systray.toggle()
        if self.visible then
            s.systray.hide()
        else
            s.systray.show()
        end
    end

    function s.systray.show()
        self.visible = true
    end

    function s.systray.hide()
        self.visible = false
    end
end)
