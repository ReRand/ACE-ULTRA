local player = game.Players.LocalPlayer;

repeat task.wait() until game:IsLoaded();
repeat task.wait() until player.spawned.Value;

repeat task.wait() until script;
repeat task.wait() until script.Parent;


local cd = game.ReplicatedStorage.GameEvents.ProjMod:WaitForChild("ClientDamage");
local gd = require(workspace.Modules.GlobalDamage);


cd.OnClientEvent:Connect(function(eHuman, damage)
	gd:Inflict(eHuman, damage, "ace", 1 );
end)