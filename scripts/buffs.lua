local F, C, L = unpack(select(2, ...))

local mainhand, _, _, offhand = GetWeaponEnchantInfo()
local rowbuffs = 16

TemporaryEnchantFrame:ClearAllPoints()
TemporaryEnchantFrame:Point("TOPRIGHT", Minimap, "TOPRIGHT", 0, -16)
TemporaryEnchantFrame.SetPoint = F.noop

ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:Point("LEFT", Minimap)
ConsolidatedBuffs:Size(16)
ConsolidatedBuffsIcon:SetTexture(nil)
ConsolidatedBuffs.SetPoint = F.noop

TempEnchant1:ClearAllPoints()
TempEnchant2:ClearAllPoints()
TempEnchant1:Point("TOPRIGHT", Minimap, "TOPLEFT", -6, 1)
TempEnchant2:Point("RIGHT", TempEnchant1, "LEFT", -5, 0)

for i = 1, 2 do
	local border = F:CreatePanel(nil, _G["TempEnchant"..i])
	_G["TempEnchant"..i]:Size(30)
	border:Point("TOPLEFT", _G["TempEnchant"..i])
	border:Point("BOTTOMRIGHT", _G["TempEnchant"..i])
	border:SetFrameLevel(_G["TempEnchant"..i]:GetFrameLevel() - 1)
	border:SetFrameStrata(_G["TempEnchant"..i]:GetFrameStrata())
	_G["TempEnchant"..i.."Border"]:Hide()
	_G["TempEnchant"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
	_G["TempEnchant"..i.."Icon"]:Point("TOPLEFT", _G["TempEnchant"..i], 1, -1)
	_G["TempEnchant"..i.."Icon"]:Point("BOTTOMRIGHT", _G["TempEnchant"..i], -1, 1)
	_G["TempEnchant"..i.."Duration"]:ClearAllPoints()
	_G["TempEnchant"..i.."Duration"]:Point("BOTTOM", 0, -10)
	_G["TempEnchant"..i.."Duration"]:SetFontObject("ncUIfont")
end

local function stylebuffs(buttonname, index, debuff)
	local buff		= _G[buttonname..index]
	local icon		= _G[buttonname..index.."Icon"]
	local border	= _G[buttonname..index.."Border"]
	local duration	= _G[buttonname..index.."Duration"]
	local count 	= _G[buttonname..index.."Count"]

	if icon and not _G[buttonname..index.."Panel"] then
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:Point("TOPLEFT", buff, 1, -1)
		icon:Point("BOTTOMRIGHT", buff, -1, 1)

		buff:Size(30)

		duration:ClearAllPoints()
		duration:Point("BOTTOM", 0, -10)
		duration:SetFontObject("ncUIfont")
		
		count:ClearAllPoints()
		count:SetPoint("TOPLEFT", 3, -2)
		count:SetFontObject("ncUIfont")
		
		local panel = F:CreatePanel(buttonname..index.."Panel", buff)
		panel:Size(30)
		panel:SetPoint("CENTER")
		panel:SetFrameLevel(buff:GetFrameLevel() - 1)
		panel:SetFrameStrata(buff:GetFrameStrata())
	end

	if border then border:Hide() end
end





local function updatebuffanchors()
	buttonname = "BuffButton"
	local buff, previousbuff, abovebuff
	local numbuffs = 0
	for index = 1, BUFF_ACTUAL_DISPLAY do
		local buff = _G[buttonname..index]
		stylebuffs(buttonname, index, false)

		if buff.consolidated then
			if buff.parent == BuffFrame then
				buff:SetParent(ConsolidatedBuffsContainer)
				buff.parent = ConsolidatedBuffsContainer
			end
		else
			numbuffs = numbuffs + 1
			index = numbuffs
			buff:ClearAllPoints()
			if index > 1 and mod(index, rowbuffs) == 1 then
				buff:Point("TOP", abovebuff, "bottom", 0, -28)
				abovebuff = buff
			elseif index == 1 then
				local mainhand, _, _, offhand = GetWeaponEnchantInfo()
				if mainhand and offhand and not UnitHasVehicleUI("player") then
					buff:Point("RIGHT", TempEnchant2, "LEFT", -4, 0)
					abovebuff = TempEnchant1
				elseif ((mainhand and not offhand) or (offhand and not mainhand)) and not UnitHasVehicleUI("player") then
					buff:Point("RIGHT", TempEnchant1, "LEFT", -4, 0)
					abovebuff = TempEnchant1
				else
					buff:Point("TOPRIGHT", Minimap, "TOPLEFT", -5, 1)
					abovebuff = buff
				end
			else
				buff:Point("RIGHT", previousbuff, "LEFT", -4, 0)
			end
			previousbuff = buff
		end
	end
end

local function updatedebuffanchors(buttonname, index)
	local debuff = _G[buttonname..index];
	stylebuffs(buttonname, index, true)
	local dtype = select(5, UnitAura("player", index, "debuff"))      
	local color
	color = DebuffTypeColor[dtype or "none"]
	
	_G[buttonname..index.."Panel"]:SetBackdropBorderColor(color.r * .6, color.g * .6, color.b * .6)
	debuff:ClearAllPoints()
	if index == 1 then
		debuff:Point("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -6, -1)
	else
		debuff:Point("RIGHT", _G[buttonname..(index-1)], "LEFT", -4, 0)
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function() mainhand, _, _, offhand = GetWeaponEnchantInfo() end)
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("PLAYER_EVENTERING_WORLD")

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", updatebuffanchors)
hooksecurefunc("DebuffButton_UpdateAnchors", updatedebuffanchors)