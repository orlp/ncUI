local F, C = ncUI:Fetch()
if not C.extrabuttons.enable then return end

local header = CreateFrame("Button", "ncExtrabuttonsHeader", UIParent, "SecureHandlerClickTemplate")
C.extrabuttons.buttons = {}

--[[
	Default Blizzard IDs:
	13-24 Second Bar
	25-36 Side Bar 1
	37-48 Side Bar 2
	49-60 Bottom Right Bar
	61-72 Bottom Left Bar
]]

-- Setup class specific actionbutton id's
local _, class = UnitClass("player")
if class == "DRUID" then
	C.extrabuttons["buttonids"] = {
		24,
		25,
		26,
		27,
		28,
		29,
		30,
		31,
		32,
		33,
		34,
		35,
		36,
		49,
		50,
		51,
		52,
		53,
		54,
		55,
		56,
		58,
		59,
		60,
		61,
	}
elseif class == "WARRIOR" then
	C.extrabuttons["buttonids"] = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		60,
		109,
		110,
		111,
		112,
		113,
		114,
		115,
		116,
		117,
		118,
		119,
		120,
	}
else
	C.extrabuttons["buttonids"] = {
		96,
		97,
		98,
		99,
		100,
		101,
		102,
		103,
		104,
		105,
		106,
		107,
		108,
		109,
		110,
		111,
		112,
		113,
		114,
		115,
		116,
		117,
		118,
		119,
		120,
	}
end
	
_G["BINDING_NAME_CLICK ncExtrabuttonsHeader:LeftButton"] = "Show extra buttons"
BINDING_HEADER_ncUI = "ncUI extra functions"

-- Create the buttons
for i = 1, 25 do
	local button = CreateFrame("CheckButton", "ncExtrabuttonsButton"..i, header, "ActionBarButtonTemplate")
	C.extrabuttons.buttons[i] = button
	if i == 1 then
		button:Place("CENTER", header, "CENTER", 0, 0)
	elseif i == 2 then
		button:Place("RIGHT", C.extrabuttons.buttons[i-1], "LEFT", -3, 0)
	elseif i == 3 then
		button:Place("LEFT", C.extrabuttons.buttons[i-2], "RIGHT", 3, 0)
	elseif i == 4 then
		button:Place("BOTTOM", C.extrabuttons.buttons[i-3], "TOP", 0, 3)
	elseif i == 5 then
		button:Place("TOP", C.extrabuttons.buttons[i-4], "BOTTOM", 0, -3)
	elseif i == 6 or i == 14 then
		button:Place("RIGHT", C.extrabuttons.buttons[i-2], "LEFT", -3, 0)
	elseif i == 7 or i == 15 then
		button:Place("LEFT", C.extrabuttons.buttons[i-3], "RIGHT", 3, 0)
	elseif i == 8 or i == 16 then
		button:Place("RIGHT", C.extrabuttons.buttons[i-3], "LEFT", -3, 0)
	elseif i == 9 or i == 17 then
		button:Place("LEFT", C.extrabuttons.buttons[i-4], "RIGHT", 3, 0)
	elseif i == 10 or i == 22 or i == 24 then
		button:Place("RIGHT", C.extrabuttons.buttons[i-8], "LEFT", -3, 0)
	elseif i == 11 or i == 23 or i == 25 then
		button:Place("LEFT", C.extrabuttons.buttons[i-8], "RIGHT", 3, 0)
	elseif i == 12 then
		button:Place("BOTTOM", C.extrabuttons.buttons[i-8], "TOP", 0, 3)
	elseif i == 13 then
		button:Place("TOP", C.extrabuttons.buttons[i-8], "BOTTOM", 0, -3)
	elseif i == 18 or i == 20 then
		button:Place("RIGHT", C.extrabuttons.buttons[i-12], "LEFT", -3, 0)
	elseif i == 19 or i == 21 then
		button:Place("LEFT", C.extrabuttons.buttons[i-12], "RIGHT", 3, 0)
	end
	button:SetAttribute("*type*", "action")
	button:SetAttribute("*action*", C.extrabuttons["buttonids"][i])
end

-- Setup the virtual button with binding
header:RegisterForClicks("AnyDown", "AnyUp")
header:Hide()
header:SetAttribute("_onclick", [[
	self:SetPoint("CENTER", "$cursor")
	if down then
		self:Show()
	else
		self:Hide()
end]])