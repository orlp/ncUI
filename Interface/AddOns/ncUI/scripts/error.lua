local F, C = select(2, ...):Fetch()
local o = "No error yet."
if not C.error.enable then return end

UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
F:RegisterEvent("UI_ERROR_MESSAGE", function(event, error)
	if C.error.filter[error] then
		UIErrorsFrame:AddMessage(error, 1, 0 ,0)
	else
		o = error
	end
end)

SLASH_NCERROR1 = "/error"
function SlashCmdList.NCERROR() print(o) end