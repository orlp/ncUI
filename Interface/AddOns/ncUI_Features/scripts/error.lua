local F, C = ncUI:Fetch()
local o, holder = "No error yet.", CreateFrame("Frame")
if not C.error.enable then return end

UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
holder:RegisterEvent("UI_ERROR_MESSAGE")
holder:SetScript("OnEvent", function(event, error)
	if C.error.filter[error] then
		UIErrorsFrame:AddMessage(error, 1, 0 ,0)
	else
		o = error
	end
end)

SLASH_NCERROR1 = "/error"
function SlashCmdList.NCERROR() print(o) end