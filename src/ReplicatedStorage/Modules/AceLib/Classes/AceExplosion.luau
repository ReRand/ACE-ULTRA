--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types)

local Attributes = require(game.ReplicatedStorage.Modules.Attributes)
local TweenService = game:GetService("TweenService")

local delayed = {}


function Types.AceExplosion.New(Info : Types._AceExplosionInfo?) : Types._AceExplosion
    Info = (Info or Types.AceExplosionInfo.New()) :: Types._AceExplosionInfo
    
    local self = {
        Info = Info,
        Hits = {},
        Alive = false,
    }

    return self :: Types.AceExplosion
end


function Types.AceExplosion:Prime()
end


return Types.AceExplosion
