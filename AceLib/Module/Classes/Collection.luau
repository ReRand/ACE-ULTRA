--!optimize 2
--!nonstrict
--!native

local Nodes = require(script.Parent.Parent.Nodes)
local RunService = game:GetService("RunService")


function Nodes.Collection.New<K,V>(items: { [number]: { [number]: K | V } }) : Nodes._Collection<K,V>
	return Nodes.Init(items, Nodes.Collection) :: Nodes._Collection<K,V>
end


function Nodes.Collection.Prototype:Add<K,V>(key: K, value: V): Nodes._CollectionItem<K,V>
end


function Nodes.Collection.Prototype:GetItems<K,V>() : { [K]: V }
end


function Nodes.Collection.Prototype:ForEach(callback: (k: any, v: any, i: number?) -> nil)

end


function Nodes.Collection.Prototype:Filter()
	local n = self:Clone()
end


return Nodes.Collection :: Nodes._CollectionStatic