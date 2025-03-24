--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types)


function AceExplosionInfo.New(tbl : { [string] : any? }?) : Types.AceExplosionInfo
    local self = tbl ~= nil and tbl or table.clone(AceExplosionInfo)

    if (self.FireProbability >= 0 and not self.FireInfo) then
        self.FireInfo = AceFireInfo.New()
    end

    return self :: Types.AceExplosionInfo
end


return AceExplosionInfo