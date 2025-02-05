--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types)


local AceWeapon = {
    ClassName = "AceWeapon",

} :: Types.AceWeapon


function AceWeapon.New() : Types.AceWeapon
    local self = table.clone(AceWeapon);

    return self :: Types.AceWeapon
end


return AceWeapon