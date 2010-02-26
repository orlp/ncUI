local function getcolor()
	local reaction = UnitReaction("mouseover", "player") or 5
	
	if UnitIsPlayer("mouseover") then
		local _, class = UnitClass("mouseover")
		local color = RAID_CLASS_COLORS[class]
		return color.r, color.g, color.b
	elseif UnitCanAttack("player", "mouseover") then
		if UnitIsTapped("mouseover") and not UnitIsTappedByPlayer("mouseover") or UnitIsDead("mouseover") then
			return 136/255, 136/255, 136/255
		else
			if reaction<4 then
				return 1, 68/255, 68/255
			elseif reaction==4 then
				return 1, 1, 68/255
			end
		end
	else
		if reaction<4 then
			return 48/255, 113/255, 191/255
		else
			return 1, 1, 1
		end
	end
end

local f = CreateFrame("Frame")
f:SetFrameStrata("TOOLTIP")
f.text = f:CreateFontString(nil, "OVERLAY")
f.text:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")

f:SetScript("OnUpdate", function(self)
	if not UnitExists("mouseover") then self:Hide() return end
	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	self.text:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y+15)
end)
f:SetScript("OnEvent", function(self)
	local focus = GetMouseFocus()
	if focus and focus:GetName()~="WorldFrame" then return end
	
	local name = UnitName("mouseover")
	local AFK = UnitIsAFK("mouseover")
	local DND = UnitIsDND("mouseover")
	local prefix = ""
	
	if AFK then prefix = "<AFK> " end
	if DND then prefix = "<DND> " end
	
	self.text:SetTextColor(getcolor())
	self.text:SetText(prefix..name)

	self:Show()
end)
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")