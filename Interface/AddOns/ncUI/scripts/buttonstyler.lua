local F, C = select(2, ...):Fetch()

local _G = _G
local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")

local function style(self)  
	local name = self:GetName()
	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]	
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal  = _G[name.."NormalTexture"]

	Flash:SetTexture("")
	
	Button:SetCheckedTexture(C.media.button)
	Button:SetHighlightTexture(C.media.highlight)
	Button:SetPushedTexture(C.media.button)
	Button:SetNormalTexture("")

	Count:ClearAllPoints()
	Count:Place("BOTTOMRIGHT", Button, 0, 2)
	Count:SetFontObject("ncUIfont")
	
	HotKey:SetText("")
	HotKey:Hide()
	HotKey.Show = function() end
	
	Btname:SetText("")
	Btname:Hide()
	Btname.Show = function() end
	
	Border:Hide()
	
	if not _G[name.."Panel"] then
--		F:SetToolbox(self)
--		F:SetToolbox(Icon)
		self:Size(29)
		
		local panel = F:CreateFrame("Panel", name.."Panel", self)
		panel:Size(29)
		panel:Place("CENTER", self)

		Icon:SetTexCoord(.08, .92, .08, .92)
		Icon:Place("TOPLEFT", Button, 2, -2)
		Icon:Place("BOTTOMRIGHT", Button, -2, 2)
	end
	
	normal:ClearAllPoints()
	normal:Place("TOPLEFT", self)
	normal:Place("BOTTOMRIGHT", self)
end

local function stylesmallbutton(normal, button, icon, name, pet)
	button:SetCheckedTexture(C.media.button)
	button:SetHighlightTexture(C.media.highlight)
	button:SetPushedTexture(C.media.button)
	button:SetNormalTexture("")
	
	if not _G[name.."Panel"] then
--		F:SetToolbox(button)
--		F:SetToolbox(icon)
		button:Size(24)
		
		local panel = F:CreateFrame("Panel", name.."Panel", button)
		panel:Size(24)
		panel:Place("CENTER", button)
		panel:SetBackdropColor(unpack(C.general.backdrop))

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:ClearAllPoints()
		if pet then
			local autocast = _G[name.."AutoCastable"]
--			F:SetToolbox(autocast)
			autocast:Size(41, 40)
			autocast:ClearAllPoints()
			autocast:Place("CENTER", button, 0, 0)
			icon:Place("TOPLEFT", button, 2, -2)
			icon:Place("BOTTOMRIGHT", button, -2, 2)
		else
			icon:Place("TOPLEFT", button, 2, -2)
			icon:Place("BOTTOMRIGHT", button, -2, 2)
		end
	end
	
	normal:SetVertexColor(unpack(C.general.border))
	normal:ClearAllPoints()
	normal:Place("TOPLEFT", button)
	normal:Place("BOTTOMRIGHT", button)
end

local function styleshift(pet)
	for i=1, NUM_SHAPESHIFT_SLOTS do
		local name = "ShapeshiftButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture"]
		stylesmallbutton(normal, button, icon, name)
	end
end

local function stylepet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture2"]
		stylesmallbutton(normal, button, icon, name, true)
	end
end

local function usable(self)
	local name = self:GetName()
	local action = self.action
	local icon = _G[name.."Icon"]
	
	local normal  = _G[name.."NormalTexture"]
	normal:SetAlpha(1)
	
	if IsEquippedAction(action) then
		normal:SetVertexColor(.6, 1, .6)
    elseif IsCurrentAction(action) then
		normal:SetVertexColor(1, 1, 1)
	else
		normal:SetVertexColor(unpack(C.general.border))
    end
	
	local isusable, mana = IsUsableAction(action)
	if ActionHasRange(action) and IsActionInRange(action) == 0 then
		icon:SetVertexColor(0.8, 0.1, 0.1)
		return
	elseif mana then
		icon:SetVertexColor(.1, .3, 1)
		return
	elseif isusable then
		icon:SetVertexColor(.8, .8, .8)
		return
	else
		icon:SetVertexColor(.4, .4, .4)
		return
	end
end

local function onupdate(self, elapsed)
	local t = self.rangetimer
	if not t then
		self.rangetimer = 0
		return
	end
	t = t + elapsed
	if t < .2 then
		self.rangetimer = t
		return
	else
		self.rangetimer = 0
		if not ActionHasRange(self.action) then return end
		usable(self)
	end
end

hooksecurefunc("ActionButton_OnUpdate", onupdate)
hooksecurefunc("ActionButton_Update", style)
hooksecurefunc("ActionButton_UpdateUsable", usable)
hooksecurefunc("PetActionBar_Update", stylepet)
hooksecurefunc("ShapeshiftBar_OnLoad", styleshift)
hooksecurefunc("ShapeshiftBar_Update", styleshift)
hooksecurefunc("ShapeshiftBar_UpdateState", styleshift)