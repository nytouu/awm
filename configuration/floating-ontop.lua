client.connect_signal("property::floating", function(c)
	c.ontop = c.floating and not c.fullscreen
end)
