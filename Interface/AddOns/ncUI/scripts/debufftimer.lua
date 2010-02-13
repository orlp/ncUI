--[[local backdrop = {
	bgFile = ncUIdb["media"].solid,
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}
 
function BarPanel(height, leftinset, rightinset, y, anchorPoint, anchorPointRel, anchor, level, name, parent, strata)
	local Panel = CreateFrame("Frame", name, parent)
	Panel:SetFrameLevel(level)
	Panel:SetFrameStrata(strata)
	Panel:SetHeight(height)
	Panel:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", leftinset, y)
	Panel:SetPoint(anchorPoint, anchor, anchorPointRel, rightinset, y)
	Panel:SetBackdrop( {
		bgFile = ncUIdb["media"].solid,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	Panel:SetBackdropColor(0.1, 0.1, 0.1, 1)
	Panel:Show()
	return Panel
end

local function UpdateBar(self)
	local duration = self.Duration
	local icon = self.Icon
	self.Bar.IconHolder.Icon:SetTexture(icon)
	local timeLeft = self.EndTime-GetTime()
	local roundedt = math.floor(timeLeft*10+.5)/10
	self.Bar:SetValue(timeLeft/duration)
	if roundedt % 1 == 0 then
		self.Time:SetText(roundedt .. ".0")
	else self.Time:SetText(roundedt) end

	if timeLeft < 0 then
		self.Panel:Hide()
		self:SetScript("OnUpdate", nil)
	end
end--]]

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
		bardebuffs[feeds[b].target..feeds[b].spell..feeds[b].expire] = a
		bars[a]:SetID(b)
	end
end

local function start(target, spell, expire, duration)
	feeds[freeslot] = {}
	feeds[freeslot].target = target
	feeds[freeslot].spell = spell
	feeds[freeslot].expire = expire
	feeds[freeslot].duration = duration
	
	bardebuffs[target..spell..expire] = freebar
	bars[freebar]:SetID(freeslot)
	
	sortbars(freebar)
	
	freebar = freebar + 1
	freeslot = freeslot + 1
end

local function stop(id)
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
f:SetScript("OnEvent", function(self, event, unit, spell)
	local donedebuffs = {}
	if unit=="player" then return end
	unit = UnitGUID(unit)
	for i = 1, 40 do
		local name, rank, icon, count, debufftype, duration, expires, caster, stealable, consolidate, id = UnitDebuff(unit, i)
		if caster=="player" then
			donedebuffs[unit..id..expires] = true
			if not cdebuffs[unit..id..expires] then
				cdebuffs[unit..id..expires] = true
				start(unit, id, expires, duration)
			end
		end
	end
	for key, val in pairs(cdebuffs) do
		if not donedebuffs[key] then
			cdebuffs[key] = nil
			stop(bardebuffs[key])
		end
	end
end)
f:RegisterEvent("UNIT_AURA")
--            /run Start("player", 5, GetTime(), 15)
--[[local f = createbar(1)
f:SetPoint("CENTER", UIParent)
f:SetTarget(UnitName("player"))
f:SetSpell(48672)
f.e = 0
f.mult = 1
f:SetScript("OnUpdate", function(self, elapsed)
	self.e = self.e + elapsed*self.mult
	self.bar:SetValue(self.e)
	self:SetTime(self.e)
	if self.e > 1 and self.mult > 0 or self.e < 0 and self.mult < 0 then self.mult = self.mult*-1 end
end)
for i = 2, 9 do
	local f = createbar(i)
	f:SetPoint("TOP", _G["DebuffTimerBar"..(i-1)], "BOTTOM", 0, -5)
	f:SetTarget(UnitName("player"))
	f:SetSpell(48672)
	f.e = 0
	f.mult = 2/i
	f:SetScript("OnUpdate", function(self, elapsed)
		self.e = self.e + elapsed*self.mult
		self.bar:SetValue(self.e)
		self:SetTime(self.e)
		if self.e > 1 and self.mult > 0 or self.e < 0 and self.mult < 0 then self.mult = self.mult*-1 end
	end)
end--]]
	

--[[for i=1, #debuffIDs do
	local DebuffFrame = CreateFrame("Frame", "DebuffFrame"..i, UIParent)
		if select(2, UnitClass("Player")) == "SHAMAN" or select(2, UnitClass("Player")) == "DEATHKNIGHT" then
			DebuffFrame.Panel = BarPanel(15, 20, -2, ((#buffIDs*18+22)+((i-1)*18)), "BOTTOMRIGHT", "TOPRIGHT", oUF_Tukz_player, 1, "DebuffPanel"..i, DebuffFrame, "HIGH")
		else
			DebuffFrame.Panel = BarPanel(15, 20, -2, ((#buffIDs*18+14)+((i-1)*18)), "BOTTOMRIGHT", "TOPRIGHT", oUF_Tukz_player, 1, "DebuffPanel"..i, DebuffFrame, "HIGH")
		end
	ConfigureBar(DebuffFrame, ((i+1) % 2), ((i+2) % 2), 0)
	local function DebuffCheck(self, event, unit, spell)
		local spid = debuffIDs[i]
		if unit == "target" and UnitDebuff("target", (GetSpellInfo(spid))) then
			local name, _, icon, _, _, duration, expirationTime, unitCaster = UnitDebuff("target", (GetSpellInfo(spid)))
			if name and unitCaster=="player" then
				self.unitCaster = unitCaster
				self.EndTime = expirationTime
				self.Duration = duration
				self.Icon = icon
				self.Panel:Show()
				self:SetScript("OnUpdate", UpdateBar)
			end
		end
	end
	DebuffFrame:SetScript("OnEvent", DebuffCheck)
	DebuffFrame:RegisterEvent("UNIT_AURA")
end--]]