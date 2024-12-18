repeat task.wait() until script;
repeat task.wait() until script.Parent;

local resp = game.ReplicatedStorage.GameEvents:WaitForChild("MenuRespawner");
local Revared = require(workspace.Modules.Revared);
local glob = Revared:GetModule("PlayerGlob");

resp.OnServerEvent:Connect(function(player)
	glob:Respawn(player);
end)