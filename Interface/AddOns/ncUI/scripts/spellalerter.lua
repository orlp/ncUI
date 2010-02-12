if not ncUIdb["spellalerter"] then return end

local ncSpellalert = CreateFrame("Frame", "ncSpellalert")	
local band, bor = bit.band, bit.bor
local enemy = bor(COMBATLOG_OBJECT_REACTION_HOSTILE, COMBATLOG_OBJECT_TYPE_PLAYER)
local deathcoil = GetSpellInfo(62904)
local special = {
	[GetSpellInfo(59752)] = 1, -- horde pvp trink
	[GetSpellInfo(42292)] = 1, -- ally
	[GetSpellInfo(7744)] = 2, -- wotf
	[GetSpellInfo(57073)] = 3, -- drink
}
local function isenemy(flags) return band(flags, enemy)==enemy end
local function tohex(val) return string.format("%.2x", val) end
local function getclasscolor(class) local color = RAID_CLASS_COLORS[class] if not color then return "ffffff" end return tohex(color.r*255)..tohex(color.g*255)..tohex(color.b*255) end
local function colorize(name) if name then return "|cff"..getclasscolor(select(2,UnitClass(name)))..name.."|r" else return nil end end
local function createmessageframe(name)
	local f = CreateFrame("MessageFrame", name, UIParent)
	f:SetPoint("LEFT", UIParent)
	f:SetPoint("RIGHT", UIParent)
	f:SetHeight(25)
	f:SetInsertMode("TOP")
	f:SetFrameStrata("HIGH")
	f:SetTimeVisible(1)
	f:SetFadeDuration(3)
	f:SetFont(STANDARD_TEXT_FONT, 23, "OUTLINE")
	return f
end

local spell = createmessageframe("SpellAlertFrame")
spell:SetPoint("TOP", 0, -200)
local buff = createmessageframe("BuffAlertFrame")
buff:SetPoint("BOTTOM", spell, "TOP", 0, 2)

function ncSpellalert:PLAYER_LOGIN()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:ZONE_CHANGED_NEW_AREA()
	self:UnregisterEvent("PLAYER_LOGIN")
end

function ncSpellalert:ZONE_CHANGED_NEW_AREA()
	local pvp = GetZonePVPInfo()
	if not pvp or pvp ~= "sanctuary" then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	else
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	end
end

function ncSpellalert:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventType, sourceGUID, sourcename, sourceFlags, destGUID, destname, destFlags, spellid, spellname)
	if (spellname==deathcoil and select(2, UnitClass(sourceGUID))=="DEATHKNIGHT") or spellid == 59752 or spellid == 42292 or spellid == 7744 then return end -- ignores
	if eventType == "SPELL_AURA_APPLIED" and ncUIdb["spellalerter"].BUFF_SPELLS[spellname] and isenemy(destFlags) then
		buff:AddMessage(format(ACTION_SPELL_AURA_APPLIED_BUFF_FULL_TEXT_NO_SOURCE, nil, "|cff00ff00"..spellname.."|r", nil, colorize(destname)))
	elseif eventType == "SPELL_CAST_START" and isenemy(sourceFlags) then
		local color		
		
		if ncUIdb["spellalerter"].HARMFUL_SPELLS[spellname] then
			color = "ff0000"
		elseif ncUIdb["spellalerter"].HEALING_SPELLS[spellname] then
			color = "ffff00"
		end
		
		if color then
			local template
			if sourcename and destname then
				template = ACTION_SPELL_CAST_START_FULL_TEXT_NO_SOURCE
			elseif sourcename then
				template = ACTION_SPELL_CAST_START_FULL_TEXT_NO_DEST
			elseif destname then
				template = ACTION_SPELL_CAST_START_FULL_TEXT
			end
			spell:AddMessage(format(template, colorize(sourcename), "|cff"..color..spellname.."|r", nil, colorize(destname)))
		end
	end
end

function ncSpellalert:UNIT_SPELLCAST_SUCCEEDED(event, unit, spell, rank)
	event = special[spell]
	if event and UnitIsEnemy("player", unit) then
		if event == 1 then
			buff:AddMessage(format("%s used a |cff00ff00PvP trinket|r.", colorize(UnitName(unit))))
		elseif event == 2 then	
			buff:AddMessage(format("%s used |cff00ff00Will of the Forsaken|r.", colorize(UnitName(unit))))
		elseif event == 3 then
			buff:AddMessage(format("%s is drinking.", colorize(UnitName(unit))))
		end
	end
end

ncSpellalert:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
ncSpellalert:RegisterEvent("PLAYER_LOGIN")