local treats = {
	pumpkincookie = 1,
	taffy = 2,
	jammypreserves = 3,
	powcake = 4,
	berries = 5,
}

local function IsModEnabled(name)
	for _, moddir in ipairs( _G.KnownModIndex:GetModsToLoad() ) do
		local its_modinfo = _G.KnownModIndex:GetModInfo(moddir)
		if its_modinfo.name == name then
			return true
		end
	end
	return false
end

local campcuisinename = "Camp Cuisine: All Hallows Edition"
if IsModEnabled( campcuisinename ) then
	print( "Trick-or-Treat: added support for "..campcuisinename )

	treats.sugarskull = 1
	treats.candyapple = 2
	treats.kandykorn = 4
	treats.halloweencandy = 5

	treats.powcake = nil
	treats.jammypreserves = nil
	treats.berries = nil
else
	print( "Trick-or-Treat: could not find "..campcuisinename.."; using default treats" )
end

return treats