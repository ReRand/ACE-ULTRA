--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types)


function AceFireInfo.New(tbl : { [string] : any? }?) : Types.AceFireInfo
    local self = tbl ~= nil and tbl or table.clone(AceFireInfo);

    return self :: Types.AceFireInfo
end


return AceFireInfo