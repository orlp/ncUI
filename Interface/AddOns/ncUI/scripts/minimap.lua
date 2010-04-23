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
Minimap:SetScript("OnMouseUp", function(self, btn)
	if btn == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
	elseif btn == "MiddleButton" then
		GameTimeFrame:Click() 
	else
		Minimap_OnClick(self)
	end
end)
