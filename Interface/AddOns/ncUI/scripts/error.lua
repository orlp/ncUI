local db, f, o = ncUIdb["error"], CreateFrame("Frame"), "No error yet."
if not db.enable then return end

f:SetScript("OnEvent", function(self, event, error)
	if db.filter[error] then
		UIErrorsFrame:AddMessage(error, 1, 0 ,0)
	else
		o = error
	end
end)

SLASH_NCERROR1 = "/error"
function SlashCmdList.NCERROR() print(o) end

UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
f:RegisterEvent("UI_ERROR_MESSAGE")
