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


function Nodes.Node.Prototype:AddChild(name: string, ...): Nodes._Node
	local node = Nodes.Spawn(name, ...)
	self.Children:Add(node)
	return node
end


function Nodes.Node.New() : Nodes._Node
	return Nodes.Init({}, Nodes.Node) :: Nodes._Node
end


function Nodes.Node.Prototype:GetRemote() : Nodes._Node
end


return Nodes.Node :: Nodes._NodeStatic