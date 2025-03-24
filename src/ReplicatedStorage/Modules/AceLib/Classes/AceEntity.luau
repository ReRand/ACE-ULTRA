--!optimize 2
--!nocheck
--!native


local Types = require(script.Parent.Parent.Types)
local Attributes = require(game.ReplicatedStorage.Modules.Attributes)


local AceEntity = {
    ClassName = "AceEntity",
}


function AceEntity.New(Base : Player | Model, Config : AceEntityConfig) : Types.AceEntity
    local eid = Base:GetTag("EntityId")
    local player = Base:IsA("Player") and Base or game.Players.GetPlayerFromCharacter(Base);
    

    local self = {
        Base = Base,

        Health = 100,
        Metadata = {},
        
        EntityId = eid,
        Attributes = Attributes.FetchEntity(eid),

        Player = player,
        PlayerId = player and player.UserId,
        IsPlayer = not not player,

        Weapons = {},
        Perks = {},
    }

    return self :: Types.AceEntity
end


return AceEntity
