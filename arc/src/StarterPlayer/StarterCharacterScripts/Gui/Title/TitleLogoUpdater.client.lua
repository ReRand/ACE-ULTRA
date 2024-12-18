repeat task.wait() until game:IsLoaded();

local Values = require(workspace.Modules.Values);
local player = game.Players.LocalPlayer

repeat task.wait() until player:WaitForChild("valuesLoaded").Value

local loaded = player:WaitForChild("loaded");

repeat task.wait() until loaded.Value;





local gui = workspace:FindFirstChild("PlayerTitleGuiInstance") or Instance.new("Folder", workspace);
gui.Name = "PlayerTitleGuiInstance";


local logo = gui:FindFirstChild("Logo") or workspace.CoolTitleGui:WaitForChild("Logo"):Clone()
logo.Parent = gui;


if not player.PlayerGui.CoolTitleGui.Left.Enabled then
	logo.Transparency = 1;
	logo.Decal.Transparency = 1;
else
	logo.Transparency = 0;
	logo.Decal.Transparency = 0;
end



player.PlayerGui.CoolTitleGui.Left:GetPropertyChangedSignal("Enabled"):Connect(function()

	if not player.PlayerGui.CoolTitleGui.Left.Enabled then
		logo.Transparency = 1;
		logo.Decal.Transparency = 1;
	else
		logo.Transparency = 0;
		logo.Decal.Transparency = 0;
	end
end)
