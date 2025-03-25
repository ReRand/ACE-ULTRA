--!optimize 2
--!nonstrict
--!native

local Nodes = require(script.Parent.Parent.Nodes)


function Nodes.EntityCollection.New(...: Nodes._Entity) : Nodes._EntityCollection
	return Nodes.Init({}, Nodes.EntityCollection) :: Nodes._EntityCollection
end


return Nodes.EntityCollection :: Nodes._EntityCollectionStatic