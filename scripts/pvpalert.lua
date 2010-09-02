local ncSpellalert = CreateFrame("Frame", "ncSpellalert")	
local band, bor = bit.band, bit.bor
local enemy = bor(COMBATLOG_OBJECT_REACTION_HOSTILE, COMBATLOG_OBJECT_TYPE_PLAYER)
local deathcoil = GetSpellInfo(62904)
local HARMFUL_SPELLS, HEALING_SPELLS, BUFF_SPELLS
local special = {
	[GetSpellInfo(59752)] = 1, -- horde pvp trink
	[GetSpellInfo(42292)] = 1, -- ally
	[GetSpellInfo(7744)] = 2, -- wotf
	[GetSpellInfo(57073)] = 3, -- drink
}

local function isenemy(flags) return band(flags, enemy)==enemy end
local function createmessageframe(name)
	local f = CreateFrame("MessageFrame", name, UIParent)
	f:SetPoint("LEFT", UIParent)
	f:SetPoint("RIGHT", UIParent)
	f:Size(25)
	f:SetInsertMode("TOP")
	f:SetFrameStrata("HIGH")
	f:SetTimeVisible(1)
	f:SetFadeDuration(3)
	f:SetFont(STANDARD_TEXT_FONT, 23, "OUTLINE")
	return f
end

local spell = createmessageframe("SpellAlertFrame")
local buff = createmessageframe("BuffAlertFrame")
local detect = createmessageframe("DetectEnemyFrame")
detect:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 0, -10)
buff:SetPoint("TOP", detect, "BOTTOM", 0, -2)
spell:SetPoint("TOP", buff, "BOTTOM", 0, -2)

function ncSpellalert:PLAYER_LOGIN()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:ZONE_CHANGED_NEW_AREA()
	self:UnregisterEvent("PLAYER_LOGIN")
end

local function announce(str)
	if GetZonePVPInfo()=="arena" then
		if UnitInParty("player") then
			SendChatMessage(str, "PARTY")
		else
			SendChatMessage(str, "BATTLEGROUND")
		end
	end
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
	if eventType == "SPELL_AURA_APPLIED" and BUFF_SPELLS[spellname] and isenemy(destFlags) then
		buff:AddMessage(format(ACTION_SPELL_AURA_APPLIED_BUFF_FULL_TEXT_NO_SOURCE, nil, "|cff00ff00"..spellname.."|r", nil, destname))
		announce(format(ACTION_SPELL_AURA_APPLIED_BUFF_FULL_TEXT_NO_SOURCE, nil, spellname, nil, destname))
	elseif eventType == "SPELL_CAST_START" and isenemy(sourceFlags) then
		local color		
		
		if HARMFUL_SPELLS[spellname] then
			color = "ff0000"
		elseif HEALING_SPELLS[spellname] then
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
			spell:AddMessage(format(template, sourcename, "|cff"..color..spellname.."|r", nil, destname))
			announce(format(template, sourcename, spellname, nil, destname))
		end
	end
end

function ncSpellalert:UNIT_SPELLCAST_SUCCEEDED(event, unit, spell, rank)
	event = special[spell]
	if event and UnitIsEnemy("player", unit) then
		if event == 1 then
			buff:AddMessage(format("%s used a |cff00ff00PvP trinket|r.", UnitName(unit)))
			announce(format("%s used a PvP trinket.", UnitName(unit)))
		elseif event == 2 then	
			buff:AddMessage(format("%s used |cff00ff00Will of the Forsaken|r.", UnitName(unit)))
			announce(format("%s used Will of the Forsaken.", UnitName(unit)))
		elseif event == 3 then
			buff:AddMessage(format("%s is drinking.", UnitName(unit)))
			announce(format("%s is drinking.", UnitName(unit)))
		end
	end
end

ncSpellalert:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
ncSpellalert:RegisterEvent("PLAYER_LOGIN")

local holder = CreateFrame("Frame")
local throt = {}

holder:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
holder:SetScript("OnEvent", function(self, event, now, eventtype, sourceguid, sourcename, sourceflags, destguid, destname, destflags, spellid, spellname)
	if now - (throt[destguid] or 0) > 300 and isenemy(destflags) then
		throt[destguid] = now
		detect:AddMessage("|cFFFFFFFFEnemy detected: |r"..destname, 1, 0, 0)
	end
	if now - (throt[sourceguid] or 0) > 300 and isenemy(sourceflags) then
		throt[sourceguid] = now
		detect:AddMessage("|cFFFFFFFFEnemy detected: |r"..sourcename, 1, 0, 0)
	end
end)

HARMFUL_SPELLS = {
	-- Priest
	[GetSpellInfo(605)] = 1, -- Mind Control
	[GetSpellInfo(13704)] = 1, -- Psychic Scream
	[GetSpellInfo(11444)] = 1, -- Shackle Undead
	[GetSpellInfo(64044)] = 1, -- Psychic Horror
	[GetSpellInfo(8129)] = 1, -- Mana Burn

	-- Druid
	[GetSpellInfo(11922)] = 1, -- Entangling Roots
	[GetSpellInfo(33786)] = 1, -- Cyclone

	-- Deathknight
	[GetSpellInfo(47528)] = 1, -- Mind Freeze
	[GetSpellInfo(42650)] = 1, -- Army of the Dead
	[GetSpellInfo(47476)] = 1, -- Strangulate
	[GetSpellInfo(53570)] = 1, -- Hungering Cold

	-- Hunter
	[GetSpellInfo(3034)] = 1, -- Viper Sting
	[GetSpellInfo(34490)] = 1, -- Silencing Shot
	[GetSpellInfo(19503)] = 1, -- Scatter Shot

	-- Mage
	[GetSpellInfo(28285)] = 1, -- Polymorph
	[GetSpellInfo(11436)] = 1, -- Slow
	[GetSpellInfo(31687)] = 1, -- Summon Water Elemental
	[GetSpellInfo(36848)] = 1, -- Mirror Image

	-- Shaman
	[GetSpellInfo(39609)] = 1, -- Mana Tide Totem
	[GetSpellInfo(1350)] = 1, -- Feral Spirit

	-- Warlock
	[GetSpellInfo(30002)] = 1, -- Fear
	[GetSpellInfo(5484)] = 1, -- Howl of Terror
	[GetSpellInfo(6359)] = 1, -- Seduction
	[GetSpellInfo(24466)] = 1, -- Banish
	[GetSpellInfo(67931)] = 1, -- Death Coil
}

HEALING_SPELLS = {
	-- Priest
	[GetSpellInfo(27870)] = 1, -- Lightwell
	[GetSpellInfo(32375)] = 1, -- Mass Dispel
	[GetSpellInfo(35599)] = 1, -- Resurrection
	[GetSpellInfo(70619)] = 1, -- Divine Hymn
	[GetSpellInfo(64904)] = 1, -- Hymn of Hope

	-- Druid
	[GetSpellInfo(51918)] = 1, -- Revive
	[GetSpellInfo(35369)] = 1, -- Rebirth

	-- Paladin
	[GetSpellInfo(7328)] = 1, -- Redemption
	[GetSpellInfo(633)] = 1, -- Lay on Hands

	-- Shaman
	[GetSpellInfo(20609)] = 1, -- Ancestral Spirit

	-- Rogue
	[GetSpellInfo(21060)] = 1, -- Blind
	[GetSpellInfo(36563)] = 1, -- Shadowstep
	[GetSpellInfo(44521)] = 1, -- Preparation
}

BUFF_SPELLS = {
	-- Druid
	[GetSpellInfo(16810)] = 1, -- Nature's Grasp,
	[GetSpellInfo(17116)] = 1, -- Nature's Swiftness,
	[GetSpellInfo(22842)] = 1, -- Frenzied Regeneration,
	[GetSpellInfo(29166)] = 1, -- Innervate,
	[GetSpellInfo(53191)] = 1, -- Starfall,
	[GetSpellInfo(43317)] = 1, -- Dash,
	
	-- Death Knight
	[GetSpellInfo(50514)] = 1, -- Summon Gargoyle,
	[GetSpellInfo(58130)] = 1, -- Icebound Fortitude,
	[GetSpellInfo(49028)] = 1, -- Dancing Rune Weapon,
	[GetSpellInfo(55213)] = 1, -- Hysteria,
	
	-- Mage
	[GetSpellInfo(29976)] = 1, -- Presence of Mind,
	[GetSpellInfo(36911)] = 1, -- Ice Block,
	[GetSpellInfo(25641)] = 1, -- Frost Ward,
	[GetSpellInfo(37844)] = 1, -- Fire Ward,
	[GetSpellInfo(54160)] = 1, -- Arcane Power,
	[GetSpellInfo(11392)] = 1, -- Invisibility,
	[GetSpellInfo(28682)] = 1, -- Combustion,
	[GetSpellInfo(12472)] = 1, -- Icy Veins,
	
	-- Shaman
	[GetSpellInfo(6742)] = 1, -- Bloodlust,
	[GetSpellInfo(64701)] = 1, -- Elemental Mastery,
	[GetSpellInfo(23689)] = 1, -- Heroism,
	
	-- Warlock
	[GetSpellInfo(17941)] = 1, -- Shadow Trance,
	[GetSpellInfo(37673)] = 1, -- Metamorphosis,
	
	-- Rogue
	[GetSpellInfo(57840)] = 1, -- Killing Spree,
	[GetSpellInfo(28752)] = 1, -- Adrenaline Rush,
	[GetSpellInfo(33735)] = 1, -- Blade Flurry,
	[GetSpellInfo(51713)] = 1, -- Shadow Dance,
	[GetSpellInfo(61922)] = 1, -- Sprint,
	[GetSpellInfo(8822)] = 1, -- Stealth,
	[GetSpellInfo(15087)] = 1, -- Evasion,
	[GetSpellInfo(39666)] = 1, -- Cloak of Shadows,
	
	-- Warrior
	[GetSpellInfo(46924)] = 1, -- Bladestorm
	[GetSpellInfo(12976)] = 1, -- Last Stand
	[GetSpellInfo(13847)] = 1, -- Recklessness
	[GetSpellInfo(20240)] = 1, -- Retaliation
	[GetSpellInfo(15062)] = 1, -- Shield Wall
	[GetSpellInfo(12292)] = 1, -- Death Wish
	[GetSpellInfo(9943)] = 1, -- Spell Reflection

	-- Paladin
	[GetSpellInfo(43430)] = 1, -- Avenging Wrath
	[GetSpellInfo(66115)] = 1, -- Hand of Freedom
	[GetSpellInfo(41450)] = 1, -- Blessing of Protection
	[GetSpellInfo(13874)] = 1, -- Divine Shield
	[GetSpellInfo(13007)] = 1, -- Divine Protection
	[GetSpellInfo(6940)] = 1, -- Hand of Sacrifice
	[GetSpellInfo(54428)] = 1, -- Divine Plea

	-- Hunter
	[GetSpellInfo(31567)] = 1, -- Deterrence	
	[GetSpellInfo(34692)] = 1, -- The Beast Within

	-- Priest
	[GetSpellInfo(44416)] = 1, -- Pain Suppression
	[GetSpellInfo(37274)] = 1, -- Power Infusion
	[GetSpellInfo(47585)] = 1, -- Dispersion

	-- Racial
	[GetSpellInfo(69575)] = 1, -- Stoneform
	[GetSpellInfo(24378)] = 1, -- Berserking
}