--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Types)

function Types.AceClass:Destroy(self)
    self = nil
end

function Types.AceClass.Init<T>(self, prototype ...{ [string]: any }) : T
    for _, t in {...} do
        for k, v in t do
            self[k] = self[k] or v
        end
    end
    return self :: T;
end


return Types.AceClass