--!optimize 2
--!nonstrict
--!native

local Nodes = require(script.Parent.Parent.Nodes)
local RunService = game:GetService("RunService")


function Nodes.ExplosionInfo.New(projectile: Nodes._Projectile, info : { [string]: any }?) : Nodes._ExplosionInfo
    info = info or {}
    
    local self = {
        FilterType = Enum.RaycastFilterType.Exclude,
        Filter = {},
    
        OriginProjectile = projectile,
    
        MultiHit = false,
        FuseTime = 0,
        Knockback = true,
        KnockbackMultiplier = 5,
        Cooldown = 1,
        Velocity = 300,
        SetDamage = false,
        FallVelocity = 1,
    
        Radius = 30,
        Color = Color3.new(),
        Transparency = 0,
    
        FireProbability = 1,
        FireInfo = info.FireInfo
    }

    if info then
        for k,v in info do
            if self[k] and k ~= "OriginProjectile" and k ~= "FireInfo" then
                self[k] = v;
            end
        end
    end

	return Nodes.Init({}, Nodes.ExplosionInfo) :: Nodes._ExplosionInfo
end


return Nodes.ExplosionInfo :: Nodes._ExplosionInfoStatic