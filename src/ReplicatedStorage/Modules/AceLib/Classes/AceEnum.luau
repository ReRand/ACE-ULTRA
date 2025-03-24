--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types)


function Types.AceEnum.New(Name : string, Items : { [number] : string }) : Types._AceEnum
    local self = table.clone(Types.AceEnum)

    self.Name = Name
    self.Items = {}

    for i, v in Items do
        Types.AceEnumItem.New(self, v, i)
    end

    return self :: Types._AceEnum
end


return Types.AceEnum