--!optimize 2
--!nocheck
--!native

local AceLib = {
    Classes = script.Classes,
    Dependencies = script.Dependencies,
}


for _, mod in script:GetDescendants() do
    if mod:IsA("ModuleScript") and mod.Parent.Name ~= "Enums" then
        AceLib[mod.Name] = require(mod)
    end
end

return AceLib