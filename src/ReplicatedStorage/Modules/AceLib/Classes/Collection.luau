--!optimize 2
--!nonstrict
--!native

local Nodes = require(script.Parent.Parent.Nodes)
local RunService = game:GetService("RunService")


function Nodes.Collection.New<T>(items: { [string]: T }) : Nodes._Collection<T>
	return Nodes.Init({}, Nodes.Collection) :: Nodes._Collection<T>
end


function Nodes.Collection.Prototype:Add()
end


function Nodes.Collection.Prototype:GetItems()

end


function Nodes.Collection.Prototype:ForEach(callback: (v, i?) -> nil)
    for 
end


function Nodes.Collection.Prototype:Filter() : Nodes._Collection
    local n = self:Clone()
end


return Nodes.Collection :: Nodes._CollectionStatic
