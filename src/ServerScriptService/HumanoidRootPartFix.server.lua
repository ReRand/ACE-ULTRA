game.Players.PlayerAdded:Connect(function(player)
	repeat task.wait() until player:WaitForChild("loaded").Value

	player.CharacterAdded:Connect(function(character)
		character.PrimaryPart = character:WaitForChild("HumanoidRootPart")
	end)
end)