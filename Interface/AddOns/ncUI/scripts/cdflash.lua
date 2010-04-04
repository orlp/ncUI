local db = ncUIdb["cdflash"]
if not db.enable then return end

local lib = LibStub("LibCooldown")
if not lib then return end


local phase = db.flashtime/3
local mult = 1/phase

local flash = CreateFrame("Frame", nil, UIParent)
flash:SetPoint("CENTER", UIParent)
flash:SetSize(ncUIdb:Scale(100),ncUIdb:Scale(100))
ncUIdb:SetTemplate(flash)
flash.icon = flash:CreateTexture(nil, "OVERLAY")
flash.icon:SetPoint("TOPLEFT", ncUIdb:Scale(2), ncUIdb:Scale(-2))
flash.icon:SetPoint("BOTTOMRIGHT", ncUIdb:Scale(-2), ncUIdb:Scale(2))
flash.icon:SetTexCoord(.08, .92, .08, .92)
flash:Hide()
flash:SetScript("OnUpdate", function(self, e)
	flash.e = flash.e + e
	if flash.e > db.flashtime then
		flash:Hide()
	elseif flash.e < phase then
		flash:SetAlpha(flash.e*mult)
	elseif flash.e > (phase*2) then
		flash:SetAlpha(1-(flash.e%(phase*2))*mult)
	end
end)

lib:RegisterCallback("stop", function(id, class)
	local texture = class=="item" and GetItemIcon(id) or select(3, GetSpellInfo(id))
	
	flash.icon:SetTexture(texture)
	flash.e = 0
	flash:Show()
end)

-- REMOVE AFTER THIS LINE FOR RELEASE --

local player
local f = CreateFrame("Frame", nil, UIParent)
local text = f:CreateFontString(nil, "OVERLAY")
local update = 0

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:SetScript("OnEvent", nil)
	text:SetFont("Fonts\\FRIZQT__.TTF", 22*(768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/GetCVar("uiScale")), "OUTLINE")
	text:SetPoint("CENTER", UIParent, 0, 200)
	text:SetText("ART OF WAR")
	player = UnitGUID("player")
end)
f:SetScript("OnUpdate", function(self, elapsed)
	update = update + elapsed
	if update > .1 then
		update = 0
		if UnitBuff("player", "The Art of War") then
			text:Show()
		else
			text:Hide()
		end
	end
end)