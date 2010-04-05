local hooks = {}
local dummy = function() end
local db = ncUIdb["chat"]
local _G = getfenv(0)

local tankicon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:0:19:22:41|t"
local healicon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:20:39:1:20|t"
local dpsicon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:20:39:22:41|t"

local function addmessage(frame, text, red, green, blue, id)
	text = tostring(text) or ""
	for k,v in pairs(db.replaces) do
		text = text:gsub("|h%["..k.."%]|h", "|h"..v.."|h")
	end
	text = text:gsub("|h%[(%d+)%. .-%]|h", "|h%1|h")
	text = text:gsub("(|Hplayer.-|h)%[(.-)%]|h", "%1%2|h")
	text = text:gsub(" says:", ":")
	text = text:gsub(" whispers:", " <")
	text = text:gsub("To (|Hplayer.+|h):", "%1 >")
	text = text:gsub("(|Hplayer.+|h) has earned the achievement (.+)!", "%1 ! %2")
	local player = text:gsub("|Hplayer:([^:]+):.+|h.+", "%1")
	if UnitInParty(player) then
		local tank, heal, dps = UnitGroupRolesAssigned(player)		
		text = (tank and tankicon or heal and healicon or dps and dpsicon or "")..text
	end
	return hooks[frame](frame, text, red, green, blue, id)
end

local function hideframe(f)
	f.Show = dummy
	f:Hide()
end

local x=({ChatFrameEditBox:GetRegions()})
x[6]:SetAlpha(0)
x[7]:SetAlpha(0)
x[8]:SetAlpha(0)
ChatFrameEditBox:SetAltArrowKeyMode(nil)
ChatFrameEditBox:ClearAllPoints()
ChatFrameEditBox:SetPoint("TOPLEFT", ChatFrameEditBoxBackground)
ChatFrameEditBox:SetPoint("BOTTOMRIGHT", ChatFrameEditBoxBackground)

local function enter()
	for i=1,NUM_CHAT_WINDOWS do
		local f = _G["ChatFrame"..i]
		hideframe(_G["ChatFrame"..i.."UpButton"])
		hideframe(_G["ChatFrame"..i.."DownButton"])
		hideframe(_G["ChatFrame"..i.."BottomButton"])
		f:SetFading(false)
		f:EnableMouseWheel(true)
			_G["ChatFrame"..i]:SetUserPlaced(true)
		f:SetScript("OnMouseWheel", function(frame, delta)
			if delta > 0 and IsShiftKeyDown() then
				frame:ScrollToTop()
			elseif delta > 0 then
				frame:ScrollUp()
			elseif delta < 0 and IsShiftKeyDown() then
				frame:ScrollToBottom()
			else
				frame:ScrollDown()
			end
		end)
		hooks[f] = f.AddMessage
		f.AddMessage = addmessage
	end
	FCF_ResetChatWindows()	
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "GUILD_OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	FCF_OpenNewWindow("Whisper")
	FCF_UnDockFrame(ChatFrame3)
	FCF_SetLocked(ChatFrame3, 1)
	ChatFrame3:SetJustifyH("RIGHT")
	ChatFrame3:ClearAllPoints()
	ChatFrame3:SetPoint("TOPRIGHT", CubeRightBG, "TOPLEFT", -10, 0)
	ChatFrame3:SetPoint("BOTTOMLEFT", InfoRight, "TOPLEFT", 0, 10)
	ChatFrame3:Show()
	ChatFrame3Tab:Hide()
	ChatFrame_RemoveAllMessageGroups(ChatFrame3)
	ChatFrame_AddMessageGroup(ChatFrame3, "MONSTER_SAY")
	ChatFrame_AddMessageGroup(ChatFrame3, "MONSTER_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame3, "MONSTER_YELL")
	ChatFrame_AddMessageGroup(ChatFrame3, "MONSTER_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame3, "MONSTER_BOSS_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame3, "MONSTER_BOSS_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame3, "SYSTEM")
	ChatFrame_AddMessageGroup(ChatFrame3, "ERRORS")
	ChatFrame_AddMessageGroup(ChatFrame3, "AFK")
	ChatFrame_AddMessageGroup(ChatFrame3, "DND")
	ChatFrame_AddMessageGroup(ChatFrame3, "ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame3, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame3, "MONEY")
	ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_OFFICER")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
	ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND")
	ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
	ChatFrame_AddMessageGroup(ChatFrame3, "WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame3, "IGNORED")
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("TOPLEFT", CubeLeftBG, "TOPRIGHT", 8, 0)
	ChatFrame1:SetPoint("BOTTOMRIGHT", InfoLeft, "TOPRIGHT", 0, 10)
	SetCVar("chatLocked", 1)
	hideframe(ChatFrameMenuButton)
end

for channel, val in pairs(db.sticky_channels) do
	if val then
		ChatTypeInfo[string.upper(channel)].sticky = 1
	end
end
for i = 1,7 do
	for k,v in pairs(CHAT_FRAME_TEXTURES) do
		_G["ChatFrame"..i..v]:Hide()
	end
end 
for k in pairs(CHAT_FRAME_TEXTURES) do
	CHAT_FRAME_TEXTURES[k] = nil
end
local f = CreateFrame("Frame")
f:SetScript("OnEvent", enter)
f:RegisterEvent("PLAYER_LOGIN")

local function colorborder(r,g,b)
	ChatFrameEditBoxBackground:SetBackdropBorderColor(r,g,b)
end
hooksecurefunc("ChatEdit_UpdateHeader", function()
	local typ = DEFAULT_CHAT_FRAME.editBox:GetAttribute("chatType")
	if (typ == "CHANNEL") then
		local id = GetChannelName(DEFAULT_CHAT_FRAME.editBox:GetAttribute("channelTarget"))
		if id == 0 then
			colorborder(unpack(ncUIdb["chat"].colorscheme_editbox))
		else
			colorborder(ChatTypeInfo[typ..id].r,ChatTypeInfo[typ..id].g,ChatTypeInfo[typ..id].b)
		end
	else
		colorborder(ChatTypeInfo[typ].r,ChatTypeInfo[typ].g,ChatTypeInfo[typ].b)
	end
end)

local orig1, orig2 = {}, {}
local GameTooltip = GameTooltip
local linktypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true}
local function OnHyperlinkEnter(frame, link, ...)
	local linktype = link:match("^([^:]+)")
	if linktype and linktypes[linktype] then
		GameTooltip:SetOwner(frame, "ANCHOR_NONE")
		if frame:GetName()=="ChatFrame1" then
			GameTooltip:SetPoint("BOTTOMLEFT", CubeLeftBG, "TOPLEFT", 0, 10)
		else
			GameTooltip:SetPoint("BOTTOMRIGHT", CubeRightBG, "TOPRIGHT", 0, 10)
		end
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end
	if orig1[frame] then return orig1[frame](frame, link, ...) end
end
local function OnHyperlinkLeave(frame, ...)
	GameTooltip:Hide()
	if orig2[frame] then return orig2[frame](frame, ...) end
end
for i=1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame"..i]
	orig1[frame] = frame:GetScript("OnHyperlinkEnter")
	frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)

	orig2[frame] = frame:GetScript("OnHyperlinkLeave")
	frame:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
end

local function CreateCopyFrame()
	local frame = CreateFrame("Frame", "CopyFrame", UIParent)
	ncUIdb:CreatePanel(frame, 700, 190, "CENTER", UIParent, "CENTER", 0 ,0)
	frame:Hide()
	frame:SetFrameStrata("DIALOG")
	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -25, 5)
	local editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(999)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(690)
	editBox:SetHeight(190)
	editBox:HookScript("OnEscapePressed", function(self, key)
		frame:Hide()
	end)
	scrollArea:SetScrollChild(editBox)
	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 6, 30)
end

local function GetChatText(id)
	id = (tonumber(id) or 1)
	local cf = _G[format("ChatFrame%d",  id)]
	if id > NUM_CHAT_WINDOWS or id == 0 then
		DEFAULT_CHAT_FRAME:AddMessage("Copy: Invalid Chat Frame ID")
		return 
	end
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local tab = {}
	local lines = {cf:GetRegions()}
	for i=#lines, 1, -1 do
        if lines[i]:GetObjectType() == "FontString" then
            table.insert(tab, lines[i]:GetText())
        end
    end
    local str = table.concat(tab, "\n")
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not CopyFrame then CreateCopyFrame() end
	CopyFrame:Show()
	CopyBox:SetText(str)
	CopyBox:HighlightText()
	CopyBox:SetFocus()
end

SLASH_COPY1 = "/copy"
SlashCmdList["COPY"] = function(id) GetChatText(id) end

ChatFrameEditBox:HookScript("OnTextChanged", function(self)
	local text = self:GetText()
	if text:len() < 5 then
		if text:sub(1, 4) == "/tt " then
			local unitname, realm
			unitname, realm = UnitName("target")
			if unitname then unitname = gsub(unitname, " ", "") end
			if unitname and not UnitIsSameServer("player", "target") then
				unitname = unitname .. "-" .. gsub(realm, " ", "")
			end
			ChatFrame_SendTell((unitname or "Invalid Target"), ChatFrame1)
		end
	end
end)
