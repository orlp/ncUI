local F, C = select(2, ...):Fetch()
local mainhand, _, _, offhand = GetWeaponEnchantInfo()

TemporaryEnchantFrame:ClearAllPoints()
TemporaryEnchantFrame:Place("TOPRIGHT", UIParent, 0, -20)
TempEnchant1:ClearAllPoints()
TempEnchant2:ClearAllPoints()
TempEnchant1:Place("TOPRIGHT", Minimap, "TOPLEFT", -12, 0)
TempEnchant2:Place("RIGHT", TempEnchant1, "LEFT", -9, 0)
for i = 1, 2 do
	local f = F:CreateFrame("Panel", nil, _G["TempEnchant"..i])
	f:Size(24)
	f:Place("CENTER")	
	_G["TempEnchant"..i.."Border"]:Hide()
	_G["TempEnchant"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
	_G["TempEnchant"..i.."Icon"]:Place("TOPLEFT", _G["TempEnchant"..i], 2, -2)
	_G["TempEnchant"..i.."Icon"]:Place("BOTTOMRIGHT", _G["TempEnchant"..i], -2, 2)
	_G["TempEnchant"..i]:Size(24)
	_G["TempEnchant"..i.."Duration"]:ClearAllPoints()
	_G["TempEnchant"..i.."Duration"]:Place("BOTTOM", 1, -10)
	_G["TempEnchant"..i.."Duration"]:SetFontObject("ncUIfont")
end

local function StyleBuffs(buttonName, index, debuff)
	local buff		= _G[buttonName..index]
	local icon		= _G[buttonName..index.."Icon"]
	local border	= _G[buttonName..index.."Border"]
	local duration	= _G[buttonName..index.."Duration"]
	local count 	= _G[buttonName..index.."Count"]
	
--	F:SetToolbox(icon)
	
	if icon and not _G[buttonName..index.."Panel"] then
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:Place("TOPLEFT", buff, 2, -2)
		icon:Place("BOTTOMRIGHT", buff, -2, 2)
		
		buff:Size(24)
		
		duration:ClearAllPoints()
		duration:Place("BOTTOM", 1, -10)
		duration:SetFontObject("ncUIfont")
		
		count:ClearAllPoints()
		count:Place("BOTTOM", 1, 4)
		count:SetFontObject("ncUIfont")
		
		local panel = F:CreateFrame("Panel", buttonName..index.."Panel", buff)
		panel:Size(24)
		panel:Place("CENTER", buff)

		if debuff then
			_G[buttonName..index.."Panel"]:SetBackdropBorderColor(134/255, 12/255, 12/255)
		end
	end
	if border then border:Hide() end
end

function UpdateBuffAnchors()
	buttonName = "BuffButton"
	for index=1, BUFF_ACTUAL_DISPLAY do
		local buff = _G[buttonName..index]
		buff:ClearAllPoints()
		StyleBuffs(buttonName, index, false)
		if index == 17 then
			buff:Place("RIGHT", Minimap, "LEFT", -8, 0)
		elseif index == 1 then
			if (mainhand and not offhand) or (offhand and not mainhand) then
				buff:Place("RIGHT", TempEnchant1, "LEFT", -4, 0)
			elseif (mainhand and offhand) then
				buff:Place("RIGHT", TempEnchant2, "LEFT", -4, 0)
			else
				buff:Place("TOPRIGHT", Minimap, "TOPLEFT", -8, 2) -- diff 35
			end
		else
			buff:Place("RIGHT", _G[buttonName..(index-1)], "LEFT", -4, 0)
		end
	end
end

function UpdateDebuffAnchors(buttonName, index)
	local debuff = _G[buttonName..index];
	StyleBuffs(buttonName, index, true)
	debuff:ClearAllPoints()
	if index == 1 then
		debuff:Place("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -8, -2)
	else
		debuff:Place("RIGHT", _G[buttonName..(index-1)], "LEFT", -4, 0)
	end
end

local function UpdateTime(button, timeLeft)
	local duration = _G[button:GetName().."Duration"]
	if SHOW_BUFF_DURATIONS == "1" and timeLeft then
		if (timeLeft < 3600 and timeLeft >= 60) then
			local m = floor(timeLeft / 60 + 1)
			duration:SetFormattedText("%dm", m);
		elseif (timeLeft < 60) then
			duration:SetFormattedText("%d", timeLeft);
		else
			local h = floor(timeLeft / 3600 + 1)
			duration:SetFormattedText("%dh", h);
		end
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function() mainhand, _, _, offhand = GetWeaponEnchantInfo() end)
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("PLAYER_EVENTERING_WORLD")

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffAnchors)
hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuffAnchors)
hooksecurefunc("AuraButton_UpdateDuration", UpdateTime)