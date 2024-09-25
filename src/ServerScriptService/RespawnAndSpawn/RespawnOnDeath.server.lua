local respawn = game.ReplicatedStorage.GameEvents:WaitForChild("OnDeathRespawn")
local Revared = require(workspace.Modules.Revared);
local glob = Revared:GetModule("PlayerGlob");

respawn.OnServerEvent:Connect(function(player)
	glob:Respawn(player);
end)