local treats = {
	pumpkincookie = 1,
	taffy = 2,
	jammypreserves = 3,
	powcake = 4,
	berries = 5,
}

if ModManager and ModManager:GetMod( "CampCuisine - AllHallows" ) ~= nil then
	print( "Trick-or-Treat: added support for "..ModInfoname( "CampCuisine - AllHallows" ) )

	treats.sugarskull = 1
	treats.candyapple = 2
	treats.kandykorn = 4
	treats.halloweencandy = 5

	treats.powcake = nil
	treats.jammypreserves = nil
	treats.berries = nil
else
	print( "Trick-or-Treat: could not find Camp Cuisine: All Hallows Edition; using default treats" )
end

return treats