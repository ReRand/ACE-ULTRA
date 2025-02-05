--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types)
local AceExplosionInfo = require(script.Parent.AceExplosionInfo)

local Attributes = require(game.ReplicatedStorage.Modules.Attributes)
local TweenService = game:GetService("TweenService")

local delayed = {}

local AceExplosion = {
    ClassName = "AceExplosion"
    
} :: Types.AceExplosion


function AceExplosion.New(Info : Types.AceExplosionInfo?) : Types.AceExplosion
    Info = (Info and Info or AceExplosionInfo.New()) :: Types.AceExplosionInfo
    
    local self = {
        Info = Info
    }

    return self :: Types.AceExplosion
end


function AceExplosion.Prime()
end


return AceExplosion