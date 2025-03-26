--!optimize 2
--!nonstrict
--!native

local AceLib = require(game.ReplicatedStorage.Modules.AceLib)
local Nodes = require(game.ReplicatedStorage.Modules.AceLib.Nodes)

local collection = Nodes.Collection.New({
	{ 1, "foo" },
	{ 2, "a" }
}) :: Nodes._Collection<number, string>;


collection:GetItems()


local entity = Nodes.Entity.New() :: Nodes._Entity

print(collection)
print(entity)