local feeds, bars = {}, {}
local cdebuffs, bardebuffs = {}, {}
local freeslot, freebar = 1, 1
local function hex(r, g, b) if type(r) == "table" then if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end	end	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255) end

local function sortbars(num)
	local remain = {}
	for i = 1, num do
		local id = bars[i]:GetID()
		remain[i] = id
	end
	table.sort(remain, function(a, b) return (feeds[a].expire - GetTime()) < (feeds[b].expire - GetTime()) end)
	for a, b in pairs(remain) do
		bardebuffs[feeds[b].target][feeds[b].spell..feeds[b].expire] = a
		bars[a]:SetID(b)
	end
end

local function start(target, spell, expire, duration)
	feeds[freeslot] = {}
	feeds[freeslot].target = target
	feeds[freeslot].spell = spell
	feeds[freeslot].expire = expire
	feeds[freeslot].duration = duration
	
	bardebuffs[target][spell..expire] = freebar
	bars[freebar]:SetID(freeslot)
	
	sortbars(freebar)
	
	freebar = freebar + 1
	freeslot = freeslot + 1
end

local function stop(id)
	local fdid = bars[id]:GetID()
	cdebuffs[feeds[fdid].target][feeds[fdid].spell..feeds[fdid].expire] = nil
	for i = id, 9 do
		local nextid = bars[i+1]:GetID()
		if nextid then
			bars[i]:SetID(nextid)
		else
			bars[i]:SetID(nil)
		end
	end
	freebar = freebar - 1
end

for i = 1, 10 do
	local f = CreateFrame("Frame", "DebuffTimerBar"..i, UIParent)
	f:Hide()

	f:SetHeight(ncUIdb:Scale(21))
	f:SetWidth(ncUIdb:Scale(350))
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
	
	function f:SetTime(s, b) self.time:SetText(format("%.1f", s)) self.bar:SetValue(b) end
	--function f:SetTarget(unit) self.target:SetText(hex(RAID_CLASS_COLORS[select(2,UnitClass(unit))])..(UnitName(unit)).."|r") end
	function f:SetTarget(unit) self.target:SetText(UnitName(unit)) end
	function f:SetSpell(id) local name, _, icon = GetSpellInfo(id) self.spell:SetText(name) self.icon:SetTexture(icon) end
	function f:SetID(id) self.id = id if not id then self:Hide() return end self:SetTarget(feeds[id].target) self:SetSpell(feeds[id].spell) self:Show() end
	function f:GetID() return self.id end

	f:SetScript("OnUpdate", function(self, elapsed)
		local id = self:GetID()
		if not feeds[id] then self:Hide() return end

		local remaining = feeds[id].expire - GetTime()
		if remaining < 0 then stop(i) return end
		self:SetTime(remaining, remaining/feeds[id].duration)
	end)
	
	if i==1 then
		f:SetPoint("CENTER", UIParent) -- anchor
	else
		f:SetPoint("BOTTOM", bars[i-1], "TOP", 0, ncUIdb:Scale(4)) -- spacing and growth
	end

	bars[i] = f
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, target, spell, _, _, _, name)
	if event=="COMBAT_LOG_EVENT_UNFILTERED" then
		if spell=="UNIT_DIED" then
			cdebuffs[name] = {}
		end
	else
		if target=="player" then return end
		local unit = UnitGUID(target)
		
		if not cdebuffs[unit] then cdebuffs[unit] = {} end
		if not bardebuffs[unit] then bardebuffs[unit] = {} end
		local donedebuffs = {[unit]={}}
		
		for i = 1, 40 do
			local name, rank, icon, count, debufftype, duration, expires, caster, stealable, consolidate, id = UnitDebuff(target, i)
			if caster=="player" then
				donedebuffs[unit][id..expires] = true
				if not cdebuffs[unit][id..expires] then
					cdebuffs[unit][id..expires] = true
					start(unit, id, expires, duration)
				end
			end
		end
		for key, val in pairs(cdebuffs[unit]) do
			if not donedebuffs[unit][key] then
				cdebuffs[unit][key] = nil
				stop(bardebuffs[unit][key])
			end
		end
	end
end)
f:RegisterEvent("UNIT_AURA")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")