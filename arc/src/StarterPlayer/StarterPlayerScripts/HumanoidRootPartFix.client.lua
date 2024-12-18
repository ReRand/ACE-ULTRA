local player = game.Players.LocalPlayer

repeat task.wait() until player:WaitForChild("loaded").Value

player.CharacterAdded:Connect(function(character)
	character.PrimaryPart = character:WaitForChild("HumanoidRootPart")
end)