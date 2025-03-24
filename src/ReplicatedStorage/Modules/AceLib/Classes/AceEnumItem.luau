--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types);


function Types.AceEnumItem.New(EnumType: Types._AceEnum, Name : string, Value : number) : Types._AceEnumItem
    local self = table.clone(Types.AceEnumItem);

    self.Name = Name
    self.EnumType = EnumType
    self.Value = Value

    EnumType.Items[Name] = self :: Types._AceEnumItem
    return self :: Types._AceEnumItem
end


return Types.AceEnumItem