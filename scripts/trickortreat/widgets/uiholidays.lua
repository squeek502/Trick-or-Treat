local UIClock = require "widgets/uiclock"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"

local UIClock_ctor_base = UIClock._ctor
UIClock._ctor = function( self, ... )
	UIClock_ctor_base( self, ... )

    self.holidayanim = self:AddChild(UIAnim())
    self.holidayanim:MoveToBack()
    self.holidayanim:SetRotation( -50 )
    self.holidayanim:SetPosition(-10,20,0)
    --self.moonanim:SetScale(.4,.4,.4)
    self.holidayanim:GetAnimState():SetBank("moon_phases_clock")
    self.holidayanim:GetAnimState():SetBuild("moon_phases_clock")
    self.holidayanim:GetAnimState():PlayAnimation("hidden")

    self.holidaytext = self:AddChild(Text(NUMBERFONT, 30/self.base_scale))
    self.holidaytext:SetPosition(-81,-32,0)
    self.holidaytext:Hide()

    self.holidayanim.OnGainFocus = function()
        self.holidaytext:Show()
    end
    self.holidayanim.OnLoseFocus = function()
        self.holidaytext:Hide()
    end

	self.inst:ListenForEvent( "halloweenstart", function(inst, data) 
        self:ShowHoliday( "halloween", "Halloween" )
    end, GetWorld())

	self.inst:ListenForEvent( "halloweenend", function(inst, data) 
        self:HideHoliday()
    end, GetWorld())
end

UIClock.ShowHoliday = function(self, holiday, name)
    self.holidayanim:GetAnimState():OverrideSymbol("swap_moon", "holidays", holiday)        
    self.holidayanim:GetAnimState():PlayAnimation("trans_out") 
    self.holidayanim:GetAnimState():PushAnimation("idle", true) 

    self.holidaytext:SetString( name )
end

UIClock.HideHoliday = function(self)
	self.holidayanim:GetAnimState():PlayAnimation("trans_in") 
    self.holidayanim:GetAnimState():PushAnimation("hidden", true) 

    self.holidaytext:SetString( "" )
end

return UIClock