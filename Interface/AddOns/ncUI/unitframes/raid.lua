local fontlol = ncUIdb["media"].pixelfont
 
local colors = setmetatable({
	power = setmetatable({
		['MANA'] = {0, 144/255, 1},
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})
 
local function menu(self)
	if(self.unit:match('party')) then
		ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor')
	end
end
 
 
 local max = math.max
 local floor = math.floor

 local texture = [[Interface\AddOns\ncUI\media\unitframe]]
 local backdrop = {
 	bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
 	insets = {top = ncUIdb:Scale(-1), bottom = ncUIdb:Scale(-1), left = ncUIdb:Scale(-1), right = ncUIdb:Scale(-1)}
 }
 
 
local function CreateStyle(self, unit)
	self.menu = menu
	self.colors = colors
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
 
	self:SetAttribute('*type2', 'menu')
	self:SetAttribute('initial-height', 14)
	self:SetAttribute('initial-width', 100)
 
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0,0,0)
 
	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetAllPoints(self)
	self.Health:SetStatusBarTexture(ncUIdb["media"].unitframe)
	self.Health.colorDisconnected = true
	self.Health.colorClass = true
 
	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture(ncUIdb["media"].unitframe)
	self.Health.bg:SetAlpha(.25)
	
	self.Health.bg.bg = self.Health:CreateTexture(nil, "BACKGROUND")
	self.Health.bg.bg:SetAllPoints(self.Health)
	self.Health.bg.bg:SetTexture(unpack(ncUIdb["general"].backdrop))
 
	local health = self.Health:CreateFontString(nil, "OVERLAY", "ncUIfontright")
	health:SetPoint('CENTER', 0, 1)

 
	--local power = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmallLeft')
	--power:SetPoint('LEFT', 3, 0)
	--self:Tag(power, '[smartpp]')
 
	self.Health.name = self.Health:CreateFontString(nil, "OVERLAY", "ncUIfontright")
	self.Health.name:SetFont(fontlol, 11, "THINOUTLINE")
	self.Health.name:SetPoint('LEFT', self, 'RIGHT', 5, 1)
	self:Tag(self.Health.name, '[name( )][leader( )]')
 
	self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	self.ReadyCheck:SetHeight(12)
	self.ReadyCheck:SetWidth(12)
	self.ReadyCheck:SetPoint('CENTER')
 
	self.outsideRangeAlpha = raidalphaoor
	self.inRangeAlpha = 1.0
	if showrange == true then
		self.Range = true
	else
		self.Range = false
	end
	self.Health.Smooth = true
end
 
oUF:RegisterStyle('Raid', CreateStyle)
oUF:SetActiveStyle('Raid')
 
local raid = {}
for i = 1, 8 do
	local raidgroup = oUF:Spawn('header', 'oUF_Group'..i)
	raidgroup:SetManyAttributes('groupFilter', tostring(i), 'showRaid', true, 'yOffset', -4)
	raidgroup:SetFrameStrata('BACKGROUND')	
	table.insert(raid, raidgroup)
	if(i == 1) then
		raidgroup:SetPoint('TOPLEFT', UIParent, 15, -80)
	else
		raidgroup:SetPoint('TOP', raid[i-1], 'BOTTOM', 0, -15)
	end
	local raidToggle = CreateFrame("Frame")
	raidToggle:RegisterEvent("PLAYER_LOGIN")
	raidToggle:RegisterEvent("RAID_ROSTER_UPDATE")
	raidToggle:RegisterEvent("PARTY_LEADER_CHANGED")
	raidToggle:RegisterEvent("PARTY_MEMBERS_CHANGED")
	raidToggle:SetScript("OnEvent", function(self)
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		raidgroup:Show()
		end
	end)
end
 
 
 
 
 
