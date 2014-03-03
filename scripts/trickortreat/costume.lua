require "class"

local Costume = Class( function(self, id, name, pieces, threshold)
	self.id = id
	self.name = name
	self.pieces = pieces
	self.threshold = threshold or 0
end )

function Costume:GetCostumeName()
	return tostring(self.name)
end

function Costume:__tostring()
	return self.name and self:GetCostumeName() or tostring(self.id)
end

function Costume:GetCostumeWornValue( wornitems )
	local wornvalue = 0
	for _,wornitem in ipairs( wornitems ) do
		if self.pieces[ wornitem.prefab ] then
			wornvalue = wornvalue + self.pieces[ wornitem.prefab ]
		else
			-- any worn items that aren't part of the costume detract from it
			wornvalue = wornvalue + TUNING.TRICKORTREAT.COSTUME_WRONG_ITEM_VALUE
		end
	end

	if wornvalue < self.threshold then wornvalue = 0 end

	return wornvalue
end

return Costume