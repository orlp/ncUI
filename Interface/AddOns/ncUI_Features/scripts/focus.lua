local F, C = ncUI:Fetch()
if not C.focus.enable then return end

-- constants
local _G = getfenv(0)
local addon = CreateFrame("CheckButton", "HoverFocusButton", nil, "SecureActionButtonTemplate")
local blizz = {PlayerFrame,PetFrame,PartyMemberFrame1,PartyMemberFrame2,PartyMemberFrame3,PartyMemberFrame4,PartyMemberFrame1PetFrame,PartyMemberFrame2PetFrame,PartyMemberFrame3PetFrame,PartyMemberFrame4PetFrame,TargetFrame,TargetFrameToT,FocusFrame,FocusFrameToT,Boss1TargetFrame,Boss2TargetFrame,Boss3TargetFrame,Boss4TargetFrame}

-- functions
local function inject(f) f:SetAttribute(C.focus.modify.."-type"..C.focus.button, "focus") end

-- init
for _, f in next, blizz do inject(f) end
addon:SetAttribute("type1", "macro")
addon:SetAttribute("macrotext", "/focus mouseover")

-- runtime
SetOverrideBindingClick(addon, true, C.focus.modify.."-BUTTON"..C.focus.button, "HoverFocusButton")
hooksecurefunc("CreateFrame", function(_, name, _, template)
	if template~="SecureUnitButtonTemplate" then return end
	local f = _G[name]
	if f then inject(f) end
end)
