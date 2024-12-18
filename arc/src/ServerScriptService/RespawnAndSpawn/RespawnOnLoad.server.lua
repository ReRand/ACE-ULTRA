local Revared = require(workspace.Modules.Revared);
local glob = Revared:GetModule("PlayerGlob");

game.ReplicatedStorage.GameEvents:WaitForChild("OnLoadRespawn").OnServerEvent:Connect(function(player) 
	glob:Respawn(player);
end)