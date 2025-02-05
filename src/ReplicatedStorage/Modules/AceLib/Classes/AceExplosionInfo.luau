--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types)
local AceFireInfo = require(script.Parent.AceFireInfo)


local AceExplosionInfo = {
    ClassName = "AceExplosionInfo",
    FilterType = Enum.RaycastFilterType.Exclude,
    Filter = {},

    OriginEntity = nil,

    MultiHit = false,
    FuseTime = nil,
    Knockback = true,
    KnockbackMultiplier = 5,
    Cooldown = 1,
    Velocity = 300,
    SetDamage = nil,
    FallVelocity = 1,

    Radius = 30,
    Color = nil,
    Transparency = nil,

    FireProbability = 1,
    FireInfo = nil

} :: Types.AceExplosionInfo


function AceExplosionInfo.New(tbl : { [string] : any? }?) : Types.AceExplosionInfo
    local self = tbl ~= nil and tbl or table.clone(AceExplosionInfo)

    if (self.FireProbability >= 0 and not self.FireInfo) then
        self.FireInfo = AceFireInfo.New()
    end

    return self :: Types.AceExplosionInfo
end


return AceExplosionInfo