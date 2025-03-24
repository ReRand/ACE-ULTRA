--!optimize 2
--!nocheck
--!native

local AceLib = {
    Classes = script.Classes,
    Dependencies = script.Dependencies,
}

for _, mod in script:GetDescendants() do
    if mod:IsA("ModuleScript") then
        AceLib[mod.Name] = require(mod)
    end
end

local Types = require(script.Parent.Types);
AceLib.Types = types;

AceLib.Players: { [string]: Types._AceEntity<Player> } = {}
AceLib.Entities: { [string]: Types._AceEntity<Model> } = {}

type _AceGame = Types._AceClass & {
    
}

AceLib.Game: _AceGame = {
    ClassName = "AceGame"
}

AceLib.Enums = Types.Enums

return AceLib