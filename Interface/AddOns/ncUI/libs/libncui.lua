-- holders --
local F, C, L  = select(2, ...):New(1), select(2, ...):Fetch(2), select(2, ...):New(3)
local noop = function() end


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

local function scale(px)
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
	return obj
end

local function destroy(obj)
	if not obj.Show then return end
	obj.Show = noop
	obj:Hide()
	if obj.UnregisterAllEvents then
		obj:UnregisterAllEvents()
	end
end
local function toggle(obj)
	if not obj.Hide then return end
	return obj:IsShown() and obj:Hide() or obj:Show()
end
local function size(obj, w, h)
	if not tonumber(h) then
		h = w
	end
	obj:SetSize(scale(w), scale(h))
end
local function place(obj, arg1, arg2, arg3, arg4, arg5)
	if type(arg1)=="number" then arg1 = scale(arg1) end
	if type(arg2)=="number" then arg2 = scale(arg2) end
	if type(arg3)=="number" then arg3 = scale(arg3) end
	if type(arg4)=="number" then arg4 = scale(arg4) end
	if type(arg5)=="number" then arg5 = scale(arg5) end
	obj:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local function printf(...)
	print(format(...))
end

local function echo(str)
	DEFAULT_CHAT_FRAME:AddMessage(str, 1, 1, 0)
end


local function set(name, func)
	F[name] = function(self, ...) return func(...) end
end

set("Unpack", rawunpack)
set("CreateFrame", createframe)
set("Scale", scale)
set("SetTemplate", settemplate)
set("SpawnFont", spawnfont)
set("Echo", echo)
set("Printf", printf)

local function apply(object)
	getmetatable(object).__index.Size = size
	getmetatable(object).__index.Place = place
	getmetatable(object).__index.Toggle = toggle
	getmetatable(object).__index.Destroy = destroy
end
apply(CreateFrame("Frame"):CreateTexture())
apply(CreateFrame("Frame"):CreateFontString())
local handled = {}
local object = EnumerateFrames()
while true do
	if not handled[object:GetObjectType()] then
		apply(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
	if not object then break end
end