--!optimize 2
--!nonstrict
--!native

local Nodes = require(script.Parent.Parent.Nodes)
local RunService = game:GetService("RunService")


function Nodes.FireInfo.New(entity: Nodes._Entity, info : { [string]: any }?) : Nodes._FireInfo
    info = info or {}
    
    local self = {
        Color = Color3.new(),
        Transparency = 0,

        OriginEntity = entity,

        Damage = 1,
        TickTime = 1,
        TotalTime = 5,
    }

    
    for k,v in info do
        if self[k] and k ~= "OriginEntity" then
            self[k] = v;
        end
    end

	return Nodes.Init({}, Nodes.FireInfo) :: Nodes._FireInfo
end


return Nodes.FireInfo :: Nodes._FireInfoStatic
