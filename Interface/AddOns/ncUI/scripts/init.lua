local master = select(2, ...)

function master:Fetch(i) return i and master[i] or unpack(master) end
function master:New(i)
	master[i] = {}
	return master[i]
end

ncUIdb = { -- Create the complete databaseholder
	["general"] = {},
	["worldmap"] = {},
	["media"] = {},
	["chat"] = {},
	["error"] = {},
	["extrabuttons"] = {},
}