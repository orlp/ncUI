local mainhand, _, _, offhand = GetWeaponEnchantInfo()

TemporaryEnchantFrame:ClearAllPoints()
TemporaryEnchantFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, -20)
TempEnchant1:ClearAllPoints()
TempEnchant2:ClearAllPoints()
TempEnchant1:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -12, 0)
TempEnchant2:SetPoint("RIGHT", TempEnchant1, "LEFT", -9, 0)
for i = 1, 2 do
	local f = CreateFrame("Frame", nil, _G["TempEnchant"..i])
	ncUIdb:CreatePanel(f, 34, 34, "CENTER", _G["TempEnchant"..i], "CENTER", 0, 0)	
	_G["TempEnchant"..i.."Border"]:Hide()
	_G["TempEnchant"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
	_G["TempEnchant"..i]:SetHeight(28)
	_G["TempEnchant"..i]:SetWidth(28)	
	_G["TempEnchant"..i.."Duration"]:ClearAllPoints()
	_G["TempEnchant"..i.."Duration"]:SetPoint("BOTTOM", 0, -16)
	_G["TempEnchant"..i.."Duration"]:SetFont(ncUIdb["media"].pixelfont, 11)
end

local function StyleBuffs(buttonName, index, debuff)
	local buff		= _G[buttonName..index]
	local icon		= _G[buttonName..index.."Icon"]
	local border	= _G[buttonName..index.."Border"]
	local duration	= _G[buttonName..index.."Duration"]
	local count 	= _G[buttonName..index.."Count"]
	if icon and not _G[buttonName..index.."Panel"] then
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetPoint("TOPLEFT", buff, ncUIdb:Scale(2), ncUIdb:Scale(-2))
		icon:SetPoint("BOTTOMRIGHT", buff, ncUIdb:Scale(-2), ncUIdb:Scale(2))
		
		buff:SetHeight(ncUIdb:Scale(25))
		buff:SetWidth(ncUIdb:Scale(25))
		
		duration:ClearAllPoints()
		duration:SetPoint("BOTTOM", ncUIdb.mult, ncUIdb:Scale(-10))
		duration:SetFont(ncUIdb["media"].pixelfont, 11, "THINOUTLINE")
		
		count:ClearAllPoints()
		count:SetPoint("BOTTOM", ncUIdb.mult, ncUIdb:Scale(3))
		count:SetFont(ncUIdb["media"].pixelfont, 11, "THINOUTLINE")
		
		local panel = CreateFrame("Frame", buttonName..index.."Panel", buff)
		ncUIdb:CreatePanel(panel, 25, 25, "CENTER", buff, "CENTER", 0,0)

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
			buff:SetPoint("RIGHT", Minimap, "LEFT", ncUIdb:Scale(-8), 0)
		elseif index == 1 then
			if (mainhand and not offhand) or (offhand and not mainhand) then
				buff:SetPoint("RIGHT", TempEnchant1, "LEFT", ncUIdb:Scale(-6), 0)
			elseif (mainhand and offhand) then
				buff:SetPoint("RIGHT", TempEnchant2, "LEFT", ncUIdb:Scale(-6), 0)
			else
				buff:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", ncUIdb:Scale(-8), ncUIdb:Scale(2)) -- diff 35
			end
		else
			buff:SetPoint("RIGHT", _G[buttonName..(index-1)], "LEFT", ncUIdb:Scale(-6), 0)
		end
	end
end

function UpdateDebuffAnchors(buttonName, index)
	local debuff = _G[buttonName..index];
	StyleBuffs(buttonName, index, true)
	debuff:ClearAllPoints()
	if index == 1 then
		debuff:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", ncUIdb:Scale(-8), ncUIdb:Scale(-2))
	else
		debuff:SetPoint("RIGHT", _G[buttonName..(index-1)], "LEFT", ncUIdb:Scale(-6), 0)
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