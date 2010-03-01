local lib = LibStub("LibCooldown")
if not lib then return end

local bar = CreateFrame("Frame", "ncCooldownBar", UIParent)
ncUIdb:CreatePanel(bar, 535, 20, "BOTTOM", ActionBarBackground, "TOP", 0, 4)

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
	if flash.e > .75 then
		flash:Hide()
	elseif flash.e < .25 then
		flash:SetAlpha(flash.e*4)
	elseif flash.e > .5 then
		flash:SetAlpha(1-(flash.e%.5)*4)
	end
end)

lib:RegisterCallback("stop", function(id, class)
	local texture = class=="item" and GetItemIcon(id) or select(3, GetSpellInfo(id))
	
	flash.icon:SetTexture(texture)
	flash.e = 0
	flash:Show()
end)