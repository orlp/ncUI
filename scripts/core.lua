local F, C, L = unpack(select(2, ...))

CreateFont("ncUIfont"):SetFont(C.media.pxfont, F:Scale(8), "OUTLINE, MONOCHROME")

local function install()
	SetMultisampleFormat(1)
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", C.uiscale)
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
	SetActionBarToggles(1, 1, 1, 1, 1)
	
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

-- random shit

F:SetTemplate(DropDownList1MenuBackdrop)
F:SetTemplate(DropDownList2MenuBackdrop)
F:SetTemplate(DropDownList1Backdrop)
F:SetTemplate(DropDownList2Backdrop)