-- stuff related to halloween

local ishalloween = false

function IsHalloween()
	return ishalloween
end

function DaysUntilHalloween()
	local seasonmanager = GetSeasonManager()
	-- only have holidays in worlds with a season cycle
	if seasonmanager then
		-- halloween is 83.35% into summer (as calculated by TheDanaAddams)
		local halloweenday = math.min( seasonmanager.summerlength, math.ceil( seasonmanager.summerlength * 0.8335 ) )
		local daysuntilhalloween = 0

		if seasonmanager:IsSummer() then 
			daysuntilhalloween = RoundUp( halloweenday - (seasonmanager:GetDaysIntoSeason()+1) )

			-- get rid of -0 (math.ceil of a value < 0 and > -1 will give a value of -0)
			--if daysuntilhalloween == 0 then daysuntilhalloween = 0 end

			if daysuntilhalloween < 0 then
				daysuntilhalloween = seasonmanager:GetDaysLeftInSeason() + seasonmanager.winterlength + halloweenday
			end
		else
			daysuntilhalloween = halloweenday + seasonmanager:GetDaysLeftInSeason()
		end

		print( "days until halloween: "..daysuntilhalloween )

		return daysuntilhalloween
	end
end

function MakeHalloween()
	ishalloween = true

	-- halloween has a dusk that is twice as long and a night that is twice as short
	local clock = GetClock()
	local newnightsegs = clock:GetNightSegs() / 2
	local newdusksegs = clock:GetDuskSegs() * 2
	local newdaysegs = 16 - newdusksegs - newnightsegs
	clock:SetSegs( newdaysegs, newdusksegs, newnightsegs )

	GetWorld():PushEvent("halloweenstart")
end

function MakeNotHalloween()
	ishalloween = false
	GetWorld():PushEvent("halloweenend")
end

function CheckForHalloween()
	if DaysUntilHalloween() == 0 then
		--print( "it's halloween!" )
		MakeHalloween()
	else
		if IsHalloween() then
			--print( "it's no longer halloween" )
			MakeNotHalloween()
		end
	end
end