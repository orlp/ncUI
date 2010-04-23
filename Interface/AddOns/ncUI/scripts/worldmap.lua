local F, C = select(2, ...):Fetch()
if not C.worldmap.enable or IsAddOnLoaded("Mapster") then return end

WORLDMAP_RATIO_MINI, WORLDMAP_WINDOWED_SIZE = 1, 1 -- else pixelperfectness gets screwed up, just like font sizes

local mapbg = F:CreateFrame("Panel", nil, WorldMapDetailFrame)
local movebutton = F:CreateFrame("Frame", nil, WorldMapFrameCloseButton)
movebutton:Size(25)
movebutton:SetPoint("TOP", WorldMapFrameCloseButton, "BOTTOM", -1, 2)
movebutton:SetBackdrop{bgFile=C.media.cross}

local addon = F:CreateFrame("Frame")
addon:RegisterEvent("PLAYER_LOGIN")
addon:RegisterEvent("PARTY_MEMBERS_CHANGED")
addon:RegisterEvent("RAID_ROSTER_UPDATE")
addon:RegisterEvent("PLAYER_REGEN_ENABLED")
addon:RegisterEvent("PLAYER_REGEN_DISABLED")

SetCVar("miniWorldMap", 1)
SetCVar("advancedWorldMap", 1)

hooksecurefunc("WorldMap_ToggleSizeDown", function()
	WorldMapBlobFrame:Destroy()
	WorldMapFrameSizeUpButton:Destroy() -- NO SIZING UP MWUHAHAHAA
	
	-- new frame to put zone and title text in
	local ald = CreateFrame ("Frame", nil, WorldMapButton)
	ald:SetFrameStrata("TOOLTIP")
	
	mapbg:SetPoint("TOPLEFT", WorldMapDetailFrame, -2, 2)
	mapbg:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, 2, -2)
	mapbg:SetFrameStrata("MEDIUM")
	mapbg:SetFrameLevel(20)

	-- move buttons / texts and hide default border
	WorldMapButton:SetAllPoints(WorldMapDetailFrame)

	WorldMapFrame:SetFrameStrata("MEDIUM")
	WorldMapFrame:SetClampedToScreen(true) 
	WorldMapDetailFrame:SetFrameStrata("MEDIUM")
	
	WorldMapTitleButton:Show()	

	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()
	
--	F:SetToolbox(WorldMapFrameCloseButton, WorldMapQuestShowObjectives, WorldMapQuestShowObjectivesText, WorldMapFrameTitle)
	
	WorldMapFrameCloseButton:ClearAllPoints()
	WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, 3)
	WorldMapFrameCloseButton:SetFrameStrata("HIGH")
	
	WorldMapQuestShowObjectives:SetParent(ald)
	WorldMapQuestShowObjectives:ClearAllPoints()
	WorldMapQuestShowObjectives:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, -1)
	
	WorldMapQuestShowObjectivesText:SetFontObject("ncUIfont")
	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint("RIGHT", WorldMapQuestShowObjectives, "LEFT", -4, 1)
	
	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, 9, 5)
	WorldMapFrameTitle:SetFontObject("ncUIfont")
	WorldMapFrameTitle:SetParent(ald)

	WorldMapTitleButton:SetFrameStrata("TOOLTIP")
	WorldMapTooltip:SetFrameStrata("TOOLTIP")
	
	-- 3.3.3, hide the dropdown added into this patch
	WorldMapLevelDropDown:SetAlpha(0)
	WorldMapLevelDropDown:SetScale(0.0001)

	-- fix tooltip not hidding after leaving quest # tracker icon
	WorldMapQuestPOI_OnLeave = function()
		WorldMapTooltip:Hide()
	end
end)

local function OnMouseDown()
	WorldMapScreenAnchor:ClearAllPoints()
	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:StartMoving() 
end

local function OnMouseUp()
	WorldMapFrame:StopMovingOrSizing()
	WorldMapScreenAnchor:StartMoving()
	WorldMapScreenAnchor:SetPoint("TOPLEFT", WorldMapFrame)
	WorldMapScreenAnchor:StopMovingOrSizing()
end

movebutton:EnableMouse(true)
movebutton:SetScript("OnMouseDown", OnMouseDown)
movebutton:SetScript("OnMouseUp", OnMouseUp)

local function UpdateIconColor(self, t)
	color = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
	self.icon:SetVertexColor(color.r, color.g, color.b)
end

addon:SetScript("OnEvent", function()
	for r=1, MAX_RAID_MEMBERS do
		if UnitInParty(_G["WorldMapRaid"..r].unit) then
			_G["WorldMapRaid"..r].icon:SetTexture([[Interface\AddOns\ncUI\media\party]])
		else
			_G["WorldMapRaid"..r].icon:SetTexture([[Interface\AddOns\ncUI\media\raid]])
		end
		_G["WorldMapRaid"..r]:SetScript("OnUpdate", UpdateIconColor)
	end

	for p=1, MAX_PARTY_MEMBERS do
		_G["WorldMapParty"..p].icon:SetTexture([[Interface\AddOns\ncUI\media\party]])
		_G["WorldMapParty"..p]:SetScript("OnUpdate", UpdateIconColor)
	end
end)

local function hide(f)
	f:SetTexture()
	f.SetTexture = function() end
end

hooksecurefunc("LoadAddOn", function(addon)
	if addon ~= "Blizzard_BattlefieldMinimap" then return end
	BattlefieldMinimap:SetScale(F.PP*.99)
	BattlefieldMinimap:ClearAllPoints()
	BattlefieldMinimap:SetPoint("TOPRIGHT", MinimapStatsRight, "BOTTOMRIGHT", 55, -4/BattlefieldMinimap:GetEffectiveScale())
	
	local bg = F:CreateFrame("Panel", nil, UIParent)
	bg:SetFrameLevel(0)
	bg:SetFrameStrata("BACKGROUND")
	bg:SetPoint("TOPLEFT", BattlefieldMinimap2, -2, 2)
	bg:Size(115, 149)
	
	bg:RegisterEvent("PLAYER_LOGIN")
	bg:RegisterEvent("PARTY_MEMBERS_CHANGED")
	bg:RegisterEvent("RAID_ROSTER_UPDATE")
	bg:RegisterEvent("PLAYER_REGEN_ENABLED")
	bg:RegisterEvent("PLAYER_REGEN_DISABLED")
	
	bg:SetScript("OnEvent", function()
		for r=1, MAX_RAID_MEMBERS do
			if UnitInParty(_G["WorldMapRaid"..r].unit) then
				_G["BattlefieldMinimapRaid"..r].icon:SetTexture([[Interface\AddOns\ncUI\media\raid]])
			else
				_G["BattlefieldMinimapRaid"..r].icon:SetTexture([[Interface\AddOns\ncUI\media\raid]])
			end
			_G["BattlefieldMinimapRaid"..r]:SetScript("OnUpdate", UpdateIconColor)
			_G["BattlefieldMinimapRaid"..r]:Size(F:Scale(6), F:Scale(6))
		end

		for p=1, MAX_PARTY_MEMBERS do
			_G["BattlefieldMinimapParty"..p].icon:SetTexture([[Interface\AddOns\ncUI\media\party]])
			_G["BattlefieldMinimapParty"..p]:SetScript("OnUpdate", UpdateIconColor)
			_G["BattlefieldMinimapParty"..p]:Size(F:Scale(6), F:Scale(6))
		end
	end)
	
	bg:GetScript("OnEvent")()
	
	hide(BattlefieldMinimap1)
	hide(BattlefieldMinimap4)
	hide(BattlefieldMinimap5)
	hide(BattlefieldMinimap8)
	hide(BattlefieldMinimap9)
	hide(BattlefieldMinimap12)
	BattlefieldMinimapBackground:Hide()
	BattlefieldMinimapCorner:Destroy()
	BattlefieldMinimapCloseButton:Destroy()
	BattlefieldMinimapTab:Destroy()
end)