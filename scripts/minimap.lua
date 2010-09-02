local F, C, L = unpack(select(2, ...))

local border = F:CreatePanel("ncUIMinimapBorder", Minimap)
border:SetFrameLevel(1)
border:Point("TOPLEFT", -1, 1)
border:Point("BOTTOMRIGHT", 1, -1)

Minimap:ClearAllPoints()
Minimap:Point("TOPRIGHT", UIParent, -24, -24)
Minimap:Size(144)

MinimapBorder:Hide()
MinimapBorderTop:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MiniMapVoiceChatFrame:Hide()
MinimapNorthTag:SetTexture(nil)
F:Destroy(GameTimeFrame) -- brute force bro, brute force
MinimapZoneTextButton:Hide()
MiniMapTracking:Hide()
MiniMapWorldMapButton:Hide()

MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:Point("TOPRIGHT", Minimap, 3, 4)
MiniMapMailBorder:Hide()
MiniMapMailIcon:SetTexture([[Interface\AddOns\ncUI\media\mail]])

MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:Point("BOTTOMRIGHT", Minimap, 3, 0)
MiniMapBattlefieldBorder:Hide()

MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:Point("TOPLEFT", Minimap, 0, 0)

hooksecurefunc("MiniMapLFG_UpdateIsShown", function()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:Point("BOTTOMRIGHT", Minimap, 2, 1)
	MiniMapLFGFrameBorder:Hide()
end)

Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, delta)
	if delta > 0 then
		MinimapZoomIn:Click()
	elseif delta < 0 then
		MinimapZoomOut:Click()
	end
end)

local menuframe = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menulist = {
    {text = CHARACTER_BUTTON, func = function() ToggleCharacter("PaperDollFrame") end},
    {text = SPELLBOOK_ABILITIES_BUTTON, func = function() ToggleFrame(SpellBookFrame) end},
    {text = TALENTS_BUTTON, func = function() ToggleTalentFrame() end},
    {text = ACHIEVEMENT_BUTTON, func = function() ToggleAchievementFrame() end},
    {text = QUESTLOG_BUTTON, func = function() ToggleFrame(QuestLogFrame) end},
    {text = SOCIAL_BUTTON, func = function() ToggleFriendsFrame(1) end},
    {text = PLAYER_V_PLAYER, func = function() ToggleFrame(PVPParentFrame) end},
    {text = LFG_TITLE, func = function() ToggleFrame(LFDParentFrame) end},
    {text = L_LFRAID, func = function() ToggleFrame(LFRParentFrame) end},
    {text = HELP_BUTTON, func = function() ToggleHelpFrame() end},
    {text = L_CALENDAR, func = function() if not CalendarFrame then LoadAddOn("Blizzard_Calendar") end Calendar_Toggle() end},
}

Minimap:SetScript("OnMouseUp", function(self, btn)
	if btn == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
	elseif btn == "MiddleButton" then
		EasyMenu(menulist, menuframe, "cursor", 0, 0, "MENU", 2)
	else
		Minimap_OnClick(self)
	end
end)

Minimap:SetMaskTexture([[Interface\ChatFrame\ChatFrameBackground]])
function GetMinimapShape() return "SQUARE" end
F:SetTemplate(LFDSearchStatus)

MinimapPing:HookScript("OnUpdate", function(holder, elapsed)
	if holder.fadeOut or holder.timer > MINIMAPPING_FADE_TIMER then
		Minimap_SetPing(Minimap:GetPingPosition())
	end
end)

local minimapinfo = CreateFrame("Frame", nil, Minimap)
local zonetext = minimapinfo:CreateFontString("ncUIZoneText", "OVERLAY", "ncUIfont")
zonetext:Point("TOPLEFT", Minimap, 0, -10)
zonetext:Point("TOPRIGHT", Minimap, 0, -10)
zonetext:SetJustifyH("CENTER")

local coordtextleft = minimapinfo:CreateFontString("ncUICoordTextLeft", "OVERLAY", "ncUIfont")
coordtextleft:Point("BOTTOMLEFT", Minimap, 10, 10)
coordtextleft:SetJustifyH("LEFT")

local coordtextright = minimapinfo:CreateFontString("ncUICoordTextRight", "OVERLAY", "ncUIfont")
coordtextright:Point("BOTTOMRIGHT", Minimap, -10, 10)
coordtextright:SetJustifyH("RIGHT")

minimapinfo:Hide()
minimapinfo:RegisterEvent("PLAYER_ENTERING_WORLD")
minimapinfo:RegisterEvent("ZONE_CHANGED_NEW_AREA")
minimapinfo:RegisterEvent("ZONE_CHANGED")
minimapinfo:RegisterEvent("ZONE_CHANGED_INDOORS")
minimapinfo:SetScript("OnEvent", function() zonetext:SetText(GetMinimapZoneText()) end) 

Minimap:HookScript("OnEnter", function() minimapinfo:Show() end)
Minimap:HookScript("OnLeave", function() minimapinfo:Hide() end)

minimapinfo:SetScript("OnUpdate", function(minimapinfo, t)
	local x, y = GetPlayerMapPosition("player")
	if x == 0 and y == 0 then
		coordtextleft:SetText("??")
		coordtextright:SetText("??")
	else
		coordtextleft:SetFormattedText("%.2f", x * 100)
		coordtextright:SetFormattedText("%.2f", y * 100)
	end
end)
