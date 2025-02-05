local Attributes = require(game.ReplicatedStorage.Modules.Attributes)
local TweenService = game:GetService("TweenService")

local delayed = {}
local AceExplosion = {}


export type AceExplosionInfo = {
    FilterType : Enum.RaycastFilterType?,
    Filter : { [number] : Instance }?
}


function AceExplosion.New(Info : AceExplosion) : AceExplosionInfo
    Info = Info and Info or {} :: AceExplosionInfo
    
    local self = {
        Info = Info
    }
end

export type AceExplosion = {
    OriginPlayer: Player?,
    Part: Part,
    ExplosionInfo: AceExplosionInfo
}
