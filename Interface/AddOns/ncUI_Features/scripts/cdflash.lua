local F, C = ncUI:Fetch()
if not C.cdflash.enable then return end

local lib = ncUI:Fetch(4)
if not lib then return end


local phase = C.cdflash.flashtime/3
local mult = 1/phase

local flash = F:CreateFrame("Panel", nil, UIParent)
flash:SetPoint("CENTER")
flash:Size(75)
flash.icon = flash:CreateTexture(nil, "OVERLAY")
--F:SetToolbox(flash.icon)
flash.icon:SetPoint("TOPLEFT", 2, -2)
flash.icon:SetPoint("BOTTOMRIGHT", -2, 2)
flash.icon:SetTexCoord(.08, .92, .08, .92)
flash:Hide()
flash:SetScript("OnUpdate", function(self, e)
	flash.e = flash.e + e
	if flash.e > C.cdflash.flashtime then
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
