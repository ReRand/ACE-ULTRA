--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types)
local AceEnumItem = require(script.Parent.AceEnumItem)


function AceEnum.New(Name : string, Items : { [number] : string }) : Types.AceEnum
    local self = table.clone(AceEnum)

    self.Name = Name
    self.Items = {}

    for i, v in Items do
        AceEnumItem.New(self, v, i)
    end

    return self :: Types.AceEnum
end


return AceEnum