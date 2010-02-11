local db = ncUIdb["nameplates"]
local reactions = {}
for class, color in next, FACTION_BAR_COLORS do
	reactions[class] = {color.r, color.g, color.b}
end

local function GetClass(r, g, b)
	local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
	for class, color in pairs(RAID_CLASS_COLORS) do
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
			return class
		end
	end
	return 0
end
local function ClassIconTexCoord(r, g, b)
	class = GetClass(r,g,b)
	if not (class==0) then
		local texcoord = CLASS_BUTTONS[class]
		if (texcoord) then
			return unpack(texcoord)
		end
	end
	return 0.5, 0.75, 0.5, 0.75
end
local function isNamePlate(frame)
	if frame:GetName() then return end
	local overlayRegion = select(2, frame:GetRegions())
	return overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == "Interface\\Tooltips\\Nameplate-Border"
end

local function updateNameplate(frame)
	local r, g, b = frame.healthBar:GetStatusBarColor()
	frame.icon:SetTexCoord(ClassIconTexCoord(r, g, b))
	if g + b == 0 then
		r, g, b = unpack(reactions[1])
	elseif r + b == 0 then
		r, g, b = unpack(reactions[5])
	elseif r + g == 0 then
		r, g, b = 0, .3, .6
	elseif 2 - (r + g) < 0.05 and b == 0 then
		r, g, b = unpack(reactions[4])
	end 
	
	frame.healthBar:SetStatusBarColor(r, g, b)
	frame.r, frame.g, frame.b = r, g, b

	frame.healthBar:ClearAllPoints()
	frame.healthBar:SetPoint("CENTER", frame.healthBar:GetParent())
	frame.healthBar:SetHeight(7)
	frame.healthBar:SetWidth(100)
	
	frame.levelText:ClearAllPoints()
	frame.levelText:SetPoint("RIGHT", frame.healthBar, "LEFT", -2, 0)
	
	frame.castBar:ClearAllPoints()
	frame.castBar:SetPoint("TOPLEFT", frame.healthBar, "BOTTOMLEFT", 0, -1.5)
	frame.castBar:SetPoint("TOPRIGHT", frame.healthBar, "BOTTOMRIGHT", 0, -1.5)
	frame.castBar:SetPoint("BOTTOM", frame.healthBar, "BOTTOM", 0, -5)
	
	local r, g, b = frame.levelText:GetTextColor()
	frame.nameText:SetText(frame.nameText:GetText())
	
end

local function styleNameplate(frame)
	if frame.styled then return end
	
	frame.healthBar, frame.castBar = frame:GetChildren()
	local healthBar, castBar = frame.healthBar, frame.castBar
	local glowRegion, overlayRegion, castbarOverlay, shieldedRegion, spellIconRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()
	
	frame.levelText = levelTextRegion
	frame.nameText = nameTextRegion
	
	healthBar:SetStatusBarTexture(db.texture)
	healthBar.bg = healthBar:CreateTexture(nil, "BORDER")
	healthBar.bg:SetAllPoints(healthBar)
	healthBar.bg:SetTexture(db.texture)
	healthBar.bg:SetVertexColor(.15, .15, .15)
	
	levelTextRegion:SetFont(db.font, db.fontsize, db.flags)
	levelTextRegion:SetShadowOffset(0, 0)
	levelTextRegion:ClearAllPoints()
	levelTextRegion:SetPoint("RIGHT", healthBar, "LEFT", -2, 0)
	
	local classicontexture = frame:CreateTexture(nil, "OVERLAY")
	classicontexture:SetPoint("BOTTOM", healthBar, "TOP", 0, 10)
	classicontexture:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
	classicontexture:SetWidth(40)
	classicontexture:SetHeight(40)
	frame.icon = classicontexture
	
	castBar:SetStatusBarTexture(db.texture)
	castBar.bg = castBar:CreateTexture(nil, "BORDER")
	castBar.bg:SetAllPoints(castBar)
	castBar.bg:SetTexture(db.texture)
	castBar.bg:SetVertexColor(.15, .15, .15)
	
	nameTextRegion:SetFont(db.font, db.fontsize, db.flags)
	nameTextRegion:SetShadowOffset(0, 0)
	nameTextRegion:ClearAllPoints()
	nameTextRegion:SetPoint("BOTTOM", healthBar, "TOP", 0, 2)
	
	spellIconRegion:ClearAllPoints()
	spellIconRegion:SetPoint("TOPLEFT", healthBar, "TOPRIGHT", 1.2, 0)
	spellIconRegion:SetTexCoord(.08, .92, .08, .92)
	spellIconRegion:SetHeight(12)
	spellIconRegion:SetWidth(12)
	
	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	stateIconRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)
	highlightRegion:SetTexture(nil)
	
	frame.styled = true
	
	frame:SetScript("OnShow", updateNameplate)
	updateNameplate(frame)
	
	frame.update = 0
	frame:SetScript("OnUpdate", function(frame, u)
		frame.update = frame.update + u
		if frame.update > 1 then
			frame.healthBar:SetStatusBarColor(frame.r, frame.g, frame.b)
		end
	end)
end

local elapsed = 0
local OnUpdate = function(self, u)
	elapsed = elapsed + u
	if elapsed > 0.1 then
		elapsed = 0
		if WorldFrame:GetNumChildren() ~= children then
			children = WorldFrame:GetNumChildren()
			for i = 1, select("#", WorldFrame:GetChildren()) do
				local frame = select(i, WorldFrame:GetChildren())
				if isNamePlate(frame) then
					styleNameplate(frame)
				end
			end
		end
	end
end

local f = CreateFrame("Frame", nil, UIParent)
f:SetScript("OnUpdate", OnUpdate)