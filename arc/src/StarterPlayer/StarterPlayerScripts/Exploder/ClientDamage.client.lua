repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("spawned").Value;

local cd = game.ReplicatedStorage.GameEvents.Exploder:WaitForChild("ClientDamage");
local gd = require(workspace.Modules.GlobalDamage);

cd.OnClientEvent:Connect(function(eHuman, damage, knockback, part, vel)
	gd:Inflict(eHuman, damage, "ace", 1 );
	
	if knockback then
		part.AssemblyLinearVelocity = vel;
	end
end)	