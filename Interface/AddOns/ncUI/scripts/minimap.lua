local F, C = select(2, ...):Fetch()

local bg = F:CreateFrame("Panel", "MapBorder", Minimap)
bg:SetSize(145)
bg:SetPoint("TOPLEFT", -2, 2)
bg:SetPoint("BOTTOMRIGHT", 2, -2)
F:SetToolbox(Minimap)
Minimap:SetMaskTexture(C.media.mask)
Minimap:SetFrameStrata("BACKGROUND")
Minimap:ClearAllPoints()
Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -13, -13)
Minimap:SetSize(111)

MinimapBorder:Hide()
MinimapBorderTop:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

F:Destroy(MiniMapVoiceChatFrame)
F:Destroy(DurabilityFrame)
F:Destroy(MinimapZoneTextButton)
F:Destroy(MiniMapTracking)
F:Destroy(MinimapNorthTag)
F:Destroy(MiniMapWorldMapButton)

GameTimeFrame:Hide()
MiniMapMailBorder:Hide()
MiniMapMailIcon:SetTexture(C.media.mail)
MiniMapMailIcon:ClearAllPoints()
MiniMapMailIcon:SetPoint("BOTTOMLEFT", Minimap, F:Scale(3), 0)
MiniMapMailFrame:SetAllPoints(MiniMapMailIcon)
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("BOTTOMRIGHT", Minimap, F:Scale(1), F:Scale(-1))

MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT")

local function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, F:Scale(-3))
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
Minimap:SetScript("OnMouseUp", function(self, btn)
	if btn == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
	elseif btn == "MiddleButton" then
		GameTimeFrame:Click() 
	else
		Minimap_OnClick(self)
	end
end)
