local player = game.Players.LocalPlayer;
local loaded = player:WaitForChild("loaded");

repeat task.wait() until loaded.Value


local Revared = require(workspace.Modules.Revared);
local Replicator = Revared:GetModule("Replicator");

local event = Replicator:GetServer(game, { "PlaceVersion" });

event.Event:Connect(function(pv)
	player.PlayerGui:WaitForChild("CoolTitleGui").Right.Surf:WaitForChild("Version").Text = "© 2024 ReRand Studios • Version "..workspace.GlobalValues.Game.gameVersion.Value..":"..pv;
	player.PlayerGui:WaitForChild("CoolTitleGui").Right.Surf:WaitForChild("Status").Text = workspace.GlobalValues.Game.gameStatus.Value;
end)

event:Activate();