local menuFrame = CreateFrame("Frame", "SettingsMarkingFrame", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = "Clear",
    func = function() SetRaidTarget("target", 0) end},
    {text = "Skull",
    func = function() SetRaidTarget("target", 8) end},
    {text = "|cffff0000Cross|r",
    func = function() SetRaidTarget("target", 7) end},
    {text = "|cff00ffffSquare|r",
    func = function() SetRaidTarget("target", 6) end},
    {text = "|cffC7C7C7Moon|r",
    func = function() SetRaidTarget("target", 5) end},
    {text = "|cff00ff00Triangle|r",
    func = function() SetRaidTarget("target", 4) end},
    {text = "|cff912CEEDiamond|r",
    func = function() SetRaidTarget("target", 3) end},
    {text = "|cffFF8000Circle|r",
    func = function() SetRaidTarget("target", 2) end},
    {text = "|cffffff00Star|r",
    func = function() SetRaidTarget("target", 1) end},
}

WorldFrame:HookScript("OnMouseDown", function(self, button)
    if button=="LeftButton" and IsShiftKeyDown() and IsControlKeyDown() and UnitExists("mouseover") then
        local party = (GetNumPartyMembers() > 0)
        local raid = (GetNumRaidMembers() > 0)
        if(raid and (IsRaidLeader() or IsRaidOfficer()) or (party and not raid)) then
            EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 1)
        end
    end
end)