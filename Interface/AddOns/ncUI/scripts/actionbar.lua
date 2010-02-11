local barholder = CreateFrame("Frame","ncBarholder",UIParent)
local petbarholder = CreateFrame("Frame","ncPetBarholder", ActionBarBackground)
local bonusactionbarholder = CreateFrame("Frame","ncPetBarholder", ActionBarBackground)
local shapeshiftbarholder = CreateFrame("Frame","ncShapeShiftholder", ActionBarBackground)
local db = ncUIdb["actionbar"]

PetActionBarFrame:SetParent(petbarholder)
PetActionBarFrame:SetWidth(.01)
PetActionButton1:ClearAllPoints()
PetActionButton1:SetPoint("BOTTOMLEFT", petbarholder,"BOTTOMLEFT")
PetActionButton1:SetFrameLevel(3)

BonusActionBarFrame:SetParent(bonusactionbarholder)
BonusActionBarFrame:SetWidth(0.01)
BonusActionBarTexture0:Hide()
BonusActionBarTexture1:Hide()
BonusActionButton1:ClearAllPoints()
  
for i=1, 8 do
	_G["ActionButton"..i]:SetParent(UIParent)
end

local MicroButtons = {
	CharacterMicroButton,
	SpellbookMicroButton,
	TalentMicroButton,
	AchievementMicroButton,
	QuestLogMicroButton,
	SocialsMicroButton,
	PVPMicroButton,
	LFGMicroButton,
	MainMenuMicroButton,
	HelpMicroButton,
}
for _, f in pairs(MicroButtons) do
	f.Show = function() end
	f:Hide()
end
  
PossessBarFrame:SetParent(barholder)
PossessButton1:ClearAllPoints()
PossessButton1:SetPoint("LEFT",MultiBarBottomLeftButton1,"RIGHT",0,0)

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
if BonusActionBarFrame:IsShown() then
	showhide(0)
end

MainMenuBar:SetScale(0.001)
MainMenuBar:SetAlpha(0)

VehicleMenuBar:SetScale(0.001)
VehicleMenuBar:SetAlpha(0)
  
local vehicle = CreateFrame("BUTTON", nil, UIParent, "SecureActionButtonTemplate")
vehicle:SetWidth(30)
vehicle:SetHeight(30)
vehicle:SetPoint("BOTTOMLEFT", ActionBarBackground, "TOPLEFT", -5, 0)

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
ActionButton1:SetPoint("BOTTOMLEFT", ActionBarBackground,"BOTTOMLEFT", ncUIdb:Scale(5), 6)
BonusActionButton1:SetAllPoints(ActionButton1)
for i=2, 8 do
    local b = _G["ActionButton"..i]
    local b2 = _G["ActionButton"..i-1]
    b:ClearAllPoints()
    b:SetPoint("LEFT",b2,"RIGHT", ncUIdb:Scale(5), 0)
end

for i=2, 8 do
    local b = _G["BonusActionButton"..i]
    local b2 = _G["BonusActionButton"..i-1]
    b:ClearAllPoints()
    b:SetPoint("LEFT",b2,"RIGHT", ncUIdb:Scale(5), 0)
end

MultiBarBottomLeftButton1:ClearAllPoints()
MultiBarBottomLeftButton1:SetPoint("LEFT", ActionButton8,"RIGHT", ncUIdb:Scale(5), 0)
for i=2, 8 do
    local b = _G["MultiBarBottomLeftButton"..i]
    local b2 = _G["MultiBarBottomLeftButton"..i-1]
    b:ClearAllPoints()
    b:SetPoint("LEFT",b2,"RIGHT", ncUIdb:Scale(5), 0)
end

local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
for i=9,12 do
	securehandler:WrapScript(_G["MultiBarBottomLeftButton"..i], "OnShow", "self:Hide()")
	securehandler:WrapScript(_G["BonusActionButton"..i], "OnShow", "self:Hide()")
	_G["BonusActionButton"..i]:Hide()
end

for i=1,12 do
	securehandler:WrapScript(_G["MultiBarLeftButton"..i], "OnShow", "self:Hide()")
	securehandler:WrapScript(_G["MultiBarRightButton"..i], "OnShow", "self:Hide()")
end

for i=1,12 do
	securehandler:WrapScript(_G["MultiBarBottomRightButton"..i], "OnShow", "self:Hide()")
end