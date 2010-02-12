local _G = _G
local media = ncUIdb["media"]
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
	
	Button:SetCheckedTexture(media.button)
	Button:SetHighlightTexture(media.highlight)
	Button:SetPushedTexture(media.button)
	Button:SetNormalTexture("")

	Count:ClearAllPoints()
	Count:SetPoint("BOTTOMRIGHT", 0, 2)
	Count:SetFont(media.pixelfont, 11, "THINOUTLINE")
	
	HotKey:SetText("")
	HotKey:Hide()
	HotKey.Show = function() end
	
	Btname:SetText("")
	Btname:Hide()
	Btname.Show = function() end
	
	Border:Hide()
	
	if not _G[name.."Panel"] then
		self:SetWidth(ncUIdb:Scale(39))
		self:SetHeight(ncUIdb:Scale(39))
		
		local panel = CreateFrame("Frame", name.."Panel", self)
		ncUIdb:CreatePanel(panel, 39, 39, "CENTER", self, "CENTER", 0,0)
		panel:SetBackdropColor(0, 0, 0, 0)

		Icon:SetTexCoord(.08, .92, .08, .92)
		Icon:SetPoint("TOPLEFT", Button, 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", Button, -2, 2)
	end
	
	normal:ClearAllPoints()
	normal:SetPoint("TOPLEFT")
	normal:SetPoint("BOTTOMRIGHT")
end

local function stylesmallbutton(normal, button, icon, name, pet)
	button:SetCheckedTexture(media.button)
	button:SetHighlightTexture(media.highlight)
	button:SetPushedTexture(media.button)
	button:SetNormalTexture("")
	
	if not _G[name.."Panel"] then
		button:SetWidth(ncUIdb:Scale(pet and 36 or 34))
		button:SetHeight(ncUIdb:Scale(pet and 36 or 34))
		
		local panel = CreateFrame("Frame", name.."Panel", button)
		ncUIdb:CreatePanel(panel, (pet and 36 or 34), (pet and 36 or 34), "CENTER", button, "CENTER", 0,0)
		panel:SetBackdropColor(unpack(ncUIdb["general"].colorscheme_backdrop))

		icon:SetTexCoord(.08, .92, .08, .92)
		
		if pet then
			_G[name.."AutoCastable"]:SetWidth(ncUIdb:Scale(60))
			_G[name.."AutoCastable"]:SetHeight(ncUIdb:Scale(62))
			_G[name.."AutoCastable"]:ClearAllPoints()
			_G[name.."AutoCastable"]:SetPoint("CENTER", button, 0, 0)
			icon:SetPoint("TOPLEFT", button, 2, -2)
			icon:SetPoint("BOTTOMRIGHT", button, -3, 3)
		else
			icon:SetPoint("TOPLEFT", button, 3, -3)
			icon:SetPoint("BOTTOMRIGHT", button, -3, 3)
		end
	end
	
	normal:SetVertexColor(unpack(ncUIdb["general"].colorscheme_border))
	normal:ClearAllPoints()
	normal:SetPoint("TOPLEFT")
	normal:SetPoint("BOTTOMRIGHT")
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
		normal:SetVertexColor(unpack(ncUIdb["general"].colorscheme_border))
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

--[[local function onupdate(self, elapsed)
	if self.rangeTimer == 1 then
		usable(self)
	end
end

hooksecurefunc("ActionButton_OnUpdate", onupdate)--]]

ActionButton_OnUpdate = onupdate
hooksecurefunc("ActionButton_Update", style)
hooksecurefunc("ActionButton_UpdateUsable", usable)
hooksecurefunc("PetActionBar_Update", stylepet)
hooksecurefunc("ShapeshiftBar_OnLoad", styleshift)
hooksecurefunc("ShapeshiftBar_Update",   styleshift)
hooksecurefunc("ShapeshiftBar_UpdateState",   styleshift)