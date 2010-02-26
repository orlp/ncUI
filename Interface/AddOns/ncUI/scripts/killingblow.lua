local db = ncUIdb["killingblow"]
if not db.enable then return end
local player, msg, tracker = UnitGUID("player"), ActionStatus_DisplayMessage, CreateFrame("Frame")
tracker:SetScript("OnEvent", function(_, _, _, event, guid)	if event == "PARTY_KILL" and guid==player then msg("KILLING BLOW!") end end)
tracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")