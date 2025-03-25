--!optimize 2
--!nonstrict
--!native

local AceLib = require(game.ReplicatedStorage.Modules.AceLib)
local Nodes = require(game.ReplicatedStorage.Modules.AceLib.Nodes)

local entity = AceLib.CreateNode("Entity") :: Nodes._Entity

entity:Kill("a")