local media = ncUIdb["media"]

StaticPopupDialogs["NCBINDINGS_CONFIRM_BINDING"] = {
	button1 = YES,
	button2 = NO,
	timeout = 0,
	hideOnEscape = 1,
	OnAccept = function() end,
	whileDead = 1
}

local function bind(self, key)
	if GetBindingFromClick(key)=="SCREENSHOT" then
		RunBinding("SCREENSHOT")
		return
	end

	if key == "LSHIFT"
	or key == "RSHIFT"
	or key == "LCTRL"
	or key == "RCTRL"
	or key == "LALT"
	or key == "RALT"
	or key == "UNKNOWN"
	or key == "LeftButton"
	or key == "RightButton"
	then return end
	
	if key == "MiddleButton" then key = "BUTTON3" end
	if key == "Button4" then key = "BUTTON4" end
	if key == "Button5" then key = "BUTTON5" end
	
	local altdown   = IsAltKeyDown() or ""
	local ctrldown  = IsControlKeyDown() or ""
	local shiftdown = IsShiftKeyDown() or ""

	if altdown==1 then altdown = "ALT-" end
	if ctrldown==1 then ctrldown = "CTRL-" end
	if shiftdown==1 then shiftdown = "SHIFT-" end
	
	key = altdown..ctrldown..shiftdown..key
	
	StaticPopupDialogs["NCBINDINGS_CONFIRM_BINDING"].OnAccept = function()	
		SetBinding(key, self.tobind)
		SaveBindings(2)
		print("|cFF00FF00"..key.." |ris now bound to |cFF00FF00"..self.tobind.."|r.")
	end
	
	local current = GetBindingAction(key)
	if current=="" or current==self.tobind then
		StaticPopupDialogs["NCBINDINGS_CONFIRM_BINDING"].OnAccept()
	else
		StaticPopupDialogs["NCBINDINGS_CONFIRM_BINDING"].text = "|cFF00FF00"..key.."|r is currently bound to |cFF00FF00"..current.."|r.\n\nBind |cFF00FF00"..key.."|r to |cFF00FF00"..self.tobind.."|r?\n"
		StaticPopup_Show("NCBINDINGS_CONFIRM_BINDING")
	end
end

local f = CreateFrame("Frame", "ncBindingsframe", UIParent)
ncUIdb:CreatePanel(f, 240, 204, "CENTER", UIParent, "CENTER", 0, 0)

local bf = CreateFrame("Button", _, f)
ncUIdb:CreatePanel(bf, 240, 65, "BOTTOM", f, "TOP", 0, 7)

local g, h = CreateFrame("Frame", _, bf), CreateFrame("Frame", _, bf)
ncUIdb:CreatePanel(g, 3, 7, "BOTTOM", f, "TOP", -80.3, 0)
ncUIdb:CreatePanel(h, 3, 7, "BOTTOM", f, "TOP", 79.7, 0)

bf:EnableMouse(true)
bf:EnableKeyboard(true)
bf:EnableMouseWheel(true)
bf:Hide()

bf.closebutton = CreateFrame("Button", _, bf, "UIPanelCloseButton")
bf.closebutton:SetPoint("TOPRIGHT", bf, "TOPRIGHT", 1, 0)
bf.closebutton:SetWidth(20)
bf.closebutton:SetHeight(20)

bf.any = bf:CreateFontString(nil, "OVERLAY")
bf.any:SetFont(media.font, 10)
bf.any:SetPoint("TOP", bf, "TOP", 0, -10)
bf.any:SetText("Press any key to bind.")

bf.spelltext = bf:CreateFontString(nil, "OVERLAY")
bf.spelltext:SetFont(media.font, 12)
bf.spelltext:SetPoint("TOP", bf.any, "BOTTOM", 0, -8)
bf.spelltext:SetTextColor(0, 1, 0)

bf.current = bf:CreateFontString(nil, "OVERLAY")
bf.current:SetFont(media.font, 10)
bf.current:SetPoint("TOP", bf.spelltext, "BOTTOM", 0, -8)
bf.current:SetText("For mouse/scrollwheel hover over this frame.")

bf:HookScript("OnHide", function() StaticPopup_Hide("NCBINDINGS_CONFIRM_BINDING") end)
bf:SetScript("OnMousedown", bind)
bf:SetScript("OnKeyDown", bind)
bf:SetScript("OnMouseWheel", function(self, key)
	if key > 0 then
		bind(self, "MOUSEWHEELUP")
	else
		bind(self, "MOUSEWHEELDOWN")
	end
end)

local function openbindingsframe(tobind)
	bf.tobind = tobind
	bf.spelltext:SetText(bf.tobind)
	bf:Show()
end

local function onenter(self)
	if GetCursorInfo() then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	if self.type=="spell" then
		GameTooltip:SetSpell(self.id, "BOOKTYPE_SPELL")
	elseif self.type=="item" then
		GameTooltip:SetHyperlink(select(2,GetItemInfo(self.id)))
	elseif self.type=="macro" then
		GameTooltip:SetText(GetMacroInfo(self.id))
	end
end

local function onreceivedrag(self)
	local texture, macrotext
	if GetCursorInfo()=="spell" then
		local spellbookslot = select(2,GetCursorInfo())
		texture = GetSpellTexture(spellbookslot, "BOOKTYPE_SPELL")
		self.type = "spell"
		self.id = spellbookslot
	elseif GetCursorInfo()=="item" then
		local itemid = select(2,GetCursorInfo())
		texture = select(10,GetItemInfo(itemid))
		self.type = "item"
		self.id = itemid
	elseif GetCursorInfo()=="macro" then
		local macroid = select(2,GetCursorInfo())
		macrotext, texture = GetMacroInfo(macroid)
		self.type = "macro"
		self.id = macroid
	end
	
	if texture then
		self.icon:SetTexture(texture)
	end
	
	if macrotext then
		self.text:SetText(macrotext)
	else
		self.text:SetText("")
	end
	
	ClearCursor()
	onenter(self)
end

local function onstartdrag(self)
	if self.type=="macro" then
		PickupMacro(self.id)
	elseif self.type=="item" then
		PickupItem(self.id)
	elseif self.type=="spell" then
		PickupSpell(self.id, "BOOKTYPE_SPELL")
	end	
	
	self.icon:SetTexture(nil)
	self.text:SetText("")
	self.type = nil
	self.id = nil
end

local function onclick(self)
	if GetCursorInfo() then
		self:GetScript("OnReceiveDrag")(self)
	elseif self.type then			
		local tobind = ""
		if self.type=="spell" then
			tobind = "SPELL "..GetSpellName(self.id, "BOOKTYPE_SPELL")
		elseif self.type=="item" then
			tobind = "ITEM "..GetItemInfo(self.id)
		elseif self.type=="macro" then
			tobind = "MACRO "..GetMacroInfo(self.id)
		end
		
		if click=="RightButton" then
			local a = {}
			for i=1, 10000 do
				a[i] = select(i,GetBindingKey(tobind))
				if not a[i] then break end
			end
			for i=1,#a do
				SetBinding(a[i])
			end
			print("All bindings cleared for |cFF00FF00"..tobind.."|r.")
		else
			openbindingsframe(tobind)
		end
	end
end

local function setupbutton(self)
	self:SetWidth(36)
	self:SetHeight(36)
	self:RegisterForClicks("AnyUp")
	self:RegisterForDrag("LeftButton")
	
	self.icon = self:CreateTexture()
	self.icon:SetWidth(30)
	self.icon:SetHeight(30)	
	self.icon:SetTexCoord(.08, .92, .08, .92)
	self.icon:SetPoint("TOPLEFT", self, 3, -3)
	self.icon:SetPoint("BOTTOMRIGHT", self, -3, 3)
	self.icon:SetTexture(texture)
	
	self.text = self:CreateFontString(nil, "OVERLAY")
	self.text:SetFont(media.font, 10, "THINOUTLINE")
	self.text:SetPoint("BOTTOMRIGHT", -2, 5)
	
	self:SetHighlightTexture(media.button_hover)
	self:SetNormalTexture(media.button_grey)
	
	self:SetScript("OnReceiveDrag", onreceivedrag)
	self:SetScript("OnDragStart", onstartdrag)
	self:SetScript("OnEnter", onenter)
	self:SetScript("OnClick", onclick)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	local texture, macrotext
	if self.type=="spell" then
		texture = GetSpellTexture(self.id, "BOOKTYPE_SPELL")
	elseif self.type=="item" then
		texture = select(10,GetItemInfo(self.id))
	elseif self.type=="macro" then
		macrotext, texture = GetMacroInfo(self.id)
		self.type = "macro"
	end
	
	if texture then
		self.icon:SetTexture(texture)
	end
	
	if macrotext then
		self.text:SetText(macrotext)
	else
		self.text:SetText("")
	end
end

local a = CreateFrame("Frame")
a:RegisterEvent("PLAYER_ENTERING_WORLD")
a:SetScript("OnEvent", function()
	ncBindings = ncBindings or {}
	local newrowbutton, lastbutton
	for i=1,30 do
		if not ncBindings[i] then ncBindings[i] = {type = false, id = false} end
		local btn = CreateFrame("Button", "ncButton"..i, f, "SecureActionButtonTemplate")
		btn.type = ncBindings[i].type
		btn.id = ncBindings[i].id
		setupbutton(btn)
		if i==1 then
			btn:SetPoint("TOPLEFT", 10, -10)
			lastbutton, newrowbutton = btn, btn
		elseif (i-1)/6==floor((i-1)/6) then
			btn:SetPoint("TOP", newrowbutton, "BOTTOM", 0, -1)
			lastbutton, newrowbutton = btn, btn
		else
			btn:SetPoint("LEFT", lastbutton, "RIGHT", 1, 0)
			lastbutton = btn
		end	
		ncBindings[i] = btn
	end
	a:UnregisterAllEvents()
	a:SetScript("OnEvent", nil)
	f:Hide()
end)

SLASH_NCBIND1 = "/bind"
SlashCmdList.NCBIND = function() if f:IsShown() then f:Hide() else f:Show() end end