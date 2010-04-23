local F, C = select(2, ...):Fetch()
local slots = {
	left1 = {"LEFT", InfoLeft, "LEFT", 15, 1},
	left2 = {"CENTER", InfoLeft, "CENTER", 0, 1},
	left3 = {"RIGHT", InfoLeft, "RIGHT", -15, 1},
	right1 = {"LEFT", InfoRight, "LEFT", 15, 1},
	right2 = {"CENTER", InfoRight, "CENTER", 0, 1},
	right3 = {"RIGHT", InfoRight, "RIGHT", -15, 1},
}

local function formatmem(t)	
	if t > 1024 then
		return (floor(t/10.24)/100).." MB"
	else
		return floor(t).." KB"
	end
end

local contents = {
	money = {
		content = function()
			local c = GetMoney()
			local g, s, c =  math.floor(c/10000), math.floor((c%10000)/100), c%100
			return g.."|cffffd700g|r "..s.."|cffc7c7cfs|r "..c.."|cffeda55fc"
		end,
	},
	ms = {
		content = function()
			return floor(GetFramerate()).." FPS & "..select(3, GetNetStats()).." MS"
		end,
		onclick = function()
			if GameMenuFrame:IsShown() then
				HideUIPanel(GameMenuFrame)
			else
				ShowUIPanel(GameMenuFrame)
			end
		end,
	},
	mem = {
		content = function()
			local t = 0
			UpdateAddOnMemoryUsage()
			for i=1, GetNumAddOns(), 1 do
				t = t + GetAddOnMemoryUsage(i)
			end
			return formatmem(t)
		end,
		onclick = function()
			collectgarbage("collect")
		end,
		tooltip = {
			function()
				local total, mem, memory
				memory = {}
				UpdateAddOnMemoryUsage()
				total = 0
				for i = 1, GetNumAddOns() do
					mem = GetAddOnMemoryUsage(i)
					memory[i] = { select(2, GetAddOnInfo(i)), mem, IsAddOnLoaded(i) }
					total = total + mem
				end
		
				table.sort(memory, function(a, b)
					if a and b then
						return a[2] > b[2]
					end
				end)
				
				GameTooltip:AddDoubleLine("Memory usage:", formatmem(total))
				for i = 1, #memory do
					if memory[i][3] then
						GameTooltip:AddDoubleLine(memory[i][1], formatmem(memory[i][2]))
					end
				end
			end,
		},
	},
	mail = {
		content = function()
			local mail = (HasNewMail() or 0)
			if mail>0 then
				return "You've got mail"
			else
				return "No new mail"
			end
		end,
	},
	bag = {
		content = function()
			local totfree = 0
			for i=0,4 do
				totfree = totfree + GetContainerNumFreeSlots(i)
			end
			return totfree.." free"
		end,
		onclick = function()
			ToggleBackpack()
		end,
	},
	dur = {
		content = function()
			local curDur, maxDur = 0,0
			for i = 1, 20 do
				local curD, maxD = GetInventoryItemDurability(i)
				if maxD then
					curDur = curDur + curD
					maxDur = maxDur + maxD
				end
			end
			if maxDur==0 then
				return "100% dur"
			else
				return floor((curDur/maxDur)*100).."% dur"
			end
		end,
		onclick = function()
			ToggleCharacter("PaperDollFrame")
		end,
	},
	exprep = {
		content = function()
			if (UnitLevel("player")<MAX_PLAYER_LEVEL) then
				return "|cFF999999XP: "..UnitXP('player').."/"..UnitXPMax('player').." | "..string.format("%.2f", (UnitXP('player')/UnitXPMax('player')*100)).."%"
			else
				local t, _, minimum, maximum, value = GetWatchedFactionInfo()
				if not t then
					return "|cFF999999No faction watched"
				elseif ((value-minimum)==999) and ((maximum-minimum)==1000) then
					return "|cFF999999REP: "..(value-minimum).."/"..(maximum-minimum).." | 100%"
				else
					return "|cFF999999REP: "..(value-minimum).."/"..(maximum-minimum).." | "..string.format("%.2f", (value-minimum)/(maximum-minimum)*100).."%"
				end
			end
		end,
		onclick = function()
			ToggleCharacter("ReputationFrame")
		end,
	},
}

for key, val in pairs(C.datatext) do
	local parent = slots[key][2]
	local tab = contents[val]
	local pos = slots[key]
		local content, onclick, tooltip = tab.content or function() return "" end, tab.onclick or nil, tab.tooltip or nil
	local f = CreateFrame("Frame", _, parent)
	local t = f:CreateFontString(nil, "OVERLAY", "ncUIfont")
	t:Place("CENTER", f)
	t:SetTextColor(unpack(C.general.border))
	f:Place(unpack(pos))
	function f:Update(self, event, ...)
		t:SetText(string.upper(content(self, event, ...)))		
		f:SetHeight(t:GetStringHeight())
		f:SetWidth(t:GetStringWidth())
	end
	if onclick then
		f:EnableMouse(true)
		f:SetScript("OnMouseDown", function(self, button)
			onclick(button)
		end)
	end
	if tooltip then
		f:EnableMouse(true)
		f:SetScript("OnEnter", function()
			GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
			for i=1,#tooltip do
				if type(tooltip[i]) == "table" then
					GameTooltip:AddDoubleLine(tooltip[i][1],tooltip[i][2])
				elseif type(tooltip[i]) == "function" then
					tooltip[i]()
				else
					GameTooltip:AddLine(tooltip[i])
				end
			end				
			GameTooltip:Show()
		end)
		f:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	end
	f.elapsed = 0
	f:SetScript("OnUpdate", function(self, elapsed)
		f.elapsed = f.elapsed + elapsed
		if (f.elapsed>1) then
			f.elapsed = 0
			f:Update()
		end
	end)
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
end