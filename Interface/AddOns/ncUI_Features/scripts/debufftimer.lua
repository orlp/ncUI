--[[local bars, identifiers = {}, {}
local F, C = ncUI:Fetch()
local lib = ncUI:Fetch(5)
local function hex(r, g, b) if type(r) == "table" then if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end	end	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255) end
local function createbar(i)
	local f = F:CreateFrame("Panel", "DebuffTimerBar"..i, UIParent)
	f:Hide()

	f:Size(300, 18)

	f.bar = F:CreateFrame("StatusBar", nil, f)
	f.bar:SetStatusBarTexture(C.media.unitframe)
	f.bar:SetStatusBarColor(unpack(C.general.border))
	f.bar:SetPoint("TOPLEFT", 2, -2)
	f.bar:SetPoint("BOTTOMRIGHT", -2, 2)
	f.bar:SetMinMaxValues(0, 1)
	f.bar:SetFrameLevel(1)

	f.target = f.bar:CreateFontString(nil, "OVERLAY")
	f.target:SetFontObject("ncUIfont")
	f.target:SetPoint("RIGHT", -2, 1)
	f.target:SetJustifyH("RIGHT")

	f.spellname = f.bar:CreateFontString(nil, "OVERLAY")
	f.spellname:SetFontObject("ncUIfont")
	f.spellname:SetPoint("LEFT", 0, 1)
	f.spellname:SetPoint("RIGHT", f.target, "LEFT")

	f.iconbg = F:CreateFrame("Panel", nil, f)
	f.iconbg:Size(18, 18)
	f.iconbg:SetPoint("RIGHT", f, "LEFT", -7, 0)
	f.iconbg:SetFrameStrata("LOW")
	
	f.icon = f.iconbg:CreateTexture(nil, "OVERLAY")
	--F:SetToolbox(f.icon)
	f.icon:SetTexCoord(.08, .92, .08, .92)
	f.icon:SetPoint("TOPLEFT", f.iconbg, 2, -2)
	f.icon:SetPoint("BOTTOMRIGHT", f.iconbg, -2, 2)

	f.count = f:CreateFontString(nil, "OVERLAY")
	f.count:SetFontObject("ncUIfont")
	f.count:SetPoint("CENTER", f.icon, 0, -1)

	f.startcast = F:CreateFrame("StatusBar", nil, f)
	f.startcast:SetFrameLevel(2)
	f.startcast:SetStatusBarTexture(C.media.unitframe)
	f.startcast:SetStatusBarColor(0, 1, 0, .5)
	f.startcast:SetPoint("TOPLEFT", 2, -2)
	f.startcast:SetPoint("BOTTOMRIGHT", -2, 2)
	f.startcast:SetMinMaxValues(0, 1)
	
	f.time = f.startcast:CreateFontString(nil, "OVERLAY")
	f.time:SetFontObject("ncUIfont")
	f.time:SetPoint("LEFT", 5, 1)

	function f:SetSettings(unit, name, spellname, icon, count, debufftype, expire, duration, spell, casttime)		
		self.unit = unit
		self.expire = expire
		self.duration = duration
		self.spell = spell
		self.debufftype = debufftype
		self.casttime = casttime

		local color = DebuffTypeColor[debufftype] or DebuffTypeColor.none
		self.bar:SetStatusBarColor(color.r, color.g, color.b)		
		self.spellname:SetText(spellname)
		self.target:SetText(name)
		self.icon:SetTexture(icon)
		local count = tonumber(count)
		if count and count > 1 then self.count:SetText(count) else self.count:SetText(nil) end

		if casttime then
			self.startcast:SetValue(casttime/duration*1e-3)
		end

		if not identifiers[unit] then
			identifiers[unit] = {}
		end
		identifiers[unit][spell] = i

		self:Show()
	end

	function f:GetSettings(bar)
		return self.unit,
		self.target:GetText(),
		self.spellname:GetText(),
		self.icon:GetTexture(),
		(self.count:GetText() or 1),
		self.debufftype,
		self.expire,
		self.duration,
		self.spell,
		self.casttime
	end

	function f:WipeSettings()
		self.unit = nil
		self.expire = nil
		self.duration = nil
		self.spell = nil
	end

	function f:Stop()
		if not self.spell then return end

		local unit = identifiers[self.unit]
		if unit and unit[self.spell] == i then
			identifiers[self.unit][self.spell] = nil
		end

		for id = i, #bars do
			local nextbar = bars[id+1]
			if nextbar and nextbar.spell then
				bars[id]:SetSettings(nextbar:GetSettings())
			else
				bars[id]:WipeSettings()
				bars[id]:Hide()
			end
		end
	end

	f:SetScript("OnUpdate", function(self, elapsed)
		if not self.spell then self:Hide() return end

		local remaining = self.expire - GetTime()
		if remaining < 0 then self:Stop() return end
		
		self.time:SetText(format("%.1f", remaining))
		self.bar:SetValue(remaining/self.duration)
	end)
	
	if i==1 then
		f:SetPoint("BOTTOMLEFT", CubeLeftBG, "TOPLEFT", 25, 15) -- anchor
		f:SetPoint("RIGHT", InfoLeft)
	else
		f:SetPoint("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, 4) -- spacing and growth
		f:SetPoint("BOTTOMRIGHT", bars[i-1], "TOPRIGHT", 0, 4) -- spacing and growth
	end

	f.id = i
	bars[i] = f
	return f
end

local function getbar(expire)
	for i = 1, #bars do
		if not bars[i].spell then
			return bars[i]
		elseif bars[i].expire > expire then
			return bars[i]
		end
	end
	return createbar(#bars+1)
end

local function stop(unit, spell)
	local unit = identifiers[unit]
	if not unit or not unit[spell] then return end
	bars[unit[spell] ]:Stop()
	if identifiers[unit]==0 then identifiers[unit] = nil end
end

local function start(unit, spell, expire, duration, spellname, icon, count, name, debufftype, casttime)
	local exists = identifiers[unit]
	if exists and exists[spell] then
		stop(unit, spell)
	end
	local bar = getbar(expire)
	if bar.spell then
		local num = #bars
		for id = bar.id, num do
			local this = bars[bar.id+num-id]
			if this.spell then
				local nextbar = bars[bar.id+num-id+1] or createbar(bar.id+num-id+1)
				nextbar:SetSettings(this:GetSettings())
			end
		end
	end
	bar:SetSettings(unit, name, spellname, icon, count, debufftype, expire, duration, spell, casttime)
end

local player = UnitGUID("player")
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, target, spell, sourceguid, sourcename, sourceflags, destguid, destname, destflags, id)
	if event=="PLAYER_ALIVE" then player = UnitGUID("player") f:UnregisterEvent("PLAYER_ALIVE") end
	if spell=="SPELL_AURA_REMOVED" and sourceguid==player then
		lib:GetUnitID(destguid, function(unitid)
			local unitname = UnitName(unitid)
			local spellname, rank = GetSpellInfo(id)
			if not string.match(rank, "%d") then rank = nil end
			if not UnitDebuff(unitid, spellname, rank) then
				stop(destguid, id)
			end
		end)
	elseif spell=="UNIT_DIED" then
		local unit = identifiers[destguid]
		if unit then
			for spell, slot in pairs(unit) do
				stop(destguid, spell)
			end
		end
	elseif spell=="SPELL_AURA_APPLIED" or spell=="SPELL_AURA_REFRESH" and sourceguid==player and destguid~=player then
		lib:GetUnitID(destguid, function(unitid)
			local unitname = UnitName(unitid)
			local spellname, rank, _, _, _, _, casttime = GetSpellInfo(id)
			if not string.match(rank, "%d") then rank = nil end
			local name, _, icon, count, debufftype, duration, expires, caster, _, _, spell = UnitDebuff(unitid, spellname, rank)
			if caster=="player" then start(destguid, spell, expires, duration, name, icon, tonumber(count), unitname, debufftype, tonumber(casttime)) end
		end)
	end
end)
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:RegisterEvent("PLAYER_ALIVE")]]