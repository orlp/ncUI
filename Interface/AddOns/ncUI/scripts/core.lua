local F, C = select(2, ...):Fetch()

ncUIfont:SetFont(ncUIdb["media"].pixelfont, F:Scale(8), "THINOUTLINE")


local function install()
	SetMultisampleFormat(1)
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", db.uiscale)
    SetCVar("chatLocked", 1)
	SetCVar("showClock", 0)
	SetCVar("screenshotQuality", 10)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("buffDurations", 1)	
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("rotateMinimap", 0)
	SetCVar("buffDurations", 1)
	SetCVar("alwaysShowActionBars", 1)
	SetCVar("scriptErrors", 1)
	SetActionBarToggles( 1, 1, 1, 1, 1 )
	
	ncUIinstalled = true
	ReloadUI()
end

StaticPopupDialogs.ncUI = {
  text = "Set ncUI to the default configuration?",
  button1 = ACCEPT,
  button2 = CANCEL,
  OnAccept = install,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1
}

SLASH_GM1 = "/gm"
SlashCmdList.GM = ToggleHelpFrame
SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
SlashCmdList.DISABLE_ADDON = function(s) DisableAddOn(s) end
SLASH_DISABLE_ADDON1 = "/disable"
SlashCmdList.ENABLE_ADDON = function(s) EnableAddOn(s) LoadAddOn(s) end
SLASH_ENABLE_ADDON1 = "/enable"
SLASH_CONFIGURE1 = "/configure"
SlashCmdList.CONFIGURE = function() StaticPopup_Show("ncUI") end
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
	if name ~= "ncUI" then return end
	f:UnregisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", nil)
	if not (ncUIinstalled) then
		StaticPopup_Show("ncUI")
	end
end)


-- BLIZZARD UI FIXES
AchievementMicroButton_Update = function() end
TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOPLEFT", 0, 0)