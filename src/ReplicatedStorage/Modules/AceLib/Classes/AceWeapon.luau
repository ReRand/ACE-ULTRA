--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types)


function Types.AceWeapon.New() : Types._AceWeapon
    local self = table.clone(Types.AceWeapon);

    return self :: Types._AceWeapon
end


return Types.AceWeapon