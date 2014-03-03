require "trickortreat.halloween"

local TrickOrTreatable = Class(function(self, inst)
	self.inst = inst
	self.trickortreater = nil
	self.trickortreaters = { }

	self.talksound = nil
	self.givetreatsound = nil
	self.refusesound = nil

	self.onoutoftreatsfn = nil
	self.onrefusefn = nil
	self.ongivetreatfn = nil
	self.ontrickortreatfn = nil
	self.cantrickortreatfn = nil

	self.treats = { seeds=1 }
	self.treats_nocostume = { rocks=1 }
	self.maxtreats = 1
	self.treatsremaining = self.maxtreats

	self.task = nil
	self.proximitytask = nil

	inst:ListenForEvent( "daycomplete", function() self:Reset() end, GetWorld() )
end)

function TrickOrTreatable:SetupMaxTreats( num )
	self.maxtreats = num
	self:RestockTreats()
end

function TrickOrTreatable:RestockTreats()
	self:SetTreatsRemaining( self.maxtreats )
end

function TrickOrTreatable:Reset()
	self:RestockTreats()
	self:ClearSeenTrickOrTreaters()
end

function TrickOrTreatable:DoDeltaTreatsRemaining( delta )
	self:SetTreatsRemaining( self.treatsremaining + delta )
end

function TrickOrTreatable:SetTreatsRemaining( num )
	self.treatsremaining = math.max( 0, math.min( self.maxtreats, num ) )

	if not self:HasTreats() then
		if self.onoutoftreatsfn then
			self.onoutoftreatsfn( self.inst )
		end
	end
end

function TrickOrTreatable:HasTreats()
	return self.treatsremaining > 0
end

function TrickOrTreatable:CanTrickOrTreat( trickortreater )
	return self:GetCantTrickOrTreatReason( trickortreater ) == nil
end

function TrickOrTreatable:ClearSeenTrickOrTreaters()
	self.trickortreaters = {}
end

function TrickOrTreatable:HasSeenTrickOrTreater( trickortreater )
	return self.trickortreaters[ trickortreater ] and table.contains( self.trickortreaters[ trickortreater ], trickortreater.components.costumed:GetCostumeID() )
end

function TrickOrTreatable:SawTrickOrTreater( trickortreater, costumeid )
	if not self.trickortreaters[ trickortreater ] then self.trickortreaters[ trickortreater ] = {} end
	table.insert( self.trickortreaters[ trickortreater ], costumeid and costumeid or trickortreater.components.costumed:GetCostumeID() )
end

function TrickOrTreatable:GetCantTrickOrTreatReason( trickortreater )
	trickortreater = trickortreater or GetPlayer()

	if TUNING.TRICKORTREAT.CAN_ONLY_TRICKORTREAT_ON_HALLOWEEN and not IsHalloween() then
		return GetString( trickortreater.prefab, "TRICKORTREAT", "NOT_HALLOWEEN" )
	elseif not TUNING.TRICKORTREAT.CAN_TRICKORTREAT_DURING_DAY and GetClock():IsDay() then
		return GetString( trickortreater.prefab, "TRICKORTREAT", "NOT_ALLOWED_DURING_DAY" )
	elseif not TUNING.TRICKORTREAT.CAN_TRICKORTREAT_DURING_NIGHT and GetClock():IsNight() then
		return GetString( trickortreater.prefab, "TRICKORTREAT", "NOT_ALLOWED_DURING_NIGHT" )
	elseif not TUNING.TRICKORTREAT.CAN_TRICKORTREAT_DURING_DUSK and GetClock():IsDusk() then
		return GetString( trickortreater.prefab, "TRICKORTREAT", "NOT_ALLOWED_DURING_DUSK" )
	elseif not self:HasTreats() then
		return GetString( trickortreater.prefab, "TRICKORTREAT", "NO_TREATS_TO_GIVE" )
	elseif self.trickortreater and self.trickortreater ~= trickortreater then
		return GetString( trickortreater.prefab, "TRICKORTREAT", "ALREADY_TRICK_OR_TREATING" )
	elseif self.cantrickortreatfn then
		return self.cantrickortreatfn( trickortreater )
	end
end

function TrickOrTreatable:CollectSceneActions(doer, actions)
	if (not TUNING.TRICKORTREAT.CAN_ONLY_TRICKORTREAT_ON_HALLOWEEN or IsHalloween()) and self.trickortreater ~= doer and not doer.trickortreating and doer.components.costumed then
		if self:CanTrickOrTreat( doer ) then
			table.insert(actions, ACTIONS.TRICKORTREAT)
		else
			table.insert(actions, ACTIONS.TRYTRICKORTREAT)
		end
	end
end

function TrickOrTreatable:EndSequence()
	if self.task then
		self.task:Cancel()
		self.task = nil
	end
	if self.proximitytask then
		self.proximitytask:Cancel()
		self.proximitytask = nil
	end
	self:SetTrickOrTreater( nil )
end

function TrickOrTreatable:TrickOrTreat( trickortreater )

	self:SetTrickOrTreater( trickortreater )

	self.task = trickortreater:DoTaskInTime(10*FRAMES, function()
		trickortreater.components.talker:Say( GetString( trickortreater.prefab, "TRICKORTREAT", "TRICK_OR_TREAT" ), 2.5 )
		if self.ontrickortreatfn then
			self.ontrickortreatfn( self.inst, trickortreater )
		end
		self.task = self.inst:DoTaskInTime( 2.5, function()
			self:CheckCostume( trickortreater )
		end)
	end)

	self.proximitytask = self.inst:DoPeriodicTask( 0.5, function() self:CheckProximity() end )

end

function TrickOrTreatable:CheckProximity()
	local maxdistsq = 100 -- 10 real dist
	if self.trickortreater and distsq( self.trickortreater:GetPosition(), self.inst:GetPosition() ) > maxdistsq then
		self:EndSequence()
	end

	-- throwing this in here as well; cancel if we can no longer trick-or-treat in the middle of trick-or-treating
	if self.trickortreater and not self:CanTrickOrTreat( self.trickortreater ) then
		self:EndSequence()
	end
end

function TrickOrTreatable:CheckCostume( trickortreater )

	-- force in a talker component
	if not self.inst.components.talker then self.inst:AddComponent("talker") end

	-- react to a new person or new costume
	if not self:HasSeenTrickOrTreater( trickortreater ) then

		self.inst.components.talker:Say( STRINGS[ string.upper(self.inst.prefab) ].TRICKORTREAT.CHECKCOSTUME, 2.5 )
		if self.talksound then
			self.inst.SoundEmitter:PlaySound(self.talksound)
		end

		if self.oncheckcostumefn then
			self.oncheckcostumefn( self.inst, trickortreater )
		end

		self.task = self.inst:DoTaskInTime( 2.5, function()
			-- accept
			if trickortreater.components.costumed:IsCostumed() then 
				local costumename = trickortreater.components.costumed:GetCostumeName()

				-- so, so hacky, but as far as I can tell this is the best way to do this
				if trickortreater.prefab == "wx78" then costumename = string.upper(costumename) end

				trickortreater.components.talker:Say( string.format( GetString( trickortreater.prefab, "TRICKORTREAT", "DRESSED_AS_SOMETHING" ), costumename ) )
				self.task = self.inst:DoTaskInTime( 2.5, function()
					self:GiveTreat( trickortreater )
				end)
			-- refuse
			else
				trickortreater.components.talker:Say( GetString( trickortreater.prefab, "TRICKORTREAT", "DRESSED_AS_NOTHING" ) )
				self.task = self.inst:DoTaskInTime( 2.5, function()
					self:Refuse( trickortreater )
				end)
			end
		end)

	-- already seen the costume, reject and end the interaction here
	else

		self.inst.components.talker:Say( STRINGS[ string.upper(self.inst.prefab) ].TRICKORTREAT.SEENCOSTUME, 2.5 )
		if self.talksound then
			self.inst.SoundEmitter:PlaySound(self.talksound)
		end

		if self.onseencostumefn then
			self.onseencostumefn( self.inst, trickortreater )
		end

		self:EndSequence()

	end

end

function TrickOrTreatable:GiveTreat( trickortreater )

	if self.givetreatsound then
		self.inst.SoundEmitter:PlaySound(self.givetreatsound)
	end

	if self.treats then

		self:DoDeltaTreatsRemaining( -1 )

		local max = 0
		for treat,weight in pairs( self.treats ) do
			if weight > max then
				max = weight
			end
		end

		-- the better the costume, the more even the weights of the treats are
		local skewed_treats = deepcopy( self.treats )
		local middle = max / 2
		for treat,weight in pairs( skewed_treats ) do
			if trickortreater.components.costumed.wornvalue >= 1 then
				local diff = (middle - weight) / 2
				diff = diff / (2 / trickortreater.components.costumed.wornvalue)
				skewed_treats[treat] = weight + diff
			end
		end

		--print( "costume", trickortreater.components.costumed.costume, trickortreater.components.costumed.wornvalue )
		--print( table.inspect( skewed_treats ) )

		local treat = SpawnPrefab( weighted_random_choice( skewed_treats ) )
		self:SetupGiveItemVelocity( treat )

		if self.inst.components.talker and STRINGS[ string.upper(self.inst.prefab) ].TRICKORTREAT.GIVETREAT ~= nil then
			self.inst.components.talker:Say( STRINGS[ string.upper(self.inst.prefab) ].TRICKORTREAT.GIVETREAT, 2.5 )
		end

		if self.ongivetreatfn then
			self.ongivetreatfn( self.inst, trickortreater, treat )
		end

	end

	self:SawTrickOrTreater( trickortreater )
	self:EndSequence()

end

function TrickOrTreatable:Refuse( trickortreater )

	if self.refusesound then
		self.inst.SoundEmitter:PlaySound(self.refusesound)
	end

	if self.treats_nocostume then
		self:DoDeltaTreatsRemaining( -1 )

		local item = SpawnPrefab( weighted_random_choice( self.treats_nocostume ) )
		self:SetupGiveItemVelocity( item )
	end

	if self.inst.components.talker and STRINGS[ string.upper(self.inst.prefab) ].TRICKORTREAT.REFUSETREAT ~= nil then
		self.inst.components.talker:Say( STRINGS[ string.upper(self.inst.prefab) ].TRICKORTREAT.REFUSETREAT, 2.5 )
	end

	if self.onrefusefn then
		self.onrefusefn( self.inst, trickortreater )
	end

	self:SawTrickOrTreater( trickortreater )
	self:EndSequence()

end

function TrickOrTreatable:SetupGiveItemVelocity( item )
	local pt = Vector3(self.inst.Transform:GetWorldPosition()) + TheCamera:GetDownVec() * 2
	
	item.Transform:SetPosition(pt:Get())
	local down = TheCamera:GetDownVec()
	local angle = math.atan2(down.z, down.x) + (math.random()*60-30)*DEGREES
	local sp = 2
	item.Physics:SetVel(sp*math.cos(angle), math.random()*3+4, sp*math.sin(angle))
end

function TrickOrTreatable:SetTrickOrTreater( trickortreater )
	if self.trickortreater then self.trickortreater.trickortreating = false end
	if trickortreater then trickortreater.trickortreating = true end

	self.trickortreater = trickortreater
end

function TrickOrTreatable:OnRemoveFromEntity()
	self:EndSequence()
end

function TrickOrTreatable:OnSave()
	local data = {}
	if self.treatsremaining ~= self.maxtreats then data.treatsremaining = self.treatsremaining end
	local trickortreaters = {}
	local references = nil
	for trickortreater,costumes in pairs(self.trickortreaters) do
		trickortreaters[ trickortreater.GUID ] = costumes

		if not references then references = {} end
		table.insert(references, trickortreater.GUID)
	end
	if next(trickortreaters) then data.trickortreaters = trickortreaters end

	return data, references
end

function TrickOrTreatable:OnLoad( data )
	if data then
		if data.treatsremaining ~= nil then
			self:SetTreatsRemaining( data.treatsremaining )
		else
			self:RestockTreats()
		end
	end
end

function TrickOrTreatable:LoadPostPass(newents, savedata)
    if savedata and savedata.trickortreaters then
        for trickortreater_guid,costumes in pairs(savedata.trickortreaters) do
            local trickortreater = newents[trickortreater_guid]
            if trickortreater then
            	trickortreater = trickortreater.entity
            	for _,costumeid in ipairs( costumes ) do
                	self:SawTrickOrTreater( trickortreater, costumeid )
            	end
            end
        end
    end
end

function TrickOrTreatable:GetDebugString()
	local s = ""
	if self:CanTrickOrTreat() then
		s = "can trick or treat"
	else
		s = "can't trick or treat: "..tostring( self:GetCantTrickOrTreatReason() )
	end
	s = s.." (trickortreater="..tostring(self.trickortreater)..", task="..tostring(self.task)..")"
	s = s.." (treats="..tostring(self.treatsremaining).."/"..tostring(self.maxtreats)..")"
	for k,v in pairs(self.trickortreaters) do
		s = s.."; seen "..tostring(k).." as "..table.concat( v, ", " )
	end
	return s
end

return TrickOrTreatable