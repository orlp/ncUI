local max = math.max
local floor = math.floor

local texture = [[Interface\AddOns\ncUI\media\unitframe]]
local backdrop = {
	bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
	insets = {top = ncUIdb:Scale(-1), bottom = ncUIdb:Scale(-1), left = ncUIdb:Scale(-1), right = ncUIdb:Scale(-1)}
}

local colors = setmetatable({
	power = setmetatable({
		MANA = {0, 144/255, 1}
	}, {__index = oUF.colors.power}),
	reaction = setmetatable({
		[2] = {1, 0, 0},
		[4] = {1, 1, 0},
		[5] = {0, 1, 0}
	}, {__index = oUF.colors.reaction}),
	runes = setmetatable({
		[1] = {0.8, 0, 0},
		[3] = {0, 0.4, 0.7},
		[4] = {0.8, 0.8, 0.8}
	}, {__index = oUF.colors.runes})
}, {__index = oUF.colors})

local bufffilter = {
	[GetSpellInfo(52610)] = true, -- Druid: Savage Roar
	[GetSpellInfo(22812)] = true, -- Druid: Barkskin
	[GetSpellInfo(16870)] = true, -- Druid: Clearcast
	[GetSpellInfo(50334)] = true, -- Druid: Berserk
	[GetSpellInfo(50213)] = true, -- Druid: Tiger"s Fury
	[GetSpellInfo(48517)] = true, -- Druid: Eclipse (Solar)
	[GetSpellInfo(48518)] = true, -- Druid: Eclipse (Lunar)
	[GetSpellInfo(57960)] = true, -- Shaman: Water Shield
	[GetSpellInfo(51566)] = true, -- Shaman: Tidal Waves (Talent)
	[GetSpellInfo(32182)] = true, -- Shaman: Heroism
	[GetSpellInfo(49016)] = true, -- Death Knight: Hysteria
}

local debufffilter = {
	[GetSpellInfo(770)] = true, -- Faerie Fire
	[GetSpellInfo(16857)] = true, -- Faerie Fire (Feral)
	[GetSpellInfo(48564)] = true, -- Mangle (Bear)
	[GetSpellInfo(48566)] = true, -- Mangle (Cat)
	[GetSpellInfo(46857)] = true, -- Trauma
}

local function menu(self)
	if(self.unit == "player") then
		ToggleDropDownMenu(1, nil, ncUIDropDown, "cursor")
	elseif(_G[string.gsub(self.unit, "(.)", string.upper, 1) .. "FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[string.gsub(self.unit, "(.)", string.upper, 1) .. "FrameDropDown"], "cursor")
	end
end

local function updatecombo(self, event, unit)
	if(unit == PlayerFrame.unit and unit ~= self.CPoints.unit) then
		self.CPoints.unit = unit
	end
end

local function updatepower(self, event, unit, bar, minVal, maxVal)
	if(unit ~= "target") then return end

	if(maxVal ~= 0) then
		self.Health:SetHeight(ncUIdb:Scale(36))
		bar:Show()
	else
		self.Health:SetHeight(ncUIdb:Scale(42))
		bar:Hide()
	end
end

local function casticon(self, event, unit)
	local castbar = self.Castbar
	if (castbar.interrupt) then
		castbar.Button:SetBackdropBorderColor(1, .5, 0)
	else
		castbar.Button:SetBackdropBorderColor(unpack(ncUIdb["general"].colorscheme_border))
	end
end

local function casttime(self, duration)
	if(self.channeling) then
		self.Time:SetFormattedText("%.1f ", duration)
	elseif(self.casting) then
		self.Time:SetFormattedText("%.1f ", self.max - duration)
	end
end

local function updatedebuff(self, icons, unit, icon, index)
	local name, _, _, _, dtype = UnitAura(unit, index, icon.filter)

	if(icon.debuff) then
		if(not debufffilter[name] and not UnitIsFriend("player", unit) and icon.owner ~= "player" and icon.owner ~= "vehicle") then
			icon:SetBackdropBorderColor(0, 0, 0)
			icon.icon:SetDesaturated(true)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			icon:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
			icon.icon:SetDesaturated(false)
		end
	end
end

local function createAura(self, button, icons)
	icons.showDebuffType = true
	
	--{button:GetRegions()}
	
	button.count:SetFont(ncUIdb["media"].pixelfont, ncUIdb:Scale(8))
	button.cd:SetAlpha(0)
	ncUIdb:SetTemplate(button)
	button.icon:SetPoint("TOPLEFT", ncUIdb:Scale(2), ncUIdb:Scale(-2))
	button.icon:SetPoint("BOTTOMRIGHT", ncUIdb:Scale(-2), ncUIdb:Scale(2))
	button.icon:SetTexCoord(.08, .92, .08, .92)
	button.icon:SetDrawLayer("ARTWORK")
	button.overlay:SetTexture()
end

local function customFilter(icons, unit, icon, name, rank, texture, count, dtype, duration, expiration, caster)
	if(bufffilter[name] and caster == "player") then
		return true
	end
end

local playercast
local function style(self, unit)
	self.colors = colors
	self.menu = menu

	self:RegisterForClicks("AnyUp")
	self:SetAttribute("type2", "menu")

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0)

	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetPoint("TOPRIGHT")
	self.Health:SetPoint("TOPLEFT")
	self.Health:SetStatusBarTexture(ncUIdb["media"].unitframe)
	self.Health:SetHeight(unit == "targettarget" and ncUIdb:Scale(32) or unit == "pet" and ncUIdb:Scale(20) or ncUIdb:Scale(36))
	self.Health.frequentUpdates = true
	
	self.Health.colorClass = true
	self.Health.colorReaction = true
	self.Health.colorTapping = true
	self.Health.colorDisconnected = true
	self.Health.colorSmooth = true
	self.Health.Smooth = true

	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture(ncUIdb["media"].unitframe)
	self.Health.bg:SetAlpha(.25)
	
	self.Health.bg.bg = self.Health:CreateTexture(nil, "BACKGROUND")
	self.Health.bg.bg:SetAllPoints(self.Health)
	self.Health.bg.bg:SetTexture(unpack(ncUIdb["general"].colorscheme_backdrop))

	local health = self.Health:CreateFontString(nil, "OVERLAY", "pfontright")
	health:SetPoint("RIGHT", self.Health, -2, 0)
	health.frequentUpdates = 0.25
	self:Tag(health, "[phealth]")

	self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	self.RaidIcon:SetPoint("TOP", self, 0, 8)
	self.RaidIcon:SetHeight(ncUIdb:Scale(10))
	self.RaidIcon:SetWidth(ncUIdb:Scale(10))
	
	if(unit == "focus") then
		self.Health:ClearAllPoints()
		self.Health:SetAllPoints(self)
	elseif unit == "targettarget" then
		self:SetAttribute("initial-height", ncUIdb:Scale(38))
		self:SetAttribute("initial-width", ncUIdb:Scale(155))
		
		self.Power = CreateFrame("StatusBar", nil, self)
		self.Power:SetPoint("BOTTOMRIGHT")
		self.Power:SetPoint("BOTTOMLEFT")
		self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -4)
		self.Power:SetStatusBarTexture(ncUIdb["media"].unitframe)
		self.Power.frequentUpdates = true

		--self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorPower = true
	
		self.Power:SetStatusBarColor(.31, .45, .63)

		self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
		self.Power.bg:SetAllPoints(self.Power)
		self.Power.bg:SetTexture([=[Interface\ChatFrame\ChatFrameBackground]=])
		self.Power.bg.multiplier = 0.3
		self.Power.bg:SetVertexColor(0, 0, 0)
	else
		self.Power = CreateFrame("StatusBar", nil, self)
		self.Power:SetPoint("BOTTOMRIGHT")
		self.Power:SetPoint("BOTTOMLEFT")
		self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -4)
		self.Power:SetStatusBarTexture(ncUIdb["media"].unitframe)
		self.Power.frequentUpdates = true

		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = unit == "pet"
		self.Power.colorPower = true
		self.Power.Smooth = true
	
		self.Power:SetStatusBarColor(.31, .45, .63)

		self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
		self.Power.bg:SetAllPoints(self.Power)
		self.Power.bg:SetTexture([=[Interface\ChatFrame\ChatFrameBackground]=])
		self.Power.bg.multiplier = 0.3
		self.Power.bg:SetVertexColor(0, 0, 0)
		
		if unit~="pet" then
			self.Castbar = CreateFrame("StatusBar", nil, self)
			self.Castbar:SetWidth(ncUIdb:Scale(301))
			self.Castbar:SetHeight(ncUIdb:Scale(40))
			self.Castbar:SetStatusBarTexture(ncUIdb["media"].unitframe)
			self.Castbar:SetStatusBarColor(unpack(ncUIdb["general"].colorscheme_border))

			self.Castbar.bg = CreateFrame("Frame", nil, self.Castbar)
			ncUIdb:SetTemplate(self.Castbar.bg)
			self.Castbar.bg:SetFrameLevel(1)
			self.Castbar.bg:SetPoint("TOPLEFT", -2, 3)
			self.Castbar.bg:SetPoint("BOTTOMRIGHT", 3, -2)

			self.Castbar.Text = self.Castbar:CreateFontString(nil, "OVERLAY", "pfontleft")
			self.Castbar.Text:SetPoint("LEFT", 5, 0)
			self.Castbar.Text:SetPoint("RIGHT", self.Castbar.Time)

			self.Castbar.Time = self.Castbar:CreateFontString(nil, "OVERLAY", "pfontright")
			self.Castbar.Time:SetPoint("RIGHT", -2, 0)
			self.Castbar.CustomTimeText = casttime

			self.Castbar.Button = CreateFrame("Frame", nil, self.Castbar)
			self.Castbar.Button:SetHeight(ncUIdb:Scale(46))
			self.Castbar.Button:SetWidth(ncUIdb:Scale(46))
			ncUIdb:SetTemplate(self.Castbar.Button)

			self.Castbar.Icon = self.Castbar.Button:CreateTexture(nil, "ARTWORK")
			self.Castbar.Icon:SetPoint("TOPLEFT", self.Castbar.Button, 3, -3)
			self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar.Button, -3, 3)
			self.Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, .92)
		end

		if unit=="player" then
			self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "OVERLAY")
			self.Castbar.SafeZone:SetTexture(ncUIdb["media"].unitframe)
			self.Castbar.SafeZone:SetVertexColor(1, 0, 0, .25)
			self.Castbar:SetPoint("BOTTOM", UIParent, "CENTER", -25, -300)
			self.Castbar.Button:SetPoint("BOTTOMLEFT", self.Castbar, "BOTTOMRIGHT", 7, -2)
			playercast = self.Castbar
		elseif(unit == "target") then
			self.PostCastStart = casticon
			self.PostChannelStart = casticon
			self.Castbar:SetPoint("TOP", playercast, "BOTTOM", 0, ncUIdb:Scale(-10))
			self.Castbar.Button:SetPoint("BOTTOMLEFT", self.Castbar, "BOTTOMRIGHT", 7, -2)
		end
	end

	if(unit == "player" or unit == "pet") then
		if(IsAddOnLoaded("oUF_Experience")) then
			self.Experience = CreateFrame("StatusBar", nil, self)
			self.Experience:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -10)
			self.Experience:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -10)
			self.Experience:SetHeight(11)
			self.Experience:SetStatusBarTexture(ncUIdb["media"].unitframe)
			self.Experience:SetStatusBarColor(0.15, 0.7, 0.1)
			self.Experience.Tooltip = true

			self.Experience.Rested = CreateFrame("StatusBar", nil, self)
			self.Experience.Rested:SetAllPoints(self.Experience)
			self.Experience.Rested:SetStatusBarTexture(ncUIdb["media"].unitframe)
			self.Experience.Rested:SetStatusBarColor(0, 0.4, 1, 0.6)
			self.Experience.Rested:SetBackdrop(backdrop)
			self.Experience.Rested:SetBackdropColor(0, 0, 0)

			self.Experience.Text = self.Experience:CreateFontString(nil, "OVERLAY", "pfont")
			self.Experience.Text:SetPoint("CENTER", self.Experience)

			self.Experience.bg = self.Experience.Rested:CreateTexture(nil, "BORDER")
			self.Experience.bg:SetAllPoints(self.Experience)
			self.Experience.bg:SetTexture(0.3, 0.3, 0.3)
		end

		local power = self.Health:CreateFontString(nil, "OVERLAY", "pfontleft")
		power:SetPoint("LEFT", self.Health, 2, 0)
		power.frequentUpdates = 0.1
		self:Tag(power, "[ppower][( )druidpower]")
	else
		local info = self.Health:CreateFontString(nil, "OVERLAY", "pfontleft")
		info:SetPoint("LEFT", self.Health, 2, 0)
		info:SetPoint("RIGHT", health, "LEFT")
		self:Tag(info, "[pname]|cff0090ff[( )rare]|r")
	end
	
	if unit~="focus" then
		local panel = CreateFrame("Frame", nil, self)
		ncUIdb:CreatePanel(panel, 1, 1, "TOPLEFT", self.Health, "TOPLEFT", -2, 2)
		panel:SetPoint("BOTTOMRIGHT", self.Power, ncUIdb:Scale(2), ncUIdb:Scale(-2))
		local panel2 = CreateFrame("Frame", nil, self.Power)
		ncUIdb:CreatePanel(panel2, 1, 1, "TOPLEFT", self.Power, "TOPLEFT", -2, 2)
		panel2:SetPoint("BOTTOMRIGHT", self.Power, ncUIdb:Scale(2), ncUIdb:Scale(-2))	
		panel2:SetFrameLevel(3)
		panel2:SetFrameStrata("MEDIUM")
		panel2:SetBackdrop{
			edgeFile = ncUIdb["media"].solid,
			tile = false, tileSize = 0, edgeSize = ncUIdb.mult,
		}
		panel2:SetBackdropBorderColor(unpack(ncUIdb["general"].colorscheme_border))
	end

	if(unit == "pet") then
		self:SetAttribute("initial-height", ncUIdb:Scale(26))
		self:SetAttribute("initial-width", ncUIdb:Scale(130))

		--[[self.Auras = CreateFrame("Frame", nil, self)
		self.Auras:SetPoint("TOPRIGHT", self, "TOPLEFT", -4, 0)
		self.Auras:SetHeight(4)
		self.Auras:SetWidth(256)
		self.Auras.size = 22
		self.Auras.spacing = 4
		self.Auras.initialAnchor = "TOPRIGHT"
		self.Auras["growth-x"] = "LEFT"
		self.PostCreateAuraIcon = createAura--]]
	end
	
	if(unit == "player" or unit == "target") then
		self:SetAttribute("initial-height", ncUIdb:Scale(42))
		self:SetAttribute("initial-width", ncUIdb:Scale(173))

		self.PostUpdatePower = updatepower
	end

	if(unit == "target") then
		self.Buffs = CreateFrame("Frame", nil, self)
		self.Buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", ncUIdb:Scale(-2), ncUIdb:Scale(5))
		self.Buffs:SetHeight(ncUIdb:Scale(17))
		self.Buffs:SetWidth(ncUIdb:Scale(174))
		self.Buffs.num = 9
		self.Buffs.size = ncUIdb:Scale(17)
		self.Buffs.spacing = ncUIdb:Scale(3)
		self.Buffs.initialAnchor = "TOPLEFT"
		self.Buffs["growth-y"] = "DOWN"
	
		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs:SetPoint("BOTTOMLEFT", self.Buffs, "TOPLEFT", 0, ncUIdb:Scale(3))
		self.Debuffs:SetHeight(ncUIdb:Scale(17))
		self.Debuffs:SetWidth(ncUIdb:Scale(230))
		self.Debuffs.num = 9
		self.Debuffs.size = ncUIdb:Scale(17)
		self.Debuffs.spacing = ncUIdb:Scale(3)
		self.Debuffs.initialAnchor = "TOPLEFT"
		self.Debuffs["growth-y"] = "DOWN"
		self.PostCreateAuraIcon = createAura
		self.PostUpdateAuraIcon = updatedebuff

		self.CPoints = self:CreateFontString(nil, "OVERLAY", "SubZoneTextFont")
		self.CPoints:SetPoint("RIGHT", self, "LEFT", -9, 0)
		self.CPoints:SetTextColor(1, 1, 1)
		self.CPoints:SetJustifyH("RIGHT")
		self.CPoints.unit = PlayerFrame.unit
		self:RegisterEvent("UNIT_COMBO_POINTS", updatecombo)
	end

	if(unit == "player") then
		if(select(2, UnitClass("player")) == "DEATHKNIGHT") then
			self.Runes = CreateFrame("Frame", nil, self.Power)
			self.Runes:SetPoint("TOPLEFT")
			self.Runes:SetHeight(ncUIdb:Scale(4))
			self.Runes:SetWidth(ncUIdb:Scale(174))
			self.Runes:SetBackdrop(backdrop)
			self.Runes:SetBackdropColor(0, 0, 0)
			self.Runes.anchor = "TOPLEFT"
			self.Runes.growth = "RIGHT"
			self.Runes.height = ncUIdb:Scale(3)
			self.Runes.spacing = ncUIdb.mult
			self.Runes.width = ncUIdb:Scale(168) / 6
			
			self.Health:SetHeight(ncUIdb:Scale(30))
			self.Power:SetHeight(ncUIdb:Scale(2))
			
			for index = 1, 6 do
				self.Runes[index] = CreateFrame("StatusBar", nil, self.Runes)
				self.Runes[index]:SetStatusBarTexture(ncUIdb["media"].unitframe)

				self.Runes[index].bg = self.Runes[index]:CreateTexture(nil, "BACKGROUND")
				self.Runes[index].bg:SetAllPoints(self.Runes[index])
				self.Runes[index].bg:SetTexture(.3, .3, .3)
			end
			
			local panel = CreateFrame("Frame", nil, self.Power)
			ncUIdb:CreatePanel(panel, 1, 1, "TOPLEFT", self.Power, "TOPLEFT", -2, 2)
			panel:SetPoint("BOTTOMRIGHT", self.Runes, ncUIdb:Scale(1), ncUIdb:Scale(-1))
			panel:SetFrameLevel(3)
			panel:SetFrameStrata("MEDIUM")
			panel:SetBackdrop{
				edgeFile = ncUIdb["media"].solid,
				tile = false, tileSize = 0, edgeSize = ncUIdb.mult,
			}
			panel:SetBackdropBorderColor(unpack(ncUIdb["general"].colorscheme_border))
			panel.bg = panel:CreateTexture(nil, "BACKGROUND")
			panel.bg:SetTexture(unpack(ncUIdb["general"].colorscheme_backdrop))
			panel.bg:SetPoint("TOPLEFT", panel)
			panel.bg:SetPoint("BOTTOMRIGHT", panel, ncUIdb:Scale(-2), ncUIdb:Scale(-1))
		end

		self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
		self.Leader:SetPoint("TOPLEFT", self, 0, 8)
		self.Leader:SetHeight(16)
		self.Leader:SetWidth(16)

		self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
		self.Assistant:SetPoint("TOPLEFT", self, 0, 8)
		self.Assistant:SetHeight(16)
		self.Assistant:SetWidth(16)

		local info = self.Health:CreateFontString(nil, "OVERLAY", "pfont")
		info:SetPoint("CENTER")
		info.frequentUpdates = 0.25
		self:Tag(info, "[pthreat]|cffff0000[( )pvptime]|r")

		self.CustomAuraFilter = customFilter
	end

	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true
end

oUF:RegisterStyle("ncUI", style)
oUF:SetActiveStyle("ncUI")

oUF:Spawn("player"):SetPoint("BOTTOMLEFT", ActionBarBackground, "TOPLEFT", ncUIdb:Scale(2), ncUIdb:Scale(6))
oUF:Spawn("target"):SetPoint("BOTTOMRIGHT", ActionBarBackground, "TOPRIGHT", ncUIdb:Scale(-2), ncUIdb:Scale(6))
oUF:Spawn("targettarget"):SetPoint("BOTTOM", ActionBarBackground, "TOP", 0, ncUIdb:Scale(6))
oUF:Spawn("pet"):SetPoint("BOTTOMLEFT", oUF.units.player, "TOPLEFT", 0, ncUIdb:Scale(6))

local focus = oUF:Spawn("focus")
focus:SetPoint("TOPLEFT", InfoRight, 2, -3)
focus:SetPoint("BOTTOMRIGHT", InfoRight, -3, 2)