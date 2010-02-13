local feeds, bars, debuff, exists = {}, {}, {}, {}
local freeslot, freebar = 1, 1
local function hex(r, g, b) if type(r) == "table" then if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end	end	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255) end
local function stop(id)
	freebar = freebar - 1
	for i = id, 9 do
		local nextid = bars[i+1]:GetID()
		if nextid then
			bars[i]:SetID(nextid)
		else
			bars[i]:SetID(nil)
		end
	end
end
local function sortbars(unit)
	local remain = {}
	for i = 1, 10 do
		local id = bars[i]:GetID()
		remain[i] = id
	end
	table.sort(remain, function(a, b) return (feeds[a].expire - GetTime()) < (feeds[b].expire - GetTime()) end)
	for a, b in pairs(remain) do
		if b and feeds[b].spell and feeds[b].target==unit and not exists[feeds[b].spell] then
			stop(a)
			sortbars(unit)
			return
		end
		bars[a]:SetID(b)
	end
end
local function isbizzy(unit, spell)
	for i = 1, 10 do
		local id = bars[i]:GetID()
		if id and feeds[id].target == unit and feeds[id].spell == spell then
			return i
		end
	end
	return nil
end
local function start(target, spell, expire, duration, spellname, icon, count, name, debufftype)
	feeds[freeslot] = {}

	feeds[freeslot].target = target
	feeds[freeslot].name = name
	feeds[freeslot].spellname = spellname
	feeds[freeslot].icon = icon
	feeds[freeslot].count = count
	feeds[freeslot].expire = expire
	feeds[freeslot].duration = duration
	feeds[freeslot].spell = spell
	feeds[freeslot].bar = freeslot
	feeds[freeslot].debufftype = debufftype
	
	bars[freebar]:SetID(freeslot)
	
	freeslot = freeslot + 1
	freebar = freebar + 1
end

for i = 1, 10 do
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
	
	function f:SetTime(s, b) self.time:SetText(format("%.1f", s)) self.bar:SetValue(b) end
	function f:SetSpell(name, icon, count) self.spell:SetText(name) self.icon:SetTexture(icon) if count > 1 then self.count:SetText(count) end end
	function f:SetID(id)
		if not id then
			self:Hide()
			self.id = nil
			return
		end
		self.id = id
		self.target:SetText(feeds[id].name)
		local color = DebuffTypeColor[feeds[id].debufftype]
		self.bar:SetStatusBarColor(color.r, color.g, color.b)
		self:SetSpell(feeds[id].spellname, feeds[id].icon, feeds[id].count)
		self:Show()
	end
	function f:GetID() return self.id end
	function f:Stop() stop(i) end

	f:SetScript("OnUpdate", function(self, elapsed)
		local id = self:GetID()
		if not feeds[id] then self:Hide() return end

		local remaining = feeds[id].expire - GetTime()
		if remaining < 0 then stop(i) return end
		self:SetTime(remaining, remaining/feeds[id].duration)
	end)
	
	if i==1 then
		f:SetPoint("BOTTOMLEFT", InfoRight, "TOPLEFT", 25, 5) -- anchor
		f:SetPoint("BOTTOMRIGHT", InfoRight, "TOPRIGHT", 0, 5)
	else
		f:SetPoint("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, ncUIdb:Scale(4)) -- spacing and growth
		f:SetPoint("BOTTOMRIGHT", bars[i-1], "TOPRIGHT", 0, ncUIdb:Scale(4)) -- spacing and growth
	end

	bars[i] = f
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, target, spell, _, _, _, guid)
	if event=="COMBAT_LOG_EVENT_UNFILTERED" then
		if spell=="UNIT_DIED" then
			exists = {}
			sortbars(guid)
		end
	else
		if target=="player" then return end
		local unit = UnitGUID(target)
		
		exists = {}
		
		for i = 1, 40 do
			local name, _, icon, count, debufftype, duration, expires, caster, _, _, id = UnitDebuff(target, i)
			if caster=="player" then
				exists[id] = true
				local bar = isbizzy(unit, id)
				if bar then
					local id = bars[bar]:GetID()
					feeds[id].expire = expires
					feeds[id].duration = duration
				else
					start(unit, id, expires, duration, name, icon, count, UnitName(target), debufftype)
				end
			end
		end
		sortbars(unit)
	end
end)
f:RegisterEvent("UNIT_AURA")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")