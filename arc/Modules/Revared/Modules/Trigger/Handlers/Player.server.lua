repeat task.wait() until game:IsLoaded();
local players = game.Players;


players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		local events = game.ReplicatedStorage:WaitForChild("TriggerEvents");
		local event = events.PlayerHandler;
		event:FireServer();
	end)
end)


for _, player in ipairs(players:GetChildren()) do
	player.CharacterAdded:Connect(function()
		local events = game.ReplicatedStorage:WaitForChild("TriggerEvents");
		local event = events.PlayerHandler;
		event:FireServer();
	end)
end
