local ruled = require "ruled"
local awful = require "awful"

local function setup_rules ()
    ruled.client.connect_signal("request::rules", function()
        ruled.client.append_rule {
           rule = { },
           callback = function (c)
              if not c.motif_wm_hints.decorations.title then
                 c.titlebars_enabled = false
              end
           end,
           properties = {
               size_hints_honor = false
           }
        }
        ruled.client.append_rule {
            id         = "global",
            rule       = { },
            properties = {
                focus     = awful.client.focus.filter,
                raise     = true,
                screen    = awful.screen.preferred,
                placement = awful.placement.no_overlap+awful.placement.no_offscreen
            }
        }
        ruled.client.append_rule {
            id       = "floating",
            rule_any = {
                instance = { "copyq", "pinentry" },
                class    = {
                    "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                    "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer",
					"Connman-gtk", "ncmpcpp", "Nsxiv", "File-roller", "Nitrogen",
					"Blueberry.py", "Engrampa", "unityhub"
                },
                name    = {
                    "Event Tester",  -- xev.
					"File Operation Progress",
                },
                role    = {
                    "AlarmWindow",    -- Thunderbird's calendar.
                    "ConfigManager",  -- Thunderbird's about:config.
                    "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
                }
            },
            properties = { floating = true }
        }
        ruled.client.append_rule {
            id         = "titlebars",
            rule_any   = { type = { "normal", "dialog" } },
            properties = { titlebars_enabled = true }
        }
		ruled.client.append_rule {
			rule = { class = "Steam" },
			properties = { tag = "1" },
		}
		ruled.client.append_rule {
			rule = { class = "Firefox" },
			properties = { tag = "4" },
		}
		ruled.client.append_rule {
			rule = { class = "discord" },
			properties = { tag = "6" },
		}
    end)

    ruled.notification.connect_signal("request::rules", function ()
        ruled.notification.append_rule {
            rule = { },
            properties = {
                screen = awful.screen.preferred,
                implicit_timeout = 5,
            }
        }
    end)
end

setup_rules()
