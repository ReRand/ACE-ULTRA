--!optimize 2
--!nocheck
--!native

local Types = require(script.Parent.Parent.Types);


local AceEnumItem = {
    ClassName = "AceEnumItem"

}


function AceEnumItem.New(EnumType: Types.AceEnum, Name : string, Value : number) : Types.AceEnumItem
    local self = table.clone(AceEnumItem);

    self.Name = Name
    self.EnumType = EnumType
    self.Value = Value

    EnumType.Items[Name] = self :: Types.AceEnumItem

    return self :: Types.AceEnumItem
end


return AceEnumItem