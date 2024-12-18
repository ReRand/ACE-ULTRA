local add = game.ReplicatedStorage.GameEvents:WaitForChild("AddPlayerToLeaderboard");
local rem = game.ReplicatedStorage.GameEvents:WaitForChild("RemovePlayerFromLeaderboard");

local players = game.Players;


local function AddPlayerToLeaderboard(player)
	local value = Instance.new("StringValue", workspace:WaitForChild("SpawnedPlayers"))
	value.Value = player.UserId;
	value.Name = player.UserId;

	add:FireAllClients(player);
end

local function RemovePlayerFromLeaderboard(player)
	for _, id in pairs(workspace:WaitForChild("SpawnedPlayers"):GetChildren()) do
		if tostring(id.Value) == tostring(player.UserId) then
			id:Destroy();
		end
	end

	rem:FireAllClients(player);
end


add.OnServerEvent:Connect(AddPlayerToLeaderboard);
rem.OnServerEvent:Connect(RemovePlayerFromLeaderboard);
players.PlayerRemoving:Connect(RemovePlayerFromLeaderboard);