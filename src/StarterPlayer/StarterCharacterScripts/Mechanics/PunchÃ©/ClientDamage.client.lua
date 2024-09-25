repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;

repeat task.wait() until player.spawned.Value;

repeat task.wait() until script;
repeat task.wait() until script.Parent;

local cd = game.ReplicatedStorage.GameEvents.PunchParry:WaitForChild("ClientDamage");
local gd = require(workspace.Modules.GlobalDamage);


cd.OnClientEvent:Connect(function(eHuman, damage)
	gd:Inflict(eHuman, damage, "ace", 1 );
end)