local add = game.ReplicatedStorage.GameEvents:WaitForChild("AddPlayerToLeaderboard");
local rem = game.ReplicatedStorage.GameEvents:WaitForChild("RemovePlayerFromLeaderboard");


local plb = require(game.StarterPlayer.StarterCharacterScripts.Modules:WaitForChild("PlayerLeaderboard"));


local players = game.Players


local player = players.LocalPlayer;
local spawned = player:WaitForChild("spawned");


-- add.OnClientEvent:Connect(plb.AddPlayer);
-- rem.OnClientEvent:Connect(plb.RemovePlayer);


local sp = workspace:WaitForChild("SpawnedPlayers");


sp.ChildAdded:Connect(function(child)
	if string.match(child.ClassName, "Value") and not plb:IsPlayerShown(child.Value) then
		local pl = players:GetPlayerByUserId(child.Value);
		plb.AddPlayer(pl);
	end
end)


sp.ChildRemoved:Connect(function(child)
	if string.match(child.ClassName, "Value") and plb:IsPlayerShown(child.Value) then
		local pl = players:GetPlayerByUserId(child.Value);
		plb.RemovePlayer(pl);
	end
end)


spawned.Changed:Connect(function()
	if spawned.Value then
		
		for _, id in pairs(workspace:WaitForChild("SpawnedPlayers"):GetChildren()) do
			if not plb:IsPlayerShown(id) then
				local pl = players:GetPlayerByUserId(id.Value);
				plb.AddPlayer(pl);
			end
		end
		
		add:FireServer();
	else
		rem:FireServer();
	end
end)