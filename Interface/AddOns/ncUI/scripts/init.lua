local master = select(2, ...)

function master:Fetch(i)
	if i then return master[i] end
	return unpack(master)
end

function master:New(i)
	master[i] = {}
	return master[i]
end

ncUI = master