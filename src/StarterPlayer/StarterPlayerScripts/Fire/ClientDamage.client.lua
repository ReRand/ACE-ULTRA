repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("spawned").Value;

local cd = game.ReplicatedStorage.GameEvents.Fire:WaitForChild("ClientDamage");
local gd = require(workspace.Modules.GlobalDamage);

cd.OnClientEvent:Connect(function(eHuman, damage)
	gd:Inflict(eHuman, damage);
end)	