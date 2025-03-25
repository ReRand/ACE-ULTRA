--!optimize 2
--!nonstrict
--!native

local Nodes = require(script.Parent.Parent.Nodes)


function Nodes.Node.Prototype:Destroy()
	if (self.Parent and self.index) then self.Parent[self.Index] = nil end
	self.Parent = nil;
	self = nil
end


function Nodes.Node.Prototype:Clone()
	
end


function Nodes.Node.Prototype:AddChild<T>(name: string, ...): T
	local node = Nodes.Spawn::<T>(name, ...)
	self.Children:Add(node)
	reutrn node
end


function Nodes.Node.New() : Nodes._Node
	return Nodes.Init({}, Nodes.Node) :: Nodes._Node
end


return Nodes.Node :: Nodes._NodeStatic
