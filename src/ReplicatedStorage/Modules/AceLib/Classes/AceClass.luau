--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Types)

function Types.AceClass:Destroy(self)
    self = nil
end

function Types.AceClass:Super<T>(self, prototype: { Extensions: { [number]: string } }) : T
    self.Metadata = self.Metadata or {}

    for _, t in prototype do
        for k, v in t do
            self[k] = self[k] or v
        end
    end
    
    for _, t in prototype.Extensions do
        for k, v in t do
            self[k] = self[k] or v
        end
    end

    return self :: T
end


return Types.AceClass