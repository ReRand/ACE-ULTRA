local Disabled = {
    "EmotesMenu", "Backpack"
};


for _, dis in pairs(Disabled) do
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[dis], false);
end


local camera = workspace.CurrentCamera


local player = game.Players.LocalPlayer
local Values = require(workspace.Modules.Values)


local mouse = player:GetMouse()
mouse.Icon = "rbxassetid://14013223911"


repeat task.wait() until Values:FetchRel("Game", "Loaded").Value