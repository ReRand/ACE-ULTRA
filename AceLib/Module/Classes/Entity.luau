--!optimize 2
--!nonstrict
--!native


local Nodes = require(script.Parent.Parent.Nodes)
local RunService = game:GetService("RunService")


function Nodes.Entity.New(base: Player | Model, info : Nodes._EntityInfo?) : Nodes._Entity?
	if RunService:IsClient() then return end

	local self = {
		Base = base,
		Info = info,

		Health = 100,
		Gravity = 9.8,
		Metadata = info and info.Metadata or {},

		Dashing = false,
		Standing = false,
		Jumping = false,

		Weapons = {},
		Perks = {}
	}

	return Nodes.Init(self, Nodes.Entity) :: Nodes._Entity
end


function Nodes.Entity.Prototype:Kill(reason)
	if RunService:IsServer() then
		print(reason)
	end
end


return Nodes.Entity :: Nodes._EntityStatic
