local F, C = select(2, ...):Fetch()

local MIN_SCALE = .5
local R, G, B = 1, 1, 1

local i
local _G = getfenv(0)
local strformat, strfind = string.format, string.find

local format = string.format
local floor = math.floor
local min = math.min

local function formattime(s)
	if s >= 86400 then
		return format("%dd", floor(s/86400 + 0.5)), s % 86400
	elseif s >= 3600 then
		return format("%dh", floor(s/3600 + 0.5)), s % 3600
	elseif s >= 60 then
		return format("%dm", floor(s/60 + 0.5)), s % 60
	elseif s <= C.cooldown.treshold then
		return format("%.1f", s), s - format("%.1f", s)
	end
	return floor(s + 0.5), s - floor(s)
end

local function onupdate(self, elapsed)
	if self.text:IsShown() then
		if self.nextupdate > 0 then
			self.nextupdate = self.nextupdate - elapsed
		else
			if (self:GetEffectiveScale()/UIParent:GetEffectiveScale()) < MIN_SCALE then
				self.text:SetText("")
				self.nextupdate = .5
			else
				local remain = self.duration - (GetTime() - self.start)
				if floor(remain + 0.5) > 0 then
					local time, nextupdate = formattime(remain)
					self.text:SetText(time)
					self.nextupdate = nextupdate
					if floor(remain + 0.5) > C.cooldown.treshold then 
						self.text:SetTextColor(1,1,1) 
					else
						self.text:SetTextColor(1,0,0) 
					end
				else
					self.text:Hide()
				end
			end
		end
	end
end

local function create(self)
	if not self:GetParent() then return end
	local scale = min(self:GetParent():GetWidth() / F:Scale(25), 1)
	if scale < MIN_SCALE then
		self.noOCC = true
	else
		local text = self:CreateFontString(nil, "OVERLAY")
		text:Place("CENTER", self)
		text:SetFont(C.media.font, 15 * scale, "THINOUTLINE")
		text:SetTextColor(R, G, B)
		
		self:HookScript("OnHide", function() text:Hide() end)

		self.text = text
		self:SetScript("OnUpdate", onupdate)
		return text
	end
end

local function startcd(self, start, duration)
	self.start = start
	self.duration = duration
	self.nextupdate = 0

	local text = self.text or (not self.noOCC and create(self))
	if text then
		text:Show()
	end
end

hooksecurefunc(getmetatable(CreateFrame("Cooldown", nil, nil, "CooldownFrameTemplate")).__index, "SetCooldown", function(self, start, duration)
	if start > 0 and duration > 3 then
		startcd(self, start, duration)
	else
		local text = self.text
		if text then
			text:Hide()
		end
	end
end)