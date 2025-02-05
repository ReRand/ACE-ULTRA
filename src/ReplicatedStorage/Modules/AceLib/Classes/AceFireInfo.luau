--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types)


local AceFireInfo = {
    ClassName = "AceFireInfo",
    Color = nil,
    Transparency = nil,

    OriginEntity = nil,

    FireProbability = 1,
    Damage = 1,
    TickTime = 1,
    TotalTime = 5,

} :: Types.AceFireInfo


function AceFireInfo.New(tbl : { [string] : any? }?) : Types.AceFireInfo
    local self = tbl ~= nil and tbl or table.clone(AceFireInfo);

    return self :: Types.AceFireInfo
end


return AceFireInfo