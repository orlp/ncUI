local addon = CreateFrame("CheckButton", "HoverFocusButton", nil, "SecureActionButtonTemplate")
local blizz = {PlayerFrame,PetFrame,PartyMemberFrame1,PartyMemberFrame2,PartyMemberFrame3,PartyMemberFrame4,PartyMemberFrame1PetFrame,PartyMemberFrame2PetFrame,PartyMemberFrame3PetFrame,PartyMemberFrame4PetFrame,TargetFrame,TargetFrameToT,FocusFrame,FocusFrameToT,Boss1TargetFrame,Boss2TargetFrame,Boss3TargetFrame,Boss4TargetFrame}

for _, frame in next, blizz do
	frame:SetAttribute("alt-type1", "focus")
end

hooksecurefunc("CreateFrame", function(_, name, _, template)
	if template ~= "SecureUnitButtonTemplate" then return end
	local frame = _G[name]
	if frame then
		frame:SetAttribute("alt-type1", "focus")
	end
end)

addon:SetAttribute("type1", "macro")
addon:SetAttribute("macrotext", "/focus mouseover")
SetOverrideBindingClick(addon, true, "ALT-BUTTON1", "HoverFocusButton")