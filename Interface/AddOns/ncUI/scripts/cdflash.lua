local bar = CreateFrame("Frame", "ncCooldownBar", UIParent)
ncUIdb:CreatePanel(bar, 535, 20, "BOTTOM", ActionBarBackground, "TOP", 0, 4)

local flash = CreateFrame("Frame", nil, UIParent)
flash:SetPoint("CENTER", UIParent)
flash:SetSize(ncUIdb:Scale(100),ncUIdb:Scale(100))
ncUIdb:SetTemplate(flash)
flash.icon = flash:CreateTexture(nil, "OVERLAY")
flash.icon:SetPoint("TOPLEFT", ncUIdb:Scale(2), ncUIdb:Scale(-2))
flash.icon:SetPoint("BOTTOMRIGHT", ncUIdb:Scale(-2), ncUIdb:Scale(2))
flash.icon:SetTexCoord(.08, .92, .08, .92)
flash:Hide()
flash:SetScript("OnUpdate", function(self, e)
	flash.e = flash.e + e
	if flash.e > .75 then
		flash:Hide()
	elseif flash.e < .25 then
		flash:SetAlpha(flash.e*4)
	elseif flash.e > .5 then
		flash:SetAlpha(1-(flash.e%.5)*4)
	end
end)

local tracker = CreateFrame("Frame", "ncCooldownTracker", UIParent)
local band = bit.band
local petflags = COMBATLOG_OBJECT_TYPE_PET
local mine = COMBATLOG_OBJECT_AFFILIATION_MINE
local spells = {}
local items = {}
local watched = {}
local nextupdate, lastupdate = 0, 0

local function start(id, duration, item)
	watched[id] = {
		["dur"] = duration,
		["item"] = item,
	}
	if nextupdate < 0 or duration < nextupdate then
		nextupdate = duration
	end
	tracker:Show()
end
local function stop(id, item)
	local texture
	if item then
		texture = GetItemIcon(id)
	else
		texture = select(3, GetSpellInfo(id))
	end
	flash.icon:SetTexture(texture)
	flash.e = 0
	flash:Show()

	watched[id] = nil
end

-- events --
function tracker:SPELL_UPDATE_COOLDOWN()
	for id, name in next, spells do
		local _, duration, enabled = GetSpellCooldown(name)

		if enabled == 1 and duration > 1.5 then
			if not watched[id] then
				start(id, duration, false)
			end
		elseif enabled == 1 and watched[id] then
			stop(id, false)
		end
	end
end
function tracker:BAG_UPDATE_COOLDOWN()
	for id, name in next, items do
		local _, duration, enabled = GetItemCooldown(id)
		if enabled == 1 and duration > 10 and not watched[id] then
			start(id, duration, true)
		elseif duration==0 and enabled==1 and watched[id] then
			stop(id, true)
		end
	end
end
function tracker:UNIT_SPELLCAST_SUCCEEDED(unit, name, rank)
	if (unit == "player") then
		local link = GetSpellLink(name, rank) or ""
		local id = string.match(link, ":(%w+)")
		if not id then return end
		spells[id] = name
	end
end
function tracker:COMBAT_LOG_EVENT_UNFILTERED(_, event, _, _, sourceflags, _, _, _, id, name)
    if event == "SPELL_CAST_SUCCESS" then
        if band(sourceflags, petflags) == petflags and band(sourceflags, mine) == mine then
            spells[id] = name
        end
    end
end
tracker:BAG_UPDATE_COOLDOWN()
tracker:SPELL_UPDATE_COOLDOWN()
tracker:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
tracker:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
tracker:RegisterEvent("SPELL_UPDATE_COOLDOWN")
tracker:RegisterEvent("BAG_UPDATE_COOLDOWN")
PetActionButton1:HookScript("OnShow", function() tracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end)
PetActionButton1:HookScript("OnHide", function() tracker:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end)
hooksecurefunc("UseAction", function(slot)
	local action, id = GetActionInfo(slot)
	if (action == "item") then
		items[id] = GetItemInfo(id)
	end
end)
hooksecurefunc("UseInventoryItem", function(slot)
	local link = GetInventoryItemLink("player", slot) or ""
	local id, name = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	if id then
		items[id] = name
	end
end)
hooksecurefunc("UseContainerItem", function(bag, slot)
	local link = GetContainerItemLink(bag, slot) or ""
	local id, name = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	if id then
		items[id] = name
	end
end)
local function onupdate(self, elapsed)
	nextupdate = nextupdate - elapsed
	lastupdate = lastupdate + elapsed
	if nextupdate > 0 then return end

	for id, tab in next, watched do
		local duration = watched[id].dur - lastupdate
		if duration < 0 then
			stop(id, watched[id].item)
		else
			watched[id].dur = duration
			if nextupdate < 0 or duration < nextupdate then
				nextupdate = duration
			end
		end
	end
	
	if nextupdate < 0 then self:Hide() end
end
tracker:SetScript("OnUpdate", onupdate)
tracker:Hide()