--!optimize 2
--!nocheck
--!native


local Types = require(script.Parent.Parent.Types)
local Class = require(script.Parent.Parent.Class)
local Attributes = require(game.ReplicatedStorage.Modules.Attributes)


function Types.AceEntity.New(Base : Player | Model, Config : Types._AceEntityConfig?) : Types._AceEntity
    local eid = Base:GetTag("EntityId")
    local player = Base:IsA("Player") and Base or game.Players.GetPlayerFromCharacter(Base)
    Config = Config or {}

    local self = {
        Base = Base,

        Health = 100,
        Metadata = Config.Metadata or {},
        
        EntityId = eid,
        Attributes = Attributes.FetchEntity(eid),

        Player = player,
        PlayerId = player and player.UserId,
        IsPlayer = not not player,

        Weapons = {},
        Perks = {},
    }

    return Class.Init<Types._AceEntity>(self, Types.AceEntity)
end


return Types.AceEntity
