local F, C = select(2, ...):Fetch()
local barholder = CreateFrame("Frame", "ncBarholder", UIParent)
local petbarholder = CreateFrame("Frame", "ncPetBarholder", ActionBarBackground)
local bonusactionbarholder = CreateFrame("Frame", "ncPetBarholder", ActionBarBackground)
local shapeshiftbarholder = CreateFrame("Frame", "ncShapeShiftholder", UIParent)

PetActionBarFrame:SetParent(petbarholder)
PetActionBarFrame:SetWidth(.01)
PetActionButton1:ClearAllPoints()
PetActionButton1:Place("TOP", PetActionBarBackground, 0, -5)
PetActionButton1:SetFrameLevel(3)

BonusActionBarFrame:SetParent(bonusactionbarholder)
BonusActionBarFrame:SetWidth(0.01)
BonusActionBarTexture0:Hide()
BonusActionBarTexture1:Hide()
BonusActionButton1:ClearAllPoints()

shapeshiftbarholder:Size(25)
shapeshiftbarholder:Place("TOPLEFT")
ShapeshiftBarFrame:SetParent(bonusactionbarholder)
ShapeshiftBarFrame:SetWidth(0.01)
ShapeshiftButton1:ClearAllPoints()
ShapeshiftButton1:Place("BOTTOMLEFT", shapeshiftbarholder, 11, -11)
hooksecurefunc("ShapeshiftBar_Update", function()
	ShapeshiftButton1:Place("BOTTOMLEFT", shapeshiftbarholder, 11, -11)
end) 

for i=1, 8 do
	_G["ActionButton"..i]:SetParent(UIParent)
end

CharacterMicroButton:Destroy()
SpellbookMicroButton:Destroy()
TalentMicroButton:Destroy()
AchievementMicroButton:Destroy()
QuestLogMicroButton:Destroy()
SocialsMicroButton:Destroy()
PVPMicroButton:Destroy()
--LFGMicroButton:Destroy()
MainMenuMicroButton:Destroy()
HelpMicroButton:Destroy()
  
PossessBarFrame:SetParent(barholder)
PossessButton1:ClearAllPoints()
PossessButton1:Place("LEFT", MultiBarLeftButton1, "RIGHT", 0, 0)

local function showhide(alpha)
	for i=1,8 do
		_G["ActionButton"..i]:SetAlpha(alpha)
	end
end

for i=1,8 do
	_G["BonusActionButton"..i]:SetFrameStrata("MEDIUM")
end

BonusActionBarFrame:HookScript("OnShow", function(self) showhide(0) end)
BonusActionBarFrame:HookScript("OnHide", function(self) showhide(1) end)
if BonusActionBarFrame:IsShown() then showhide(0) end

MainMenuBar:SetScale(0.001)
MainMenuBar:SetAlpha(0)

VehicleMenuBar:SetScale(0.001)
VehicleMenuBar:SetAlpha(0)
  
local vehicle = CreateFrame("BUTTON", nil, UIParent, "SecureActionButtonTemplate")
vehicle:Size(30)
vehicle:Place("RIGHT", ActionBarBackground, "LEFT", -5, 0)

vehicle:RegisterForClicks("AnyUp")
vehicle:SetScript("OnClick", function() VehicleExit() end)

vehicle:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
vehicle:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
vehicle:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")

vehicle:RegisterEvent("UNIT_ENTERING_VEHICLE")
vehicle:RegisterEvent("UNIT_ENTERED_VEHICLE")
vehicle:RegisterEvent("UNIT_EXITING_VEHICLE")
vehicle:RegisterEvent("UNIT_EXITED_VEHICLE")
vehicle:SetScript("OnEvent", function(self, event, arg1)
	if (((event=="UNIT_ENTERING_VEHICLE") or (event=="UNIT_ENTERED_VEHICLE")) and arg1 == "player") then
		vehicle:SetAlpha(1)
	elseif (((event=="UNIT_EXITING_VEHICLE") or (event=="UNIT_EXITED_VEHICLE")) and arg1 == "player") then
		vehicle:SetAlpha(0)
	end
end)  
vehicle:SetAlpha(0)

ActionButton1:ClearAllPoints()
ActionButton1:Place("BOTTOMLEFT", ActionBarBackground, "BOTTOMLEFT", 5, 5)
BonusActionButton1:SetAllPoints(ActionButton1)
for i=2, 8 do
    local b = _G["ActionButton"..i]
    local b2 = _G["ActionButton"..i-1]
    b:ClearAllPoints()
    b:Place("LEFT", b2, "RIGHT", 4, 0)
end

for i=2, 10 do
    local b = _G["ShapeshiftButton"..i]
    local b2 = _G["ShapeshiftButton"..i-1]
    b:ClearAllPoints()
    b:Place("LEFT", b2, "RIGHT", 4, 0)
end

for i=2, 10 do
    local b = _G["PetActionButton"..i]
    local b2 = _G["PetActionButton"..i-1]
    b:ClearAllPoints()
    b:Place("TOP", b2, "BOTTOM", 0, -4)
end

for i=2, 8 do
    local b = _G["BonusActionButton"..i]
    local b2 = _G["BonusActionButton"..i-1]
    b:ClearAllPoints()
    b:Place("LEFT", b2, "RIGHT", 4, 0)
end

MultiBarLeftButton1:ClearAllPoints()
MultiBarLeftButton1:Place("LEFT", ActionButton8, "RIGHT", 5, 0)
for i=2, 8 do
    local b = _G["MultiBarLeftButton"..i]
    local b2 = _G["MultiBarLeftButton"..i-1]
    b:ClearAllPoints()
    b:Place("LEFT", b2, "RIGHT", 4, 0)
end

if C.actionbar.bars~=1 then
	MultiBarBottomLeftButton1:ClearAllPoints()
	MultiBarBottomLeftButton1:Place("BOTTOM", ActionButton1, "TOP", 0, 5)
	MultiBarBottomRightButton1:ClearAllPoints()
	MultiBarBottomRightButton1:Place("LEFT", MultiBarBottomLeftButton8, "RIGHT", 5, 0)
	for i= 2, 8 do
	    local b = _G["MultiBarBottomLeftButton"..i]
		local b2 = _G["MultiBarBottomLeftButton"..i-1]
		b:ClearAllPoints()
		b:Place("LEFT", b2, "RIGHT", 4, 0)
		
		local b = _G["MultiBarBottomRightButton"..i]
		local b2 = _G["MultiBarBottomRightButton"..i-1]
		b:ClearAllPoints()
		b:Place("LEFT", b2, "RIGHT", 4, 0)
	end
end

local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
for i=9,12 do
	securehandler:WrapScript(_G["MultiBarLeftButton"..i], "OnShow", "self:Hide()")
	securehandler:WrapScript(_G["BonusActionButton"..i], "OnShow", "self:Hide()")
	securehandler:WrapScript(_G["MultiBarBottomLeftButton"..i], "OnShow", "self:Hide()")
	securehandler:WrapScript(_G["MultiBarBottomRightButton"..i], "OnShow", "self:Hide()")
end

for i=1,12 do
	securehandler:WrapScript(_G["MultiBarRightButton"..i], "OnShow", "self:Hide()")
	if C.actionbar.bars==1 then
		securehandler:WrapScript(_G["MultiBarBottomLeftButton"..i], "OnShow", "self:Hide()")
		securehandler:WrapScript(_G["MultiBarBottomRightButton"..i], "OnShow", "self:Hide()")
	end
end

for i=1, 8 do
	securehandler:WrapScript(_G["ActionButton"..i], "OnHide", "self:Show()")
end

for i=1,12 do
	_G["ActionButton"..i]:Show()
	_G["BonusActionButton"..i]:Hide()
end
