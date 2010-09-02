local holder, lasterror, db = CreateFrame("Frame"), "No error yet.", {
	["mode"] = "whitelist", -- This defines the mode of filtering. Options are whitelist and blacklist.
	[ERR_INV_FULL] = true, -- All errors can be found on http://www.wowwiki.com/WoW_Constants/Errors
}

holder:SetScript("OnEvent",function(holder, event, error)
	if db.mode == "blacklist" and not db[error] or db.mode=="whitelist" and db[error] then
		UIErrorsFrame:AddMessage(error, 1, 0, 0)
	else
		lasterror = error
	end
end)

SLASH_NCERROR1 = "/error"
function SlashCmdList.NCERROR() UIErrorsFrame:AddMessage(lasterror, 1, 0, 0) end

UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
holder:RegisterEvent("UI_ERROR_MESSAGE")