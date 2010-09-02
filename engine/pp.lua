local F, C, L = unpack(select(2, ...))
local floor = math.floor
local noop = function() end

F.noop = noop
F.reso = GetCVar("gxResolution")
F.resowidth, F.resoheight = string.match(F.reso, "(%d+)x(%d+)")
F.px = 768/F.resoheight/C.uiscale
F.backdrop = {
	bgFile = C.media.solid,
	edgeFile = C.media.solid,
	tile = false, tileSize = 0, edgeSize = F.px,
	insets = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	}
}

local function scale(px)
	return F.px * floor(px + .5)
end

local function destroy(frame)
	if not frame.Show then return end
	frame.Show = noop
	frame:Hide()
	if frame.UnregisterAllEvents then
		frame:UnregisterAllEvents()
	end
end

local function size(frame, w, h)
	if not h then
		h = w
	end
	frame:SetSize(scale(w), scale(h))
end

local function point(obj, arg1, arg2, arg3, arg4, arg5)
	-- anyone has a more elegant way for this?
	if type(arg1)=="number" then arg1 = scale(arg1) end
	if type(arg2)=="number" then arg2 = scale(arg2) end
	if type(arg3)=="number" then arg3 = scale(arg3) end
	if type(arg4)=="number" then arg4 = scale(arg4) end
	if type(arg5)=="number" then arg5 = scale(arg5) end
	obj:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local function settemplate(frame)
	frame:SetBackdrop(F.backdrop)
	frame:SetBackdropColor(unpack(C.bg))
	frame:SetBackdropBorderColor(unpack(C.border))
end

local function createpanel(...)
	panel = CreateFrame("Frame", ...)
	settemplate(panel)
	return panel
end

local function inject(obj)
	local mt = getmetatable(obj).__index
	mt.Size = size
	mt.Point = point
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
inject(object)
inject(object:CreateTexture())
inject(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not handled[object:GetObjectType()] then
		inject(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

local function set(name, func)
	F[name] = function(self, ...) return func(...) end
end

set("Scale", scale)
set("Destroy", destroy)
set("SetTemplate", settemplate)
set("CreatePanel", createpanel)