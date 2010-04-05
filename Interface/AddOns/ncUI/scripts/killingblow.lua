local F, C = select(2, ...):Fetch()

if not C.killingblow.enable then return end
local player, tracker = UnitGUID("player"), CreateFrame("Frame")

tracker:SetScript("OnEvent", function(_, _, _, event, guid)
	if event == "PARTY_KILL" and guid==player then
		ActionStatus_DisplayMessage("KILLING BLOW!")
	end
end)

tracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
