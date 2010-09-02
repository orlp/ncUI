local F, C = select(2, ...):Fetch()

local gt = GameTooltip
local unitExists, maxHealth

if not C.tooltip.enable then return end

local tooltips = {
	GameTooltip,
	ItemRefTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
	WorldMapTooltip
}

for i=1, #tooltips do
	tooltips[i]:SetBackdrop(F.BACKDROP)
	tooltips[i]:SetScript("OnShow", function(self) self:SetBackdropColor(unpack(C.general.backdrop)) self:SetBackdropBorderColor(unpack(C.general.border)) end)
end

-- Setup Anchor/Healthbar/Instanthide
local function update(self, ...)
	local owner = self:GetOwner()
	
	if self:GetAnchorType() == "ANCHOR_CURSOR" then
		return
	end
	
	-- Align World Units/Objects to mouse
	if owner == UIParent and not unitExists then
		self:ClearAllPoints()
		self:Place("TOP", UIParent, "TOP", 0, -12)
	end

	if not UnitExists("mouseover") and unitExists then
		self:Hide()
		unitExists = false
	end
end

-- Get Unit Name
local function unitName(unit)
	if not unit then return end
	local unitName		= UnitName(unit) or ""
	local Reaction		= UnitReaction(unit, "player") or 5
	local Attackable	= UnitCanAttack("player", unit)
	local Dead			= UnitIsDead(unit)
	local AFK			= UnitIsAFK(unit)
	local DND			= UnitIsDND(unit)
	local Tapped		= UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)
	
	if Attackable then
		if Tapped or Dead then
			return "|cff888888"..unitName.."|r"
		else
			if Reaction<4 then
				return "|cffff4444"..unitName.."|r"
			elseif Reaction == 4 then
				return "|cffffff44"..unitName.."|r"
			end
		end
	else
		if AFK then Status = " (AFK)" elseif DND then Status = " (DND)" elseif Dead then Status = " (Dead)" else Status = "" end
		if Reaction<4 then
			return "|cff3071bf"..unitName..Status.."|r"
		else
			return "|cffffffff"..unitName..Status.."|r"
		end
	end
end

-- Get Unit Information
local function unitInformation(unit)
	if not unit then return end
	local Race				= UnitRace(unit) or ""
	local Class, engClass 	= UnitClass(unit)
	local Classification	= UnitClassification(unit) or ""
	local creatureType		= UnitCreatureType(unit) or ""
	local PlayerLevel		= UnitLevel("player")
	local Level				= UnitLevel(unit) or ""
	local Player			= UnitIsPlayer(unit)
	local Difficulty		= GetQuestDifficultyColor(Level)
	local LevelColor		= string.format("%02x%02x%02x", Difficulty.r*255, Difficulty.g*255, Difficulty.b*255)
	
	if Level == -1 then
		Level = "??"
		LevelColor = "ff0000"
	end
	
	if Player then
		local Color = string.format("%02x%02x%02x", RAID_CLASS_COLORS[engClass].r*255, RAID_CLASS_COLORS[engClass].g*255, RAID_CLASS_COLORS[engClass].b*255)
		return "Level |cff"..LevelColor..Level.."|r |cff"..Color..Class.."|r "..Race
	else
		if Classification == "worldboss" then Type = " Boss" elseif
		Classification == "rareelite" then Type = " Rare Elite" elseif
		Classification == "rare" then Type = " Rare" elseif
		Classification == "elite" then Type = " Elite" else
		Type = "" end
		return "Level |cff"..LevelColor..Level.."|r"..Type.." "..creatureType
	end
end

-- Get Unit Guild
local function unitGuild(unit)
	local GuildName = GameTooltipTextLeft2:GetText()
	if GuildName and not GuildName:find("^Level") then
		return "<"..GuildName..">"
	else
		return nil
	end
end

-- Get Unit Target
local function unitTarget(unit)
	if UnitExists(unit.."target") then
		local mouseoverTarget, _ = UnitName(unit.."target")
		if mouseoverTarget == UnitName("Player") and not UnitIsPlayer(unit) then
			return "|cffff4444> TARGETTING YOU <|r"
		else 
			if UnitCanAttack("player", unit.."target") or UnitIsPlayer(unit.."target") then
			local Color = string.format("%02x%02x%02x", RAID_CLASS_COLORS[select(2, UnitClass(unit.."target"))].r*255, RAID_CLASS_COLORS[select(2, UnitClass(unit.."target"))].g*255, RAID_CLASS_COLORS[select(2, UnitClass(unit.."target"))].b*255)
				return "|cff"..Color..mouseoverTarget.."|r"
			else
				return "|cffffffff"..mouseoverTarget.."|r"
			end
		end
	else
		return nil
	end
end

-- Set Unit Tooltip
local function gtUnit(self, ...)
	-- Make sure the unit exists
	local _, unit = self:GetUnit()
	if not unit then return end
	
	unitExists = true
	
	-- Setup tooltip
	local gtUnitGuild, gtUnitTarget = unitGuild(unit), unitTarget(unit)
	local gtIdx, gtText = 1, {}
	GameTooltipTextLeft1:SetText(unitName(unit))
	
	if gtUnitGuild then
		GameTooltipTextLeft2:SetText(gtUnitGuild)
		GameTooltipTextLeft3:SetText(unitInformation(unit))
	else
		GameTooltipTextLeft2:SetText(unitInformation(unit))
	end

	for i = 1, self:NumLines() do
		local gtLine = _G["GameTooltipTextLeft"..i]
		local gtLineText = gtLine:GetText()
		if not (gtLineText and UnitIsPVP(unit) and gtLineText:find("^"..PVP_ENABLED)) then
			gtText[gtIdx] = gtLineText
			gtIdx = gtIdx + 1
		end
	end

	self:ClearLines()

	for i = 1, gtIdx - 1 do
		local line = gtText[i]
		if line then
			self:AddLine(line, 1, 1, 1, 1)
		end
	end

	if gtUnitTarget then
		self:AddLine(gtUnitTarget, 1, 1, 1, 1)
	end
end

local function default(tooltip, parent)		
	tooltip:SetOwner(parent, "ANCHOR_NONE")
	tooltip:Place("TOP", UIParent, "TOP", 0, -12)
end

gt:SetScript("OnUpdate", update)
gt:HookScript("OnTooltipSetUnit", gtUnit)
hooksecurefunc("GameTooltip_SetDefaultAnchor", default)
