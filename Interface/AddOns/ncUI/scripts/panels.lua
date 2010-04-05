local F, C = select(2, ...):Fetch()

local barbg = F:CreateFrame("Panel", "ActionBarBackground", UIParent)
barbg:SetSize(535, C.actionbar.bars==1 and 39 or 73)
barbg:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 7)

local ileftlv = F:CreateFrame("Panel", "InfoLeftLineVertical", barbg)
ileftlv:SetSize(2, 125)
ileftlv:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 23, 25)

local irightlv = F:CreateFrame("Panel", "InfoRightLineVertical", barbg)
irightlv:SetSize(2, 125)
irightlv:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -23, 25)

local ltoabl = F:CreateFrame("Panel", "LineToABLeft", barbg)
ltoabl:SetSize(5, 2)
ltoabl:SetPoint("BOTTOMLEFT", ileftlv, "BOTTOMLEFT")
ltoabl:SetPoint("RIGHT", barbg, "LEFT", -1, 0)

local ltoabr = F:CreateFrame("Panel", "LineToABRight", barbg)
ltoabr:SetSize(5, 2)
ltoabr:SetPoint("LEFT", barbg, "RIGHT", 1, 0)
ltoabr:SetPoint("BOTTOMRIGHT", irightlv, "BOTTOMRIGHT")

local ileft = F:CreateFrame("Panel", "InfoLeft", barbg)
ileft:SetSize(250, 22)
ileft:SetPoint("LEFT", ltoabl, "LEFT", 14, 0)
ileft:SetFrameLevel(2)

local iright = F:CreateFrame("Panel", "InfoRight", barbg)
iright:SetSize(250, 22)
iright:SetPoint("RIGHT", ltoabr, "RIGHT", -14, 0)
iright:SetFrameLevel(2)

local cubeleft = F:CreateFrame("Panel", "CubeLeft", ileftlv)
cubeleft:SetSize(8)
cubeleft:SetPoint("CENTER", ileftlv, "TOP")
cubeleft:SetBackdropColor(unpack(C.general.border))
cubeleft:SetFrameLevel(2)

local cubeleftbg = F:CreateFrame("Panel", "CubeLeftBG", ileftlv)
cubeleftbg:SetSize(10)
cubeleftbg:SetPoint("CENTER", ileftlv, "TOP")
cubeleftbg:SetBackdropBorderColor(unpack(C.general.backdrop))

local cuberight = F:CreateFrame("Panel", "CubeRight", irightlv)
cuberight:SetSize(8)
cuberight:SetPoint("CENTER", irightlv, "TOP")
cuberight:SetBackdropColor(unpack(C.general.border))
cuberight:SetFrameLevel(2)

local cuberightbg = F:CreateFrame("Panel", "CubeRightBG", irightlv)
cuberightbg:SetSize(10)
cuberightbg:SetPoint("CENTER", irightlv, "TOP")
cuberightbg:SetBackdropBorderColor(unpack(C.general.backdrop))

local edit = F:CreateFrame("Panel", "ChatFrameEditBoxBackground", ChatFrameEditBox)
edit:SetAllPoints(ileft)
edit:SetFrameLevel(4)

local petbg = F:CreateFrame("Panel", "PetActionBarBackground", PetActionButton1)
petbg:SetSize(34, 286)
petbg:SetPoint("RIGHT", UIParent, "RIGHT", -7, 0)

local ltpetbg = F:CreateFrame("Panel", "LineToPetActionBarBackground", petbg)
ltpetbg:SetSize(2, 40)
ltpetbg:SetPoint("TOP", petbg, "BOTTOM", 0, -1)

local ltpetbg2 = F:CreateFrame("Panel", "LineToPetActionBarBackground2", petbg)
ltpetbg2:SetSize(2, 40)
ltpetbg2:SetPoint("BOTTOM", petbg, "TOP", 0, 1)

local cubetop = F:CreateFrame("Panel", "CubeTop", ltpetbg2)
cubetop:SetSize(8)
cubetop:SetPoint("CENTER", ltpetbg2, "TOP")
cubetop:SetBackdropColor(unpack(C.general.border))
cubetop:SetFrameLevel(2)

local cubetopbg = F:CreateFrame("Panel", "CubeTopBG", ltpetbg2)
cubetopbg:SetSize(10)
cubetopbg:SetPoint("CENTER", ltpetbg2, "TOP")
cubetopbg:SetBackdropBorderColor(unpack(C.general.backdrop))

local cubebottom = F:CreateFrame("Panel", "CubeBottom", ltpetbg)
cubebottom:SetSize(8)
cubebottom:SetPoint("CENTER", ltpetbg, "BOTTOM")
cubebottom:SetBackdropColor(unpack(C.general.border))
cubebottom:SetFrameLevel(2)

local cubebottombg = F:CreateFrame("Panel", "CubeBottomBG", ltpetbg)
cubebottombg:SetSize(10)
cubebottombg:SetPoint("CENTER", ltpetbg, "BOTTOM")
cubebottombg:SetBackdropBorderColor(unpack(C.general.backdrop))

function updatebars(self, num)
	num = floor(num*6+.5)
	for f = 1,num do
		self.bars[f]:SetAlpha(1)
	end
	for f = (num+1),6 do
		self.bars[f]:SetAlpha(.2)
	end
end

local function update(self, e)
	self.e = self.e - e
	if self.e < 0 then
		updatebars(self, self:GetValue())
		self.e = 1
	end
end

local statsleft = F:CreateFrame("Panel", "MinimapStatsLeft", Minimap)
statsleft:SetSize(30, 16)
statsleft:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -2, -5)
statsleft:EnableMouse(true)
statsleft:SetScript("OnMouseDown", function()
	ToggleBackpack()
end)
statsleft:SetFrameLevel(3)
statsleft.e = 1
statsleft.bars = {}
function statsleft:GetValue()
	local totfree = 0
	local tot = 0
	for i=0,4 do
		totfree = totfree + GetContainerNumFreeSlots(i)
		tot = tot + GetContainerNumSlots(i)
	end
	return totfree/tot
end
local height = 2
for f=1, 6 do
	statsleft.bars[f] = F:CreateFrame("Panel", nil, UIParent)
	statsleft.bars[f]:SetSize(1, height)
	statsleft.bars[f]:SetFrameLevel(4)
	if f==1 then
		statsleft.bars[f]:SetPoint("BOTTOMLEFT", statsleft, 5, 4)
	end
	if f>1 then
		statsleft.bars[f]:SetPoint("BOTTOMLEFT", statsleft.bars[f-1], "BOTTOMRIGHT", 3, 0)
	end
	height = height + 1
end
statsleft:SetScript("OnUpdate", update)
update(statsleft, 10)

local statsright = F:CreateFrame("Panel", "MinimapStatsRight", Minimap)
statsright:SetSize(30, 16)
statsright:EnableMouse(true)
statsright:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
statsright:SetFrameLevel(3)
statsright.e = 1
statsright.bars = {}
function statsright:GetValue()
	local curDur, maxDur = 0,0
	for i = 1, 20 do
		local curD, maxD = GetInventoryItemDurability(i)
		if maxD then
			curDur = curDur + curD
			maxDur = maxDur + maxD
		end
	end
	if maxDur==0 then
		return 1
	else
		return curDur/maxDur
	end
end
local height = 2
for f=1, 6 do
	statsright.bars[f] = CreateFrame("Frame",nil, UIParent)
	ncUIdb:CreatePanel(statsright.bars[f], 1, height, "TOP", Minimap, "BOTTOM", 0, -5)
	statsright.bars[f]:ClearAllPoints()
	statsright.bars[f]:SetFrameLevel(4)
	if f==1 then
		statsright.bars[f]:SetPoint("BOTTOMRIGHT",statsright,"BOTTOMRIGHT", ncUIdb:Scale(-5), ncUIdb:Scale(4))
	end
	if f>1 then
		statsright.bars[f]:SetPoint("BOTTOMRIGHT",statsright.bars[f-1],"BOTTOMLEFT", ncUIdb:Scale(-3), 0)
	end
	height = height + 1
end
statsright:SetScript("OnUpdate", update)
update(statsright, 10)


local minimaptime = CreateFrame("Frame", "MinimapTime", Minimap)
ncUIdb:CreatePanel(minimaptime, 1, 16, "TOP", Minimap, "BOTTOM", 0, -5)
minimaptime:SetPoint("LEFT", statsleft, "RIGHT", 4, 0)
minimaptime:SetPoint("RIGHT", statsright, "LEFT", -4, 0)
minimaptime:EnableMouse(true)
minimaptime.e = 1
local text  = minimaptime:CreateFontString(nil, "OVERLAY")
text:SetFontObject("ncUIfont")
text:SetPoint("CENTER")
text:SetTextColor(unpack(ncUIdb["general"].border))
local function Update(self, e)
	local pending = CalendarGetNumPendingInvites()
	minimaptime.e = minimaptime.e - e
	if minimaptime.e < 0 then
		local Hr, Min = GetGameTime()
		if Hr == 0 then Hr = 12 end
		if Min<10 then Min = "0"..Min end
		if time24 == true then         
		   text:SetText(Hr..":"..Min)
		else             
		   if Hr>=12 then
			  Hr = Hr-12
			  if pending > 0 then
				text:SetText("|cffFF0000"..Hr..":"..Min.." |rPM")
			  else
				text:SetText(Hr..":"..Min.." |rPM")
			  end
		   else
			  if pending > 0 then
				text:SetText("|cffFF0000"..Hr..":"..Min.." |rAM")
			  else
				text:SetText(Hr..":"..Min.." |ram")
			  end
		   end
		end
		minimaptime.e = 1
	end
end
minimaptime:SetScript("OnEnter", function(self)
	if not InCombatLockdown() then
		GameTooltip:SetOwner(this, "ANCHOR_CURSOR")
		GameTooltip:ClearLines()
		local wgtime = GetWintergraspWaitTime() or nil
		_, instance = IsInInstance()
		if not (instance=="none") then
			wgtime = "Unavailable"
		elseif wgtime == nil then
			wgtime = "In Progress"
		else
			local hour = tonumber(format("%01.f", floor(wgtime/3600)))
			local min = format(hour>0 and "%02.f" or "%01.f", floor(wgtime/60 - (hour*60)))
			local sec = format("%02.f", floor(wgtime - hour*3600 - min *60))				
			wgtime = (hour>0 and hour..":" or "")..min..":"..sec				
		end
		GameTooltip:AddDoubleLine("Time to Wintergrasp:",wgtime)
		GameTooltip:Show()
	end	
end)
minimaptime:SetScript("OnLeave", function() GameTooltip:Hide() end)
minimaptime:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
minimaptime:RegisterEvent("PLAYER_ENTERING_WORLD")
minimaptime:SetScript("OnUpdate", Update)
minimaptime:SetScript("OnMouseDown", function() GameTimeFrame:Click() end)
Update(minimaptime, 10)
