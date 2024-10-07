local ruled = require("ruled")
local awful = require("awful")

local function setup_rules()
	ruled.client.connect_signal("request::rules", function()
		ruled.client.append_rule({
			rule = {},
			callback = function(c)
				if not c.motif_wm_hints.decorations.title then
					c.titlebars_enabled = false
				end
			end,
			properties = {
				size_hints_honor = false,
			},
		})
		ruled.client.append_rule({
			id = "global",
			rule = {},
			properties = {
				focus = awful.client.focus.filter,
				raise = true,
				screen = awful.screen.preferred,
				placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			},
		})
		ruled.client.append_rule({
			rule = {
				class = {
					"Nemo-desktop",
				},
				name = {
					"Desktop",
				},
			},
			properties = {
				focusable = false,
				fullscreen = true,
				sticky = true,
			},
		})
		ruled.client.append_rule({
			id = "floating",
			rule_any = {
				instance = { "copyq", "pinentry" },
				class = {
					"Arandr",
					"Blueman-manager",
					"Gpick",
					"Kruler",
					"Sxiv",
					"Tor Browser",
					"Wpa_gui",
					"veromix",
					"xtightvncviewer",
					"Connman-gtk",
					"ncmpcpp",
					"Nsxiv",
					"File-roller",
					"Nitrogen",
					"Blueberry.py",
					"Engrampa",
					"unityhub",
					".arandr-wrapped",
				},
				name = {
					"Event Tester",
					"File Operation Progress",
				},
				role = {
					"AlarmWindow",
					"ConfigManager",
					"pop-up",
				},
			},
			properties = { floating = true },
		})
		ruled.client.append_rule({
			rule = {
				class = { "librewolf" },
				name = "Picture-in-Picture",
			},
			properties = { sticky = true, ontop = true },
		})
		ruled.client.append_rule({
			id = "titlebars",
			rule_any = { type = { "normal", "dialog" } },
			properties = { titlebars_enabled = true },
		})
		ruled.client.append_rule({
			rule = { class = "Steam" },
			properties = { tag = "1" },
		})
		ruled.client.append_rule({
			rule_any = { class = { "firefox", "librewolf", "zen-alpha" } },
			properties = { tag = "4" },
		})
		ruled.client.append_rule({
			rule_any = { class = { "vesktop", "discord" } },
			properties = { tag = "6" },
		})
	end)

	ruled.notification.connect_signal("request::rules", function()
		ruled.notification.append_rule({
			rule = {},
			properties = {
				screen = awful.screen.preferred,
				implicit_timeout = 5,
			},
		})
	end)
end

setup_rules()
