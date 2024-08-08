---@diagnostic disable: undefined-global
local gears = require 'gears'
local wibox = require 'wibox'
local awful = require 'awful'
local beautiful = require 'beautiful'
local naughty = require 'naughty'
local dpi = beautiful.xresources.apply_dpi
local cairo = require("lgi").cairo

local color = require 'modules.color'
local rubato = require 'modules.rubato'

local helpers = {}

-- colorize a text using pango markup
function helpers.get_colorized_markup(content, fg)
	fg = fg or beautiful.blue
	content = content or ''

	return '<span foreground="' .. fg .. '">' .. content .. '</span>'
end

function helpers.apply_transition(opts)
	opts = opts or {}

	local bg = opts.bg or beautiful.bg_lighter
	local hbg = opts.hbg or beautiful.black

	local element = opts.element
	local prop = opts.prop

	local background = color.color { hex = bg }
	local hover_background = color.color { hex = hbg }

	local transition = color.transition(background, hover_background, color.transition.RGB)

	local fading = rubato.timed {
		duration = 0.30,
	}

	fading:subscribe(function (pos)
		element[prop] = transition(pos / 100).hex
	end)

	return {
		on = function ()
			fading.target = 100
		end,
		off = function ()
			fading.target = 0
		end
	}
end

helpers.prect        = function(tl, tr, br, bl, radius)
  radius = radius or dpi(4)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end

-- add hover support to wibox.container.background-based elements
function helpers.add_hover(element, bg, hbg)
	local transition = helpers.apply_transition {
		element = element,
		prop = 'bg',
		bg = bg,
		hbg = hbg,
	}

	element:connect_signal('mouse::enter', transition.on)
	element:connect_signal('mouse::leave', transition.off)
end

-- create a rounded rect using a custom radius
function helpers.mkroundedrect(radius)
	radius = radius or dpi(7)
	return function (cr, w, h)
		return gears.shape.rounded_rect(cr, w, h, radius)
	end
end

-- create a simple rounded-like button with hover support
function helpers.mkbtn(template, bg, hbg, radius)
	local button = wibox.widget {
		{
			template,
			margins = dpi(7),
			widget = wibox.container.margin,
		},
		bg = bg,
		widget = wibox.container.background,
		shape = helpers.mkroundedrect(radius),
	}

	if bg and hbg then
		helpers.add_hover(button, bg, hbg)
	end

	return button
end

-- add a list of buttons using :add_button to `widget`.
function helpers.add_buttons(widget, buttons)
	for _, button in ipairs(buttons) do
		widget:add_button(button)
	end
end

-- trim strings
function helpers.trim(input)
	local result = input:gsub("%s+", "")
	return string.gsub(result, "%s+", "")
end

-- make a rounded container for make work the antialiasing.
function helpers.mkroundedcontainer(template, bg)
	return wibox.widget {
		template,
		shape = helpers.mkroundedrect(),
		bg = bg,
		widget = wibox.container.background,
	}
end

-- make an awful.popup that's used to replace the native AwesomeWM tooltip component
function helpers.make_popup_tooltip(text, placement)
	local ret = {}

	ret.widget = wibox.widget {
		{
			{
				id = 'image',
				image = beautiful.hints_icon,
				forced_height = dpi(12),
				forced_width = dpi(12),
				halign = 'center',
				valign = 'center',
				widget = wibox.widget.imagebox,
			},
			{
				id = 'text',
				markup = text or '',
				align = 'center',
				widget = wibox.widget.textbox,
			},
			spacing = dpi(7),
			layout = wibox.layout.fixed.horizontal,
		},
		margins = dpi(12),
		widget = wibox.container.margin,
		set_text = function (self, t)
			self:get_children_by_id('text')[1].markup = t
		end,
		set_image = function (self, i)
			self:get_children_by_id('image')[1].image = i
		end
	}

	ret.popup = awful.popup {
		visible = false,
		shape = helpers.mkroundedrect(),
		bg = beautiful.bg_normal .. '00',
		fg = beautiful.fg_normal,
		ontop = true,
		placement = placement or awful.placement.centered,
		screen = awful.screen.focused(),
		widget = helpers.mkroundedcontainer(ret.widget, beautiful.bg_normal),
	}

	local self = ret.popup

	function ret.show()
		self.screen = awful.screen.focused()
		self.visible = true
	end

	function ret.hide()
		self.visible = false
	end

	function ret.toggle()
		if not self.visible and self.screen ~= awful.screen.focused() then
			self.screen = awful.screen.focused()
		end
		self.visible = not self.visible
	end

	function ret.attach_to_object(object)
		object:connect_signal('mouse::enter', ret.show)
		object:connect_signal('mouse::leave', ret.hide)
	end

	return ret
end

-- capitalize a string
function helpers.capitalize (txt)
	return string.upper(string.sub(txt, 1, 1))
		.. string.sub(txt, 2, #txt)
end

-- a fully capitalizing helper.
function helpers.complex_capitalizing (s)
	local r, i = '', 0
	for w in s:gsub('-', ' '):gmatch('%S+') do
		local cs = helpers.capitalize(w)
		if i == 0 then
			r = cs
		else
			r = r .. ' ' .. cs
		end
		i = i + 1
	end

	return r
end

-- limit a string by a length and put ... at the final if the
-- `max_length` is exceded `str`
function helpers.limit_by_length (str, max_length, use_pango)
	local sufix = ''
	local toput = '...'

	if #str > max_length - #toput then
		str = string.sub(str, 1, max_length - 3)
		sufix = toput
	end

	if use_pango and sufix == toput then
		sufix = helpers.get_colorized_markup(sufix, beautiful.light_black)
	end

	return str .. sufix
end

-- apply a margin container to a given widget
function helpers.apply_margin(widget, opts)
	return wibox.widget {
		widget,
		margins = opts.margins,
		left = opts.left,
		right = opts.right,
		top = opts.top,
		bottom = opts.bottom,
		widget = wibox.container.margin,
	}
end

function helpers.get_notification_widget(n)
	return {
		{
			{
				{
					{
						{
							image = n.icon or beautiful.fallback_notif_icon,
							forced_height = 32,
							forced_width = 32,
							valign = 'center',
							align = 'center',
							clip_shape = gears.shape.circle,
							widget = wibox.widget.imagebox,
						},
						{
							markup = helpers.complex_capitalizing(n.app_name == '' and 'Cannot detect app' or n.app_name),
							align = 'left',
							valign = 'center',
							widget = wibox.widget.textbox,
						},
						spacing = dpi(10),
						layout = wibox.layout.fixed.horizontal,
					},
					margins = dpi(10),
					widget = wibox.container.margin,
				},
				{
					{
						{
							markup = '',
							widget = wibox.widget.textbox,
						},
						top = 1,
						widget = wibox.container.margin,
					},
					bg = beautiful.light_black,
					widget = wibox.container.background,
				},
				layout = wibox.layout.fixed.vertical,
			},
			{
				{
					n.title == '' and nil or {
						markup = '<b>' .. helpers.complex_capitalizing(n.title) .. '</b>',
						align = 'center',
						valign = 'center',
						widget = wibox.widget.textbox,
					},
					{
						markup = n.title == '' and '<b>' .. n.message .. '</b>' or n.message,
						align = 'center',
						valign = 'center',
						widget = wibox.widget.textbox,
					},
					spacing = dpi(5),
					layout = wibox.layout.fixed.vertical,
				},
				top = dpi(25),
				left = dpi(12),
				right = dpi(12),
				bottom = dpi(15),
				widget = wibox.container.margin,
			},
			{
				{
					notification = n,
					base_layout = wibox.widget {
						spacing = dpi(12),
						layout = wibox.layout.flex.horizontal,
					},
					widget_template = {
						{
							{
								{
									id = 'text_role',
									widget = wibox.widget.textbox,
								},
								widget = wibox.container.place,
							},
							top = dpi(7),
							bottom = dpi(7),
							left = dpi(4),
							right = dpi(4),
							widget = wibox.container.margin,
						},
						shape = gears.shape.rounded_bar,
						bg = beautiful.black,
						widget = wibox.container.background,
					},
					-- widget = naughty.list.actions,
				},
				margins = dpi(12),
				widget = wibox.container.margin,
			},
			spacing = dpi(7),
			layout = wibox.layout.align.vertical,
		},
		bg = beautiful.bg_normal,
		fg = beautiful.fg_normal,
		shape = helpers.mkroundedrect(),
		widget = wibox.container.background,
	}
end

local function notify_card_body(n, layout)
	if not layout then
		layout = wibox.layout.flex.vertical()
	end

	if n.title ~= '' then
		layout:add(wibox.widget {
			markup = '<b>' .. helpers.limit_by_length(helpers.complex_capitalizing(n.title), 23, true) .. '</b>',
			font = beautiful.font_name .. ' 15',
			align = 'center',
			valign = 'center',
			widget = wibox.widget.textbox,
		})
	end

	layout:add(wibox.widget {
		markup = n.title == '' and '<b>' .. helpers.limit_by_length(n.message, 23, true) .. '</b>' or helpers.limit_by_length(n.message, 36, true),
		font = n.title == '' and beautiful.font_name .. ' 15' or beautiful.font_name .. ' ' .. beautiful.font_size,
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox,
	})

	return layout
end

function helpers.get_sidebar_screenshot_body (n)
	return {
		{
			{
				n.icon and {
					image = n.icon,
					halign = 'center',
					valign = 'center',
					upscale = false,
					resize = true,
					clip_shape = helpers.mkroundedrect(),
					widget = wibox.widget.imagebox,
				} or {
						markup = helpers.get_colorized_markup('', beautiful.blue),
						font = beautiful.nerd_font .. ' 40',
						align = 'center',
						valign = 'center',
						widget = wibox.widget.textbox,
					},
				{
					notify_card_body(n, wibox.layout.fixed.vertical {
						spacing = beautiful.useless_gap * 2,
					}),
					halign = 'center',
					valign = 'center',
					layout = wibox.container.place,
				},
				spacing = beautiful.useless_gap * 2,
				layout = wibox.layout.fixed.vertical,
			},
			margins = beautiful.useless_gap * 4,
			widget = wibox.container.margin,
		},
		bg = beautiful.black,
		widget = wibox.container.background,
	}
end

function helpers.get_sidebar_body(n)
	return {
		{
			{
				n.icon and {
					image = n.icon,
					forced_height = 128,
					forced_width = 128,
					downscale = true,
					halign = 'center',
					valign = 'center',
					clip_shape = helpers.mkroundedrect(),
					widget = wibox.widget.imagebox,
				} or {
						markup = helpers.get_colorized_markup('', beautiful.blue),
						font = beautiful.nerd_font .. ' 40',
						align = 'center',
						valign = 'center',
						widget = wibox.widget.textbox,
					},
				{
					notify_card_body(n),
					halign = 'center',
					valign = 'center',
					layout = wibox.container.place,
				},
				nil,
				layout = wibox.layout.align.horizontal,
			},
			margins = beautiful.useless_gap * 4,
			widget = wibox.container.margin,
		},
		bg = beautiful.black,
		widget = wibox.container.background,
	}
end

local function delete_button(list_table, widget, notif_list)
	local button = wibox.widget {
		{
			markup = '',
			align = 'center',
			valign = 'center',
			font = beautiful.nerd_font .. ' 14',
			widget = wibox.widget.textbox,
		},
		bg = beautiful.black,
		fg = beautiful.red,
		shape = gears.shape.circle,
		forced_height = 24,
		forced_width = 24,
		widget = wibox.container.background,
	}

	helpers.add_hover(button, beautiful.black, beautiful.dimblack)

	button:add_button(awful.button({}, 1, function ()
		local index = helpers.index_of(list_table, widget)
		notif_list:remove(index)
		table.remove(list_table, index)
		awesome.emit_signal('notifcenter::message', 'Notification removed successfully')
	end))

	return button
end

function helpers.index_of(array, value)
	for i, v in ipairs(array) do
		if v == value then
			return i
		end
	end
	return nil
end

function helpers.get_sidebar_notification_widget(n, list_table, widget, notif_list)
	return {
		{
			{
				{
					{
						{
							markup = helpers.complex_capitalizing(n.app_name == '' and 'Cannot detect app' or n.app_name),
							font = beautiful.font_name .. ' 12',
							widget = wibox.widget.textbox,
						},
						nil,
						delete_button(list_table, widget, notif_list),
						layout = wibox.layout.align.horizontal,
					},
					margins = 12,
					widget = wibox.container.margin,
				},
				bg = beautiful.bg_lighter,
				widget = wibox.container.background,
			},
			n.app_name == 'Screenshot' and not (not n.icon)
				and helpers.get_sidebar_screenshot_body(n)
				or helpers.get_sidebar_body(n),
			layout = wibox.layout.fixed.vertical,
		},
		bg = beautiful.bg_normal,
		widget = wibox.container.background,
	}
end

function helpers.is_in_table(table, value, pfunc)
	if not pfunc then
		pfunc = ipairs
	end

	for _, val in pfunc(table) do
		if val == value then
			return true
		end
	end

	return false
end

function helpers.hover_cursor(w, cursorType)
	cursorType = cursorType or 'hand2'
	local oldCursor = 'left_ptr'
	local wbx

	w.hcDisabled = false
	local enterCb = function()
		wbx = mouse.current_wibox
		if wbx then wbx.cursor = cursorType end
	end
	local leaveCb = function()
		if wbx then wbx.cursor = oldCursor end
	end

	w:connect_signal('hover::disconnect', function()
		w:disconnect_signal('mouse::enter', enterCb)
		w:disconnect_signal('mouse::leave', leaveCb)
		leaveCb()
	end)
end-- i forgot what this does

helpers.inTable = function(t, v)
	for _, value in ipairs(t) do
		if value == v then
			return true
		end
	end

	return false
end

helpers.colorize_text = function(txt, fg)
	if fg == "" then
		fg = "#ffffff"
	end

	return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

helpers.click_key     = function(c, key)
	awful.spawn.with_shell("xdotool type --window " .. tostring(c.window) .. " '" .. key .. "'")
end

helpers.split = function(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

helpers.readJson = function(DATA)
  if helpers.file_exists(DATA) then
    local f = assert(io.open(DATA, "rb"))
    local lines = f:read("*all")
    f:close()
    local data = json.decode(lines)
    return data
  else
    return {}
  end
end

helpers.writeJson = function(PATH, DATA)
  local w = assert(io.open(PATH, "w"))
  w:write(json.encode(DATA, nil, { pretty = true, indent = "	", align_keys = false, array_newline = true }))
  w:close()
end
helpers.file_exists = function(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

helpers.cropSurface  = function(ratio, surf)
  local old_w, old_h = gears.surface.get_size(surf)
  local old_ratio = old_w / old_h
  if old_ratio == ratio then return surf end

  local new_h = old_h
  local new_w = old_w
  local offset_h, offset_w = 0, 0
  -- quick mafs
  if (old_ratio < ratio) then
    new_h = math.ceil(old_w * (1 / ratio))
    offset_h = math.ceil((old_h - new_h) / 2)
  else
    new_w = math.ceil(old_h * ratio)
    offset_w = math.ceil((old_w - new_w) / 2)
  end

  local out_surf = cairo.ImageSurface(cairo.Format.ARGB32, new_w, new_h)
  local cr = cairo.Context(out_surf)
  cr:set_source_surface(surf, -offset_w, -offset_h)
  cr.operator = cairo.Operator.SOURCE
  cr:paint()

  return out_surf
end

helpers.gc = function(widget, id)
  return widget:get_children_by_id(id)[1]
end

helpers.hover_widget = function(widget)
	widget:connect_signal("mouse::enter", function()
		if widget.bg ~= beautiful.grey then
			widget.bg = beautiful.light_black
		end
	end)

	widget:connect_signal("mouse::leave", function()
		if widget.bg ~= beautiful.grey then
			widget.bg = beautiful.dimblack
		end
	end)

	-- add buttons and commands
	widget:connect_signal("button::press", function()
		widget.bg = beautiful.grey
	end)

	widget:connect_signal("button::release", function()
		gears.timer {
			timeout   = 0.1,
			autostart = true,
			single_shot = true,
			callback  = function()
				widget.bg = beautiful.dimblack
			end
		}
	end)
end

return helpers
