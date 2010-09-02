local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	if (tostring(GetZoneText()) == "Wintergrasp") then
		RepopMe()
	end
	for i=1,MAX_BATTLEFIELD_QUEUES do
		local a = select(1, GetBattlefieldStatus(i))
		if (a == "active") then
			RepopMe()
		end
	end
end)

f:RegisterEvent("PLAYER_DEAD")