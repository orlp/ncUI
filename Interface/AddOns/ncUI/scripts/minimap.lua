local db = ncUIdb["minimap"]
local function kill() end

local p = CreateFrame("Frame", "MapBorder", Minimap)
ncUIdb:CreatePanel(p, 145, 145, "CENTER", Minimap, "CENTER", 0, 0)
p:ClearAllPoints()
p:SetPoint("TOPLEFT", ncUIdb:Scale(-2), ncUIdb:Scale(2))
p:SetPoint("BOTTOMRIGHT", ncUIdb:Scale(2), ncUIdb:Scale(-2))
Minimap:SetMaskTexture(ncUIdb["media"].mask)
Minimap:SetFrameStrata("BACKGROUND")
Minimap:ClearAllPoints()
Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", ncUIdb:Scale(-13), ncUIdb:Scale(-13))
Minimap:SetSize(ncUIdb:Scale(111), ncUIdb:Scale(111))
MinimapBorder:Hide()
MinimapBorderTop:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MiniMapVoiceChatFrame:Hide()
MiniMapVoiceChatFrame:UnregisterAllEvents()
MiniMapVoiceChatFrame.Show = kill
DurabilityFrame:Hide()
DurabilityFrame.Show = kill
GameTimeFrame:Hide()
MinimapZoneTextButton:Hide()
MinimapZoneTextButton:UnregisterAllEvents()
MiniMapTracking:Hide()
MiniMapTracking:UnregisterAllEvents()
MiniMapMailBorder:Hide()
MiniMapMailIcon:SetTexture(ncUIdb["media"].mail)
MiniMapMailIcon:ClearAllPoints()
MiniMapMailIcon:SetPoint("BOTTOMLEFT", Minimap, 3, 0)
MiniMapMailFrame:SetAllPoints(MiniMapMailIcon)
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("BOTTOMRIGHT", Minimap, 1, -1)
MinimapNorthTag.Show = kill
MinimapNorthTag:Hide()
MiniMapWorldMapButton:Hide()
MiniMapWorldMapButton:UnregisterAllEvents()
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
local function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, -3)
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