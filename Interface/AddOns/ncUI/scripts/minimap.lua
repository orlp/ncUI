local db = ncUIdb["minimap"]
local function kill() end

local p = CreateFrame("Frame", "MapBorder", Minimap)
ncUIdb:CreatePanel(p, 145, 145, "CENTER", Minimap, "CENTER", 0, 0)
p:ClearAllPoints()
p:SetPoint("TOPLEFT", ncUIdb:Scale(-4), ncUIdb:Scale(4))
p:SetPoint("BOTTOMRIGHT", ncUIdb:Scale(3), ncUIdb:Scale(-3))
Minimap:SetMaskTexture(ncUIdb["media"].mask)
Minimap:SetFrameStrata("BACKGROUND")
Minimap:ClearAllPoints()
Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -15, -15)
Minimap:SetWidth(95/ncUIdb["general"].uiscale)
Minimap:SetHeight(95/ncUIdb["general"].uiscale)
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
--[[
for i = 1,3 do
	local f = CreateFrame("Frame", "MinimapMovingObject"..i, Minimap)
	f:SetBackdrop( { 
		bgFile = ncUIdb["media"].solid, 
		edgeFile = ncUIdb["media"].solid, 
		tile = false, tileSize = 0, edgeSize = ncUIdb:Scale(3),
		insets = { left = ncUIdb:Scale(-1), right = ncUIdb:Scale(-1), top = ncUIdb:Scale(-1), bottom = ncUIdb:Scale(-1) }
	})
	f:SetBackdropBorderColor(unpack(ncUIdb["general"].colorscheme_border))
	f:SetBackdropColor(unpack(ncUIdb["general"].colorscheme_backdrop))
	f:SetFrameStrata("BACKGROUND")
	f:SetFrameLevel(1)
	f.elapsed = 0
	f.method = 1
	f.mult = db.speed
	if i==2 then
		f:SetHeight(4)
		f:SetWidth(16)
	else
		f:SetHeight(16)
		f:SetWidth(4)
	end
	f:SetScript("OnUpdate", function(self, elapsed)
		if self.mult==0 then self:Hide() return end
		self.elapsed = self.elapsed + floor(elapsed*self.mult*10000000)/10000000
		if self.elapsed > 120 then
			self.method = self.method + 1
			self.elapsed = 0
		end
		if self.method > 2 then
			self.method = 1
		end
		self:ClearAllPoints()
		if i==1 then
			if self.method == 1 then
				self:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -5, self.elapsed+2)
			else
				self:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -5, -self.elapsed-2)
			end
		elseif i==2 then
			if self.method == 1 then
				self:SetPoint("TOPLEFT", Minimap, "TOPLEFT", self.elapsed+2, 5)
			else
				self:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -self.elapsed-2, 5)
			end
		else
			if self.method == 1 then
				self:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 5, -self.elapsed-2)
			else
				self:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 5, self.elapsed+2)
			end
		end
	end)
	f:RegisterEvent("PLAYER_REGEN_DISABLED")
	f:RegisterEvent("PLAYER_REGEN_ENABLED")
	f:SetScript("OnEvent", function(self, event)
		if event=="PLAYER_REGEN_DISABLED" then
			self.mult = db.combatspeed
		else
			self.mult = db.speed
		end
	end)
end--]]