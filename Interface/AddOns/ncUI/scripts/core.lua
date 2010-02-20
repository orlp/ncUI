-- don't edit below this linelocal p = UnitName("player")local db = ncUIdb["general"]local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/db.uiscalelocal function scale(x)    return mult*math.floor(x+.5)endfunction ncUIdb:Scale(x) return scale(x) endncUIdb.mult = multfunction ncUIdb:CreatePanel(f, w, h, a1, p, a2, x, y)	f:SetFrameLevel(1)	f:SetHeight(scale(h))	f:SetWidth(scale(w))	f:SetFrameStrata("BACKGROUND")	f:SetPoint(a1, p, a2, scale(x), scale(y))	f:SetBackdrop({	  bgFile = ncUIdb["media"].solid, 	  edgeFile = ncUIdb["media"].solid, 	  tile = false, tileSize = 0, edgeSize = mult, 	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}	})	f:SetBackdropColor(unpack(db.colorscheme_backdrop))	f:SetBackdropBorderColor(unpack(db.colorscheme_border))endfunction ncUIdb:SetTemplate(f)	f:SetBackdrop({	  bgFile = ncUIdb["media"].solid, 	  edgeFile = ncUIdb["media"].solid, 	  tile = false, tileSize = 0, edgeSize = mult, 	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}	})	f:SetBackdropColor(unpack(db.colorscheme_backdrop))	f:SetBackdropBorderColor(unpack(db.colorscheme_border))endfunction ncUIdb:CreateText(parent, tab, pos)	local content, onclick, tooltip = tab.content or function() return "" end, tab.onclick or nil, tab.tooltip or nil	local f = CreateFrame("Frame", _, parent)	local t = f:CreateFontString(nil, "OVERLAY")	t:SetFont(ncUIdb["media"].pixelfont, ncUIdb:Scale(8))	t:SetPoint("CENTER", f)	t:SetTextColor(unpack(ncUIdb["general"].colorscheme_border))	f:SetPoint(unpack(pos))	function f:Update(self, event, ...)		t:SetText(string.upper(content(self, event, ...)))				f:SetHeight(t:GetStringHeight())		f:SetWidth(t:GetStringWidth())	end	if onclick then		f:EnableMouse(true)		f:SetScript("OnMouseDown", function(self, button)			onclick(button)		end)	end	if tooltip then		f:EnableMouse(true)		f:SetScript("OnEnter", function()			GameTooltip:SetOwner(this, "ANCHOR_CURSOR");			for i=1,#tooltip do				if type(tooltip[i]) == "table" then					GameTooltip:AddDoubleLine(tooltip[i][1],tooltip[i][2])				elseif type(tooltip[i]) == "function" then					tooltip[i]()				else					GameTooltip:AddLine(tooltip[i])				end			end							GameTooltip:Show()		end)		f:SetScript("OnLeave", function()			GameTooltip:Hide()		end)	end	f.elapsed = 0	f:SetScript("OnUpdate", function(self, elapsed)		f.elapsed = f.elapsed + elapsed		if (f.elapsed>1) then			f.elapsed = 0			f:Update()		end	end)	f:RegisterEvent("PLAYER_ENTERING_WORLD")	return fendlocal function install()	SetMultisampleFormat(1)	SetCVar("useUiScale", 1)	SetCVar("uiScale", db.uiscale)    SetCVar("chatLocked", 1)	SetCVar("showClock", 0)	SetCVar("screenshotQuality", 10)	SetCVar("cameraDistanceMax", 50)	SetCVar("cameraDistanceMaxFactor", 3.4)	SetCVar("buffDurations", 1)		SetCVar("nameplateShowEnemies", 1)	SetCVar("rotateMinimap", 0)	SetCVar("buffDurations", 1)	SetCVar("alwaysShowActionBars", 1)	SetCVar("scriptErrors", 1)	SetActionBarToggles( 1, 1, 1, 1, 1 )		ncUIinstalled = true	ReloadUI()endStaticPopupDialogs.ncUI = {  text = "Set ncUI to the default configuration?",  button1 = ACCEPT,  button2 = CANCEL,  OnAccept = install,  timeout = 0,  whileDead = 1,  hideOnEscape = 1}SLASH_GM1 = "/gm"SlashCmdList.GM = ToggleHelpFrameSLASH_RELOADUI1 = "/rl"SlashCmdList.RELOADUI = ReloadUISlashCmdList.DISABLE_ADDON = function(s) DisableAddOn(s) endSLASH_DISABLE_ADDON1 = "/disable"SlashCmdList.ENABLE_ADDON = function(s) EnableAddOn(s) LoadAddOn(s) endSLASH_ENABLE_ADDON1 = "/enable"SLASH_CONFIGURE1 = "/configure"SlashCmdList.CONFIGURE = function() StaticPopup_Show("ncUI") endlocal f = CreateFrame("Frame")f:RegisterEvent("ADDON_LOADED")f:SetScript("OnEvent", function(_, _, name)	if name ~= "ncUI" then return end	f:UnregisterEvent("ADDON_LOADED")	f:SetScript("OnEvent", nil)	if not (ncUIinstalled) then		StaticPopup_Show("ncUI")	endend)-- BLIZZARD UI FIXESAchievementMicroButton_Update = function() endTicketStatusFrame:ClearAllPoints()TicketStatusFrame:SetPoint("TOPLEFT", 0,0)local menu = CreateFrame("Frame", "aSettingsMarkingFrame", UIParent, "UIDropDownMenuTemplate")local list = {    {text = "Skull",    func = function() SetRaidTarget("target", 8) end},    {text = "|cffff0000Cross|r",    func = function() SetRaidTarget("target", 7) end},    {text = "|cff00ffffSquare|r",    func = function() SetRaidTarget("target", 6) end},    {text = "|cffC7C7C7Moon|r",    func = function() SetRaidTarget("target", 5) end},    {text = "|cff00ff00Triangle|r",    func = function() SetRaidTarget("target", 4) end},    {text = "|cff912CEEDiamond|r",    func = function() SetRaidTarget("target", 3) end},    {text = "|cffFF8000Circle|r",    func = function() SetRaidTarget("target", 2) end},    {text = "|cffffff00Star|r",    func = function() SetRaidTarget("target", 1) end},    {text = "Clear",    func = function() SetRaidTarget("target", 0) end},}WorldFrame:HookScript("OnMouseDown", function(self, button)    if button=="LeftButton" and IsShiftKeyDown() and IsControlKeyDown() and UnitExists("mouseover") then        local raid = (GetNumRaidMembers() > 0)		if (raid and (IsRaidLeader() or IsRaidOfficer()) or (GetNumPartyMembers()>0 and not raid)) then			EasyMenu(list, menu, "cursor", 0, 0, "MENU", 1)		end		return    end	if DropDownList1:IsShown() then DropDownList1:Hide() endend)