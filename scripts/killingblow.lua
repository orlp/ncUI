local player, tracker = UnitGUID("player"), CreateFrame("Frame")

tracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
tracker:SetScript("OnEvent", function(_, _, _, event, guid)
	if event == "PARTY_KILL" and guid==player then
		ActionStatus_DisplayMessage("KILLING BLOW!")
	end
end)

