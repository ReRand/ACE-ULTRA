-- server emote module

return (function(player, emoteid)
	local character = player.Character or player.CharacterAdded:Wait();
	
	local sound = game.ReplicatedStorage.GameSounds.Emotes.ClapSound:Clone();
	sound.Parent = character:WaitForChild("HumanoidRootPart");
	
	sound.Ended:Connect(function()
		sound:Destroy();
	end)
	
	sound:Play();
end)