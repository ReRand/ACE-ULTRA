local players = game.Players;

players.PlayerAdded:Connect(function(player)
	
	player:GetPropertyChangedSignal("Character"):Connect(function()
		local character = player.Character or player.CharacterAdded:Wait();
		local human = character:WaitForChild("Humanoid");
		
		human.DisplayName = " ";
	end)
	
	player.CharacterAdded:Connect(function(character)
		local human = character:WaitForChild("Humanoid");
		
		human.DisplayName = " ";
	end)
	
end)