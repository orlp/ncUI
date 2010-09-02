local model = CreateFrame("PlayerModel", "ncUIGlow", UIParent)
model:SetScript("OnAnimFinished", function(model) model:SetModel([[spells\redradiationfog.mdx]]) end)
model:SetScript("OnEvent", function(model) model:SetModel([[spells\rake.mdx]]) end)
model:RegisterEvent("PLAYER_REGEN_ENABLED")
model:RegisterEvent("PLAYER_REGEN_DISABLED")

model:Size(500, 500)
model:SetFrameStrata("BACKGROUND")
model:SetFrameLevel(0)
model:SetPoint("LEFT")
model:SetCamera(2)
model:SetPosition(0, 0, 1)