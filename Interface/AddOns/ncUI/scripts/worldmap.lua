local db = ncUIdb["worldmap"]
if not db.enable then return end

local function setup()
	f = WorldMapButton:CreateFontString(nil, "ARTWORK")
	f:SetFontObject("GameFontNormal")
	f:SetTextColor(1, 1, 1)
	return f
end
local p, c = setup(), setup()
p:SetPoint("BOTTOMLEFT", WorldMapButton, 0, -21)
c:SetPoint("BOTTOMRIGHT", WorldMapButton, -160, -21)

if db.showcoords then
	WorldMapButton:HookScript("OnUpdate", function(self, u)
		local PlayerX, PlayerY = GetPlayerMapPosition("player")
		PlayerX = math.floor(PlayerX*100*10+0.5)/10
		PlayerY = math.floor(PlayerY*100*10+0.5)/10
		p:SetText(PlayerX.." - "..PlayerY)
		local cX, cY = WorldMapDetailFrame:GetCenter()
		local CursorX, CursorY = GetCursorPosition()
		CursorX = math.floor((((CursorX/WorldMapFrame:GetScale())-(cX-(WorldMapDetailFrame:GetWidth()/2)))/10)*10+.05)/10
		CursorY = math.floor(((((cY+(WorldMapDetailFrame:GetHeight()/2))-(CursorY/WorldMapFrame:GetScale()))/WorldMapDetailFrame:GetHeight())*100)*10+.05)/10	
		if CursorX >= 100 or CursorY >= 100 or CursorX <= 0 or CursorY <= 0 then
			c:SetText("0 . 0")
		else
			c:SetText(CursorX.." - "..CursorY)
		end
	end)
end

WorldMapFrame:EnableKeyboard(false)
WorldMapFrame:EnableMouse(false)

BlackoutWorld:Hide()
BlackoutWorld.Show = function() end
UIPanelWindows["WorldMapFrame"] = {area = "center"}
WorldMapFrame:HookScript("OnShow", function(self) self:SetScale(db.scale) end)
WorldMapFrameSizeDownButton:Disable()
WorldMapFrameSizeDownButton:SetAlpha(.1)