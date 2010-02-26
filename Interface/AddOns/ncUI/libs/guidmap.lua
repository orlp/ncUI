-- library
local lib = LibStub:NewLibrary("LibGUIDMap", 1.0)
if not lib then return end

local player = UnitGUID("player")
local GUID, UNIT, CALLBACK = {}, {}, {}
local addon = CreateFrame("Frame")
addon:SetScript("OnEvent", function(s,e,...)s[e](s,...)end)
addon:RegisterEvent("UNIT_TARGET")
addon:RegisterEvent("PLAYER_FOCUS_CHANGED")

local function add(guid, unit)
	if not (guid and unit) then return end
	if not GUID[guid] then GUID[guid] = {} end
	GUID[guid][unit] = 1
	
	if not UNIT[unit] then UNIT[unit] = {} end
	UNIT[unit][guid] = 1
	
	if CALLBACK[guid] then
		for func, bool in pairs(CALLBACK[guid]) do func(unit) end
		CALLBACK[guid] = nil
	end
end
local function rm(unit)
	if not unit or not UNIT[unit] then return end
	for guid, bool in pairs(UNIT[unit]) do
		GUID[guid][unit] = nil
	end
	UNIT[unit] = {}
end
local function reg(unit, target)
	if not unit then return end
	rm(unit)
	add(UnitGUID(unit), unit)
	if target then reg(unit.."target", false) end
end

function addon:UNIT_TARGET(unit)
	if not unit then return end
	if unit=="player" then reg("target", false) end	
	reg(unit, true)
end
function addon:PLAYER_FOCUS_CHANGED() reg("focus", true) end
function addon:UPDATE_MOUSEOVER_UNIT() reg("mouseover", true) end

function lib:GetUnitID(guid, func)
	if not guid then return elseif guid==player then return "player" end
	if type(GUID[guid])=="table" then
		local unit = next(GUID[guid])
		if not func then
			return unit
		elseif unit then
			func(unit)
			return true
		end
	end
	if not CALLBACK[guid] then CALLBACK[guid] = {} end
	CALLBACK[guid][func] = 1
end