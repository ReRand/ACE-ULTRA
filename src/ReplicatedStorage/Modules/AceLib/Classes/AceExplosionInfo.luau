--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types)


local AceExplosionInfo = {
    ClassName = "AceExplosionInfo",
    FilterType = Enum.RaycastFilterType.Exclude,
    Filter = {},

    Multihit = false,
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
    FireDamage = 1,
    FireTick = 1,
    FireTime = 1,

} :: Types.AceExplosionInfo


function AceExplosionInfo.New(tbl : { [string] : any? }?) : Types.AceExplosionInfo
    local self = tbl ~= nil and tbl or table.clone(AceExplosionInfo);

    return self :: Types.AceExplosionInfo
end


return AceExplosionInfo