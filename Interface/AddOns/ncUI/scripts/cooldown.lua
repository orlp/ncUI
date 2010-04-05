local db = ncUIdb["cooldown"]
if not db.enable then return end

function formattime(s)
	if s >= 86400 then
			return format('%dd', floor(s/86400 + 0.5)), s%86400
	elseif s >= 3600 then
			return format('%dh', floor(s/3600 + 0.5)), s%3600
	elseif s >= 60 then
			return format('%dm', floor(s/60 + 0.5)), s%60
	elseif s <= db.treshold then
		return format("%.1f", s), s - format("%.1f", s)
	end
	return floor(s + 0.5), s - floor(s)
end
local function update(self, elapsed)
	if not self.text:IsShown() then return end
	if self.nextupdate > 0 then
		self.nextupdate = self.nextupdate - elapsed
	else
		self.nextupdate = 1
		local remaining = self.duration - (GetTime() - self.start)		
		if remaining > 0 then
			local ftime, nextupdate = formattime(remaining)
			self.text:SetText(ftime)
			self.nextupdate = nextupdate
			if self:GetParent().action and db.fade then	self.texture:Show()	else self.texture:Hide() end
			if remaining > db.treshold then	self.text:SetTextColor(unpack(db.color)) else self.text:SetTextColor(unpack(db.tresholdcolor)) end
		else
			self.text:SetText("")
			self.text:Hide()
			self.texture:Hide()
		end
	end
end
local function createtext(self)
	local text = self:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER", (self.height < 34 and 1 or -1), 0)
	text:SetParent(self:GetParent())	
	local texture = self:CreateTexture()
	texture:SetPoint("TOPLEFT", self, 2, -2)
	texture:SetPoint("BOTTOMRIGHT", self, -2, 2)
	texture:SetTexture(0, 0, 0, .5)
	texture:SetParent(self:GetParent())
	self:SetScript("OnUpdate", update)
	self:SetAlpha(0)
	self:SetScript("OnHide", function() text:Hide() texture:Hide() end)
	self:SetScript("OnShow", function() text:Show() texture:Show() end)
	self.texture = texture
	self.text = text	
	return text
end
local function startcd(self, start, duration)
	if start > 0 and duration > 3 then
		self.start = start
		self.duration = duration
		self.nextupdate = 0
		
		local height = self:GetHeight()
		if height < ncUIdb:Scale(20) then return end
		self.height = height
		
		local text = self.text or createtext(self)
		if height==0 then
			height = 20
		end
		text:SetFont((height < 34 and ncUIdb["media"].pixelfont or ncUIdb["media"].font), (height < 34 and ncUIdb:Scale(8) or 19), "THINOUTLINE")
		text:Show()
	end
end
hooksecurefunc(getmetatable(CreateFrame('Cooldown', nil, nil, 'CooldownFrameTemplate')).__index, "SetCooldown", startcd)
