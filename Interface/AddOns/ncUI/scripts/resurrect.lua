local F, C = select(2, ...):Fetch()
if not C.resurrect.enable then return end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	if (event=="PLAYER_DEAD") then
		if (tostring(GetZoneText()) == "Wintergrasp") then
			RepopMe()
		end
		for i=1,MAX_BATTLEFIELD_QUEUES do
			local a = select(1, GetBattlefieldStatus(i))
			if (a == "active") then
				RepopMe()
			end
		end
	else
		AcceptResurrect()
		StaticPopup1:Hide()
	end
end)

f:RegisterEvent("PLAYER_DEAD")
f:RegisterEvent("RESURRECT_REQUEST")
