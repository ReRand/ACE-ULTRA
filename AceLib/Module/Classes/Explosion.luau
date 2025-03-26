--!optimize 2
--!nonstrict
--!native

local Nodes = require(script.Parent.Parent.Nodes)
local RunService = game:GetService("RunService")


function Nodes.Explosion.New(info : Nodes._ExplosionInfo?) : Nodes._Explosion?
	info = info or Nodes.ExplosionInfo.New()

	local self = {
		Info = info
	}

	return Nodes.Init({}, Nodes.Explosion) :: Nodes._Explosion
end


return Nodes.Explosion :: Nodes._ExplosionStatic