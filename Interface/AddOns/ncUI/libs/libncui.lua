-- holders --
local F, C, L  = select(2, ...):New(1), select(2, ...):Fetch(2), select(2, ...):New(3)

local addon = CreateFrame("Frame")
local noop = function() end
local callbacks = {
	["update"] = {},
	["events"] = {},
}

-- localized for the speed --
local floor = math.floor


-- constants --
F.RESOLUTION = GetCVar("gxResolution")
F.RESOWIDTH, F.RESOHEIGHT = string.match(F.RESOLUTION, "(%d+)x(%d+)")
F.PP = 768/F.RESOHEIGHT/C.general.uiscale

F.BACKDROP = {
	bgFile = C.media.solid,
	edgeFile = C.media.solid,
	tile = false, tileSize = 0, edgeSize = F.PP,
	insets = {
		left = -F.PP,
		right = -F.PP,
		top = -F.PP,
		bottom = -F.PP,
	}
}


-- hooks & events --
local function fire(obj, script, ...)
	if not obj.GetScript then return false end
	
	local handler = obj:GetScript(script)
	if handler then
		handler(obj, script, ...)
		return true
	end
	return false
end

local function hook(tab, func, mode, hookfunc)
	if type(tab)=="table" then
		if not tab[func] then return end
	else
		hookfunc = mode
		mode = func
		func = tab
		tab = _G
	end

	local orig = tab[func]
	if mode=="pre" then
		tab[func] = function(...)
			hookfunc(...)
			orig(...)
		end
	elseif mode=="pre-feed" then
		tab[func] = function(...)
			orig(hookfunc(...))
		end
	elseif mode=="post-feed" then
		tab[func] = function(...)
			hookfunc(orig(...))
		end
	else
		tab[func] = function(...)
			orig(...)
			hookfunc(...)
		end
	end
end

local function registerevent(event, handler)
	if not callbacks.events[event] then
		callbacks.events[event] = {}
		addon:RegisterEvent(event)
	end
	local index = #callbacks.events[event] + 1
	callbacks.events[event][index] = handler
	return index
end

local function unregisterevent(event, index)
	if not callbacks.events[event] then return end
	callbacks.events[event][index] = nil
	if not next(callbacks.events[event]) then
		callbacks.events[event] = nil
		addon:UnregisterEvent(event)
	end
end

addon:SetScript("OnUpdate", function(_, elapsed)
	for index, handler in next, callbacks.update do
		handler(elapsed)
	end
end)
addon:SetScript("OnEvent", function(_, event, ...)
	if not callbacks.events[event] then return end
	for index, handler in next, callbacks.events[event] do
		handler(event, ...)
	end
end)

local function fireevent(obj, event, ...)
	if type(obj)=="number" then
		if not callbacks.events[event] or not callbacks.events[event][obj] then
			return false
		end
		callbacks.events[event][obj](event, ...)
		return true
	end

	if not obj.GetScript then return false end

	local handler = obj:GetScript("OnEvent")
	if handler then
		handler(obj, event, ...)
		return true
	end
	return false
end

local function registerupdate(handler)
	if type(handler)~="function" then return end
	local index = #callbacks.update
	callbacks.update[index] = handler
	return index
end

local function unregisterupdate(index)
	callbacks.update[index] = nil
end

-- useful lua extensions --
local function rawunpack(tab)
	local temp = {}
	local index = 1
	for _, val in next, tab do
		temp[index] = val
		index = index + 1
	end
	return unpack(temp)
end

-- graphics & frames --
local function destroy(obj)
	if not obj.Show then return end
	obj.Show = noop
	obj:Hide()
	if obj.UnregisterAllEvents then
		obj:UnregisterAllEvents()
	end
end

local function lock(obj)
	obj.ClearAllPoints = noop
	obj.SetPoint = noop
	obj.SetAllPoints = noop
end

local function unlock(obj)
	obj.ClearAllPoints = nil
	obj.SetPoint = nil
	obj.SetAllPoints = nil
end

local function round(num)
	return floor(num + .5)
end

local function scale(px, ign)
	if ign then return end
	return F.PP * floor(px + .5)
end

local function spawnfont(obj, name, layer)
	return obj:CreateFontString(name, layer or "OVERLAY", "ncUIfont")
end

local function settemplate(obj)
	obj:SetBackdrop(F.BACKDROP)
	obj:SetBackdropColor(unpack(C.general.backdrop))
	obj:SetBackdropBorderColor(unpack(C.general.border))
end

local function toggle(obj)
	if not obj.Hide then return end
	if obj:IsShown() then
		obj:Hide()
		return false
	end
	obj:Show()
	return true
end

local function settoolbox(...)
	for i=1, select("#", ...) do
		local obj = select(i, ...)
		obj.SetTemplate = settemplate
		obj.SpawnFont = spawnfont
		obj.Destroy = destroy
		obj.Lock = lock
		obj.Unlock = unlock
		obj.Toggle = toggle
		if obj.GetScript then
			obj.Fire = fire
			if obj.RegisterEvent then
				obj.FireEvent = fireevent
			end
		end
		
		hook(obj, "SetSize", "pre-feed", function(obj, w, h, ign)
			local ign = ign
			if not tonumber(h) then
				ign = h
				h = w
			end
			return obj, scale(w, ign), scale(h, ign)
		end)

		hook(obj, "SetWidth", "pre-feed", function(obj, w, ign) return obj, scale(w, ign) end)
		hook(obj, "SetHeight", "pre-feed", function(obj, h, ign) return obj, scale(h, ign) end)
		hook(obj, "SetPoint", "pre-feed", function(obj, ...)
			local point = {...}
			local num = #point
			local ign = point[num]==true
			for i=1, num do
				local px = tonumber(point[i])
				if px then
					point[i] = scale(px, ign)
				end
			end
			return obj, unpack(point)
		end)
	end
end

local function createframe(class, ...)
	local obj
	if class=="Panel" then
		obj = CreateFrame("Frame", ...)
		obj:SetFrameStrata("BACKGROUND")
		obj:SetFrameLevel(1)
		settemplate(obj)
	else
		obj = CreateFrame(class, ...)
	end
	settoolbox(obj)
	return obj
end

local function fprint(...)
	print(format(...))
end

-- ncui only --
local function echo(str)
	DEFAULT_CHAT_FRAME:AddMessage(str, 1, 1, 0)
end


-- lib householding --
local function set(name, func)
	F[name] = function(self, ...) return func(...) end
end

set("Fire", fire)
set("Hook", hook)
set("RegisterEvent", registerevent)
set("UnregisterEvent", unregisterevent)
set("FireEvent", fireevent)
set("RegisterUpdate", registerupdate)
set("UnregisterUpdate", unregisterupdate)
set("RawUnpack", rawunpack)
set("Localize", localize)
set("CreateFrame", createframe)
set("SetToolbox", settoolbox)
set("Scale", scale)
set("SetTemplate", settemplate)
set("SpawnFont", spawnfont)
set("Destroy", destroy)
set("Lock", lock)
set("Unlock", unlock)
set("Toggle", toggle)
set("Echo", echo)
set("Fprint", fprint)
