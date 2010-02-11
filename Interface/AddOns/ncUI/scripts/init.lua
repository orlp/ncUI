ncUIdb = { -- Create the complete databaseholder
	["general"] = {},
	["worldmap"] = {},
	["media"] = {},
	["chat"] = {},
	["error"] = {},
	["extrabuttons"] = {},
	["resolution"] = ({GetScreenResolutions()})[GetCurrentResolution()],
	["resoheight"] = string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"),
	["resowidth"] = string.match(({GetScreenResolutions()})[GetCurrentResolution()], "(%d+)x%d+"),
}