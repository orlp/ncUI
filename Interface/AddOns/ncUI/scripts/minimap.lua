local F, C = select(2, ...):Fetch()

local bg = F:CreateFrame("Panel", "MapBorder", Minimap)
bg:Size(145)
bg:Place("TOPLEFT", -2, 2)
bg:Place("BOTTOMRIGHT", 2, -2)
--F:SetToolbox(Minimap)
Minimap:SetMaskTexture(C.media.mask)
Minimap:SetFrameStrata("BACKGROUND")
Minimap:ClearAllPoints()
Minimap:Place("TOPRIGHT", UIParent, "TOPRIGHT", -13, -13)
Minimap:Size(111)

MinimapBorder:Hide()
MinimapBorderTop:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

MiniMapVoiceChatFrame:Destroy()
DurabilityFrame:Destroy()
MinimapZoneTextButton:Destroy()
MiniMapTracking:Destroy()
--MinimapNorthTag:Destroy()
MiniMapWorldMapButton:Destroy()

GameTimeFrame:Hide()
MiniMapMailBorder:Hide()
MiniMapMailIcon:SetTexture(C.media.mail)
MiniMapMailIcon:ClearAllPoints()
MiniMapMailIcon:Place("BOTTOMLEFT", Minimap, 3, 0)
MiniMapMailFrame:SetAllPoints(MiniMapMailIcon)
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:Place("BOTTOMRIGHT", Minimap, 1, -1)

MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:Place("TOPLEFT", Minimap, "TOPLEFT")

local function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:Place("TOPRIGHT", Minimap, "TOPRIGHT", 0, -3)
end

hooksecurefunc("MiniMapLFG_UpdateIsShown", UpdateLFG)
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = CHARACTER_BUTTON,
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = SPELLBOOK_ABILITIES_BUTTON,
    func = function() ShowUIPanel(SpellBookFrame) end},
    {text = TALENTS_BUTTON,
    func = function() ToggleTalentFrame() end},
    {text = ACHIEVEMENT_BUTTON,
    func = function() ToggleAchievementFrame() end},
    {text = QUESTLOG_BUTTON,
    func = function() ToggleFrame(QuestLogFrame) end},
    {text = SOCIAL_BUTTON,
    func = function() ToggleFriendsFrame(1) end},
    {text = PLAYER_V_PLAYER,
    func = function() ToggleFrame(PVPParentFrame) end},
    {text = LFG_TITLE,
    func = function() ToggleFrame(LFDParentFrame) end},
    {text = L_LFRAID,
    func = function() ToggleFrame(LFRParentFrame) end},
    {text = HELP_BUTTON,
    func = function() ToggleHelpFrame() end},
    {text = L_CALENDAR,
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
}

Minimap:SetScript("OnMouseUp", function(self, btn)
	if btn == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
	elseif btn == "MiddleButton" then
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		Minimap_OnClick(self)
	end
end)