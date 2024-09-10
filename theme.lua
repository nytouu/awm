local xresources = require("beautiful.xresources")
local gears = require("gears")
local gfs = require("gears.filesystem")
local colors = require("colors.adwaita_dark")
local helpers = require("helpers")

local dpi = xresources.apply_dpi

-- paths
local themes_path = gfs.get_themes_dir()
local assets_path = gfs.get_configuration_dir() .. "assets/"

-- assets
local icons_path = assets_path .. "icons/"
local shapes_path = assets_path .. "shapes/"
local titlebar_assets_path = assets_path .. "titlebar/"

local theme = {}

theme.user = "nytou"

-- fonts
theme.font_name = "Torus Pro"
theme.nerd_font = "MartianMono Nerd Font"
theme.mono_font = "MartianMono Nerd Font"
theme.material_icons = "Material Icons"
theme.font_size = "10"
theme.font = theme.font_name .. " " .. theme.font_size

-- base colors
theme.black = colors.black
theme.dimblack = colors.dimblack
theme.light_black = colors.light_black
theme.grey = colors.grey
theme.red = colors.red
theme.orange = colors.orange
theme.yellow = colors.yellow
theme.magenta = colors.magenta
theme.green = colors.green
theme.blue = colors.blue
theme.dimblue = colors.dimblue
theme.cyan = colors.cyan
theme.aqua = colors.aqua

-- backgrounds
theme.bg_darker = colors.black
theme.bg_normal = colors.black
theme.bg_contrast = colors.black
theme.bg_lighter = colors.black

theme.bg_titlebar = colors.bg_alt
theme.bg_title_alt = colors.bg_alt

-- elements bg
theme.bg_focus = theme.bg_normal
theme.bg_urgent = theme.red
theme.bg_minimize = theme.bg_normal
theme.bg_systray = theme.bg_normal

-- foregrounds
theme.fg_normal = colors.fg
theme.fg_focus = theme.fg_normal
theme.fg_urgent = theme.fg_normal
theme.fg_minimize = theme.fg_normal

-- defines if should update struts on dashboard closing/opening events
theme.dashboard_update_struts = true

-- some actions bg colors
theme.actions = {
	bg = theme.bg_normal,
	contrast = theme.bg_contrast,
	lighter = theme.bg_lighter,
	fg = theme.fg_normal,
}

-- bar
theme.bar_height = 38

-- borders
theme.border_width = dpi(2)
theme.border_widget = dpi(2)
-- theme.border_color_normal = theme.bg_normal
-- theme.border_color_active = theme.bg_normal
-- theme.border_color_marked = theme.bg_normal
theme.border_radius = dpi(12)

theme.border_normal = colors.normal
theme.border_color = colors.focus
theme.border_focus = colors.focus
theme.border_marked = colors.marked

theme.border_inner = colors.focus
theme.border_outer = colors.black

-- gaps
theme.useless_gap = dpi(12)
theme.gap_single_client = true

-- edge snap
theme.snap_bg = theme.grey
theme.snap_border_width = theme.border_width * 3
theme.snapper_gap = theme.useless_gap * 2

theme.iconsize = dpi(18)
theme.btnsize = dpi(12)

-- tasklist
theme.tasklist_plain_task_name = true
theme.tasklist_bg = theme.bg_normal
theme.tasklist_bg_focus = theme.dimblack
theme.tasklist_bg_urgent = theme.red .. "4D" -- 30% of transparency

-- taglist
theme.taglist_bg = theme.bg_normal
theme.taglist_bg_focus = theme.blue
theme.taglist_bg_occupied = theme.grey
theme.taglist_bg_empty = theme.black

-- systray
theme.systray_icon_spacing = dpi(12)
theme.systray_max_rows = 7

-- menu
theme.menu_font = theme.font
theme.menu_submenu_icon = gears.color.recolor_image(shapes_path .. "triangle.png", theme.fg_normal)
theme.menu_height = dpi(40)
theme.menu_width = dpi(180)
theme.menu_bg_focus = theme.bg_lighter

-- titlebar
theme.titlebar_bg = theme.bg_titlebar
theme.titlebar_bg_focus = theme.bg_title_alt
theme.titlebar_fg = theme.fg_normal

-- close
theme.titlebar_close_button_normal = gears.color.recolor_image(titlebar_assets_path .. "close.png", theme.grey)
theme.titlebar_close_button_focus = gears.color.recolor_image(titlebar_assets_path .. "close.png", theme.fg_normal)
theme.titlebar_close_button_active = gears.color.recolor_image(titlebar_assets_path .. "close.png", theme.fg_normal)

-- maximized
theme.titlebar_maximized_button_normal_active =
	gears.color.recolor_image(titlebar_assets_path .. "maximize.png", theme.fg_normal)
theme.titlebar_maximized_button_normal_inactive =
	gears.color.recolor_image(titlebar_assets_path .. "maximize.png", theme.grey)
theme.titlebar_maximized_button_focus_active =
	gears.color.recolor_image(titlebar_assets_path .. "maximize.png", theme.fg_normal)
theme.titlebar_maximized_button_focus_inactive =
	gears.color.recolor_image(titlebar_assets_path .. "maximize.png", theme.fg_normal)

-- minimize
theme.titlebar_minimize_button_normal = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.dimblack)
theme.titlebar_minimize_button_focus = gears.color.recolor_image(titlebar_assets_path .. "circle.png", theme.yellow)

-- wallpaper
theme.wallpaper = colors.wallpaper

-- layouts
theme.layout_fairh = gears.color.recolor_image(themes_path .. "default/layouts/fairhw.png", theme.fg_normal)
theme.layout_fairv = gears.color.recolor_image(themes_path .. "default/layouts/fairvw.png", theme.fg_normal)
theme.layout_floating = gears.color.recolor_image(themes_path .. "default/layouts/floatingw.png", theme.fg_normal)
theme.layout_magnifier = gears.color.recolor_image(themes_path .. "default/layouts/magnifierw.png", theme.fg_normal)
theme.layout_max = gears.color.recolor_image(themes_path .. "default/layouts/maxw.png", theme.fg_normal)
theme.layout_fullscreen = gears.color.recolor_image(themes_path .. "default/layouts/fullscreenw.png", theme.fg_normal)
theme.layout_tilebottom = gears.color.recolor_image(themes_path .. "default/layouts/tilebottomw.png", theme.fg_normal)
theme.layout_tileleft = gears.color.recolor_image(themes_path .. "default/layouts/tileleftw.png", theme.fg_normal)
theme.layout_tile = gears.color.recolor_image(themes_path .. "default/layouts/tilew.png", theme.fg_normal)
theme.layout_tiletop = gears.color.recolor_image(themes_path .. "default/layouts/tiletopw.png", theme.fg_normal)
theme.layout_spiral = gears.color.recolor_image(themes_path .. "default/layouts/spiralw.png", theme.fg_normal)
theme.layout_dwindle = gears.color.recolor_image(themes_path .. "default/layouts/dwindlew.png", theme.fg_normal)
theme.layout_cornernw = gears.color.recolor_image(themes_path .. "default/layouts/cornernww.png", theme.fg_normal)
theme.layout_cornerne = gears.color.recolor_image(themes_path .. "default/layouts/cornernew.png", theme.fg_normal)
theme.layout_cornersw = gears.color.recolor_image(themes_path .. "default/layouts/cornersww.png", theme.fg_normal)
theme.layout_cornerse = gears.color.recolor_image(themes_path .. "default/layouts/cornersew.png", theme.fg_normal)

-- icons
theme.launcher_icon = gears.color.recolor_image(icons_path .. "launcher.svg", theme.blue)
theme.menu_icon = gears.color.recolor_image(icons_path .. "menu.svg", theme.fg_normal)
theme.hints_icon = gears.color.recolor_image(icons_path .. "hints.svg", theme.blue)
theme.powerbutton_icon = gears.color.recolor_image(icons_path .. "poweroff.svg", theme.red)
theme.poweroff_icon = icons_path .. "poweroff.svg"

theme.volume_on = gears.color.recolor_image(icons_path .. "volume-on.svg", theme.fg_normal)
theme.volume_muted = gears.color.recolor_image(icons_path .. "volume-muted.svg", theme.fg_normal)

theme.network_connected = ""
theme.network_disconnected = "󰖪 "

-- pfp
theme.pfp = assets_path .. "pfp.png"
theme.logo = assets_path .. "void.png"

-- fallback music
theme.fallback_music = assets_path .. "fallback-music.png"

-- fallback notification icon
theme.fallback_notif_icon = gears.color.recolor_image(icons_path .. "hints.svg", theme.blue)

-- theme.icon_theme = "~/.local/share/icons/Colloid/"
theme.icon_theme = "/usr/share/icons/Papirus-Dark/24x24"

-- task preview
theme.task_preview_widget_border_radius = dpi(7)
theme.task_preview_widget_bg = theme.bg_normal
theme.task_preview_widget_border_color = theme.bg_normal
theme.task_preview_widget_border_width = 0
theme.task_preview_widget_margin = dpi(10)

-- tag preview
theme.tag_preview_widget_border_radius = dpi(6)
theme.tag_preview_client_border_radius = dpi(6)
theme.tag_preview_client_opacity = 1.0
theme.tag_preview_client_bg = theme.bg_lighter
theme.tag_preview_client_border_color = theme.blue
theme.tag_preview_client_border_width = 2
theme.tag_preview_widget_bg = theme.bg_normal
theme.tag_preview_widget_border_color = theme.bg_normal
theme.tag_preview_widget_border_width = 2
theme.tag_preview_widget_margin = dpi(7)

-- tooltip
theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_normal

theme.separator_color = theme.grey

return theme
