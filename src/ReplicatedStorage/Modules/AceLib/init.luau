--!optimize 2
--!nonstrict
--!native

local AceLib = {
	Classes = script.Classes
}


for _, mod: ModuleScript in script:GetDescendants() do
	if mod:IsA("ModuleScript") then
		require(mod)
	end
end


local Nodes = require(script.Nodes)
AceLib.Nodes = Nodes


function AceLib.CreateNode<T>(name : string, ...): T
	return Nodes[name].New(...) :: T
end


AceLib.Entities = {}


type _AceGame = Nodes._Node & {

}


AceLib.Enums = Nodes.Enums


return AceLib
