--[[local bars, identifiers = {}, {}
local function hex(r, g, b) if type(r) == "table" then if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end	end	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255) end
local function sortbars(unit)
	local remain = {}
	for i = 1, #bars do
		local feed = bars[i].feed
		if feed then
			remain[i] = bars[i].feed
		end
	end
	local now = GetTime()
	table.sort(remain, function(a, b) return (a.expire - now) < (b.expire - now) end)
	for a, b in pairs(remain) do
		bars[a]:SetFeed(b)
	end
end

local function createbar(i)
	local f = CreateFrame("Frame", "DebuffTimerBar"..i, UIParent)
	f:Hide()

	f:SetHeight(ncUIdb:Scale(21))
	ncUIdb:SetTemplate(f)
	
	f.bar = CreateFrame("StatusBar", nil, f)
	f.bar:SetStatusBarTexture(ncUIdb["media"].unitframe)
	f.bar:SetStatusBarColor(unpack(ncUIdb["general"].colorscheme_border))
	f.bar:SetPoint("TOPLEFT", ncUIdb:Scale(3), ncUIdb:Scale(-3))
	f.bar:SetPoint("BOTTOMRIGHT", ncUIdb:Scale(-3), ncUIdb:Scale(3))
	f.bar:SetMinMaxValues(0, 1)
	
	f.time = f.bar:CreateFontString(nil, "OVERLAY")
	f.time:SetFont(ncUIdb["media"].pixelfont, 11, "THINOUTLINE")
	f.time:SetPoint("LEFT", 5, 0)
	
	f.target = f.bar:CreateFontString(nil, "OVERLAY")
	f.target:SetFont(ncUIdb["media"].pixelfont, 11, "THINOUTLINE")
	f.target:SetPoint("RIGHT", -2, 0)
	f.target:SetJustifyH("RIGHT")
	
	f.spell = f.bar:CreateFontString(nil, "OVERLAY")
	f.spell:SetFont(ncUIdb["media"].pixelfont, 11, "THINOUTLINE")
	f.spell:SetPoint("LEFT")
	f.spell:SetPoint("RIGHT", f.target, "LEFT")
	
	f.icon = f:CreateTexture(nil, "ARTWORK")
	f.icon:SetTexCoord(.08, .92, .08, .92)
	f.icon:SetHeight(ncUIdb:Scale(16))
	f.icon:SetWidth(ncUIdb:Scale(16))
	f.icon:SetPoint("RIGHT", f, "LEFT", -7, 0)
	
	f.iconbg = CreateFrame("Frame", nil, f)
	ncUIdb:SetTemplate(f.iconbg)
	f.iconbg:SetPoint("TOPLEFT", f.icon, ncUIdb:Scale(-3), ncUIdb:Scale(3))
	f.iconbg:SetPoint("BOTTOMRIGHT", f.icon, ncUIdb:Scale(3), ncUIdb:Scale(-3))
	f.iconbg:SetFrameStrata("LOW")
	
	f.count = f:CreateFontString(nil, "OVERLAY")
	f.count:SetFont(ncUIdb["media"].pixelfont, 11, "THINOUTLINE")
	f.count:SetPoint("CENTER", f.icon, 0, -1)
	
	function f:SetFeed(feed)
		self.feed = feed
		if not identifiers[feed.unit] then
			identifiers[feed.unit] = {}
		end
		identifiers[feed.unit][feed.spell] = i
		
		local color = DebuffTypeColor[feed.debufftype]
		
		self.bar:SetStatusBarColor(color.r, color.g, color.b)		
		self.target:SetText(feed.name)
		self.spell:SetText(feed.spellname)
		self.icon:SetTexture(feed.icon)
		if feed.count > 1 then
			self.count:SetText(feed.count)
		end		
		
		self:Show()
	end
	
	function f:Refresh(duration, expire)
		self.feed.duration = duration
		self.feed.expire = expire
	end
	
	function f:Stop()
		if not self.feed then return end
		
		local unit = identifiers[self.feed.unit]
		if unit and unit[self.feed.spell] == i then
			identifiers[self.feed.unit][self.feed.spell] = nil
		end
		
		for id = i, #bars do
			local nextbar = bars[id+1]
			if nextbar and nextbar.feed then
				bars[id]:SetFeed(nextbar.feed)
			else
				bars[id].feed = nil
				bars[id]:Hide()
			end
		end
	end

	f:SetScript("OnUpdate", function(self, elapsed)
		if not self.feed then self:Hide() return end

		local remaining = self.feed.expire - GetTime()
		if remaining < 0 then self:Stop() return end
		
		self.time:SetText(format("%.1f", remaining))
		self.bar:SetValue(remaining/self.feed.duration)
	end)
	
	if i==1 then
		f:SetPoint("BOTTOMLEFT", InfoRight, "TOPLEFT", 25, 5) -- anchor
		f:SetPoint("BOTTOMRIGHT", InfoRight, "TOPRIGHT", 0, 5)
	else
		f:SetPoint("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, ncUIdb:Scale(4)) -- spacing and growth
		f:SetPoint("BOTTOMRIGHT", bars[i-1], "TOPRIGHT", 0, ncUIdb:Scale(4)) -- spacing and growth
	end

	f.id = i
	bars[i] = f
	return i
end

local function getnewbar()
	for i = 1, #bars do
		if not bars[i].feed then return i end
	end
	return createbar(#bars+1)
end

local function start(unit, spell, expire, duration, spellname, icon, count, name, debufftype)
	local exists = identifiers[unit]
	if exists and exists[spell] then
		bars[exists[spell] ]:Refresh(duration, expire)
		return
	end
	
	local feed, bar = {}, getnewbar()
	feed.unit = unit
	feed.name = name
	feed.spellname = spellname
	feed.icon = icon
	feed.count = count
	feed.expire = expire
	feed.duration = duration
	feed.spell = spell
	feed.debufftype = debufftype
	feed.bar = bar

	bars[bar]:SetFeed(feed)
end

local function stop(unit, spell)
	local unit = identifiers[unit]
	if not unit or not unit[spell] then return end
	bars[unit[spell] ]:Stop()
	if identifiers[unit]==0 then identifiers[unit] = nil end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, target, spell, _, _, _, guid)
	local cache
	if event=="COMBAT_LOG_EVENT_UNFILTERED" then
		if spell=="UNIT_DIED" then
			cache = {}
		end
	else
		if target=="player" then return end
		local unit = UnitGUID(target)
		
		cache = {}
		
		for i = 1, 40 do
			local name, _, icon, count, debufftype, duration, expires, caster, _, _, spell = UnitDebuff(target, i)
			if caster=="player" then
				cache[spell] = true
				start(unit, spell, expires, duration, name, icon, count, UnitName(target), debufftype)
			end
		end
	end
	if cache then
		local guid = guid or UnitGUID(target)
		if identifiers[guid] then
			for spell, bar in pairs(identifiers[guid]) do
				if not cache[spell] then
					stop(guid, spell)
				end
			end
		end
		sortbars()
	end
end)
f:RegisterEvent("UNIT_AURA")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")-]]