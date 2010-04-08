local F, C = select(2, ...):Fetch()
local spellIds = {
	-- Death Knight
	[47481] = "CC",		-- Gnaw (Ghoul)
	[51209] = "CC",		-- Hungering Cold
	[47476] = "Silence",	-- Strangulate
	[45524] = "Snare",	-- Chains of Ice
	[55666] = "Snare",	-- Desecration (no duration, lasts as long as you stand in it)
	[58617] = "Snare",	-- Glyph of Heart Strike
	[50436] = "Snare",	-- Icy Clutch (Chilblains)
	-- Druid
	[5211]  = "CC",		-- Bash (also Shaman Spirit Wolf ability)
	[33786] = "CC",		-- Cyclone
	[2637]  = "CC",		-- Hibernate (works against Druids in most forms and Shamans using Ghost Wolf)
	[22570] = "CC",		-- Maim
	[9005]  = "CC",		-- Pounce
	[339]   = "Root",	-- Entangling Roots
	[19675] = "Root",	-- Feral Charge Effect (immobilize with interrupt [spell lockout, not silence])
	[58179] = "Snare",	-- Infected Wounds
	[61391] = "Snare",	-- Typhoon
	-- Hunter
	[60210] = "CC",		-- Freezing Arrow Effect
	[3355]  = "CC",		-- Freezing Trap Effect
	[24394] = "CC",		-- Intimidation
	[1513]  = "CC",		-- Scare Beast (works against Druids in most forms and Shamans using Ghost Wolf)
	[19503] = "CC",		-- Scatter Shot
	[19386] = "CC",		-- Wyvern Sting
	[34490] = "Silence",	-- Silencing Shot
	[53359] = "Disarm",	-- Chimera Shot - Scorpid
	[19306] = "Root",	-- Counterattack
	[19185] = "Root",	-- Entrapment
	[35101] = "Snare",	-- Concussive Barrage
	[5116]  = "Snare",	-- Concussive Shot
	[13810] = "Snare",	-- Frost Trap Aura (no duration, lasts as long as you stand in it)
	[61394] = "Snare",	-- Glyph of Freezing Trap
	[2974]  = "Snare",	-- Wing Clip
	-- Hunter Pets
	[50519] = "CC",		-- Sonic Blast (Bat)
	[50541] = "Disarm",	-- Snatch (Bird of Prey)
	[54644] = "Snare",	-- Froststorm Breath (Chimera)
	[50245] = "Root",	-- Pin (Crab)
	[50271] = "Snare",	-- Tendon Rip (Hyena)
	[50518] = "CC",		-- Ravage (Ravager)
	[54706] = "Root",	-- Venom Web Spray (Silithid)
	[4167]  = "Root",	-- Web (Spider)
	-- Mage
	[44572] = "CC",		-- Deep Freeze
	[31661] = "CC",		-- Dragon's Breath
	[12355] = "CC",		-- Impact
	[118]   = "CC",		-- Polymorph
	[18469] = "Silence",	-- Silenced - Improved Counterspell
	[64346] = "Disarm",	-- Fiery Payback
	[33395] = "Root",	-- Freeze (Water Elemental)
	[122]   = "Root",	-- Frost Nova
	[11071] = "Root",	-- Frostbite
	[55080] = "Root",	-- Shattered Barrier
	[11113] = "Snare",	-- Blast Wave
	[6136]  = "Snare",	-- Chilled (generic effect, used by lots of spells [looks weird on Improved Blizzard, might want to comment out])
	[120]   = "Snare",	-- Cone of Cold
	[116]   = "Snare",	-- Frostbolt
	[47610] = "Snare",	-- Frostfire Bolt
	[31589] = "Snare",	-- Slow
	-- Paladin
	[853]   = "CC",		-- Hammer of Justice
	[2812]  = "CC",		-- Holy Wrath (works against Warlocks using Metamorphasis and Death Knights using Lichborne)
	[20066] = "CC",		-- Repentance
	[20170] = "CC",		-- Stun (Seal of Justice proc)
	[10326] = "CC",		-- Turn Evil (works against Warlocks using Metamorphasis and Death Knights using Lichborne)
	[63529] = "Silence",	-- Shield of the Templar
	[20184] = "Snare",	-- Judgement of Justice (100% movement snare; druids and shamans might want this though)
	-- Priest
	[605]   = "CC",		-- Mind Control
	[64044] = "CC",		-- Psychic Horror
	[8122]  = "CC",		-- Psychic Scream
	[9484]  = "CC",		-- Shackle Undead (works against Death Knights using Lichborne)
	[15487] = "Silence",	-- Silence
	--[64058] = "Disarm",	-- Psychic Horror (duplicate debuff names not allowed atm, need to figure out how to support this later)
	[15407] = "Snare",	-- Mind Flay
	-- Rogue
	[2094]  = "CC",		-- Blind
	[1833]  = "CC",		-- Cheap Shot
	[1776]  = "CC",		-- Gouge
	[408]   = "CC",		-- Kidney Shot
	[6770]  = "CC",		-- Sap
	[1330]  = "Silence",	-- Garrote - Silence
	[18425] = "Silence",	-- Silenced - Improved Kick
	[51722] = "Disarm",	-- Dismantle
	[31125] = "Snare",	-- Blade Twisting
	[3409]  = "Snare",	-- Crippling Poison
	[26679] = "Snare",	-- Deadly Throw
	-- Shaman
	[39796] = "CC",		-- Stoneclaw Stun
	[51514] = "CC",		-- Hex (although effectively a silence+disarm effect, it is conventionally thought of as a "CC", plus you can trinket out of it)
	[64695] = "Root",	-- Earthgrab (Storm, Earth and Fire)
	[63685] = "Root",	-- Freeze (Frozen Power)
	[3600]  = "Snare",	-- Earthbind (5 second duration per pulse, but will keep re-applying the debuff as long as you stand within the pulse radius)
	[8056]  = "Snare",	-- Frost Shock
	[8034]  = "Snare",	-- Frostbrand Attack
	-- Warlock
	[710]   = "CC",		-- Banish (works against Warlocks using Metamorphasis and Druids using Tree Form)
	[6789]  = "CC",		-- Death Coil
	[5782]  = "CC",		-- Fear
	[5484]  = "CC",		-- Howl of Terror
	[6358]  = "CC",		-- Seduction (Succubus)
	[30283] = "CC",		-- Shadowfury
	[24259] = "Silence",	-- Spell Lock (Felhunter)
	[18118] = "Snare",	-- Aftermath
	[18223] = "Snare",	-- Curse of Exhaustion
	-- Warrior
	[7922]  = "CC",		-- Charge Stun
	[12809] = "CC",		-- Concussion Blow
	[20253] = "CC",		-- Intercept (also Warlock Felguard ability)
	[5246]  = "CC",		-- Intimidating Shout
	[12798] = "CC",		-- Revenge Stun
	[46968] = "CC",		-- Shockwave
	[18498] = "Silence",	-- Silenced - Gag Order
	[676]   = "Disarm",	-- Disarm
	[58373] = "Root",	-- Glyph of Hamstring
	[23694] = "Root",	-- Improved Hamstring
	[1715]  = "Snare",	-- Hamstring
	[12323] = "Snare",	-- Piercing Howl
	-- Other
	[30217] = "CC",		-- Adamantite Grenade
	[67769] = "CC",		-- Cobalt Frag Bomb
	[30216] = "CC",		-- Fel Iron Bomb
	[20549] = "CC",		-- War Stomp
	[25046] = "Silence",	-- Arcane Torrent
	[39965] = "Root",	-- Frost Grenade
	[55536] = "Root",	-- Frostweave Net
	[13099] = "Root",	-- Net-o-Matic
	[29703] = "Snare",	-- Dazed
}

local abilities = {}
for k, v in pairs(spellIds) do
	if v ~= "Snare" then
		local name = GetSpellInfo(k)
		if name then
			abilities[name] = v
		end
	end
end

local addon = F:CreateFrame("Cooldown", "ncUIPlayerLockdown", UIParent)
addon:SetPoint("CENTER", 0, -150)
addon:SetSize(71)
addon.noOCC = true
addon:Hide()
addon.texture = addon:CreateTexture(nil, "BORDER")
addon.texture:SetAllPoints(addon)
addon.texture:SetTexCoord(.08, .92, .08, .92)
addon:SetReverse(true)
addon.bg = F:CreateFrame("Panel", nil, addon)
addon.bg:SetPoint("TOPLEFT", -2, 2)
addon.bg:SetPoint("BOTTOMRIGHT", 2, -2)

function addon:OnEvent(event, ...) self[event](self, ...) end
addon:SetScript("OnEvent", addon.OnEvent)
addon:RegisterEvent("UNIT_AURA")

local WYVERN_STING = GetSpellInfo(19386)
local PSYCHIC_HORROR = GetSpellInfo(64058)
local UnitDebuff = UnitDebuff
local UnitBuff = UnitBuff
function addon:UNIT_AURA(unit)
	if unit ~= "player" then return end

	local maxexpire = 0
	local _, name, icon, Icon, duration, Duration, expire, wyvernsting

	for i = 1, 40 do
		name, _, icon, _, _, duration, expire = UnitDebuff("player", i)
		if not name then break end
		if name == WYVERN_STING then
			wyvernsting = 1
			if not self.wyvernsting then
				self.wyvernsting = 1
			elseif expire > self.wyvernsting_expire then
				self.wyvernsting = 2
			end
			self.wyvernsting_expire = expire
			if self.wyvernsting == 2 then
				name = nil
			end
		elseif name == PSYCHIC_HORROR and icon == "Interface\\Icons\\Ability_Warrior_Disarm" then
			name = nil
		end

		if abilities[name] and expire > maxexpire then
			maxexpire = expire
			Duration = duration
			Icon = icon
		end
	end

	if self.wyvernsting == 2 and not wyvernsting then
		self.wyvernsting = nil
	end

	if maxexpire == 0 then
		self.maxexpire = 0
		self:Hide()
	elseif maxexpire ~= self.maxexpire then
		self.maxexpire = maxexpire
		self.texture:SetTexture(Icon)
		self:Show()
		self:SetCooldown(maxexpire - Duration, Duration)
	end
end