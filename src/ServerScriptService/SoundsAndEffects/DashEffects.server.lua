local players = game.Players;


players.PlayerAdded:Connect(function(player)
	player:WaitForChild("iframed").Changed:Connect(function()
		
		local character = player.Character or player.CharacterAdded:Wait();
		
		if player.iframed.Value then
			
			if not character:FindFirstChild("ForceField") then
				Instance.new("ForceField", character);
			end
			
		else
			
			for _, thing in pairs(character:GetChildren()) do
				if thing.Name == "ForceField" then
					thing:Destroy();
				end
			end
			
		end
	end)
end)