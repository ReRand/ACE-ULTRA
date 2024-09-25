local players = game.Players;

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local hrp = character:WaitForChild("HumanoidRootPart");
		
		if hrp:FindFirstChild("TrailEmitter") then
			local clone = game.ReplicatedStorage.Particles.TrailEmitter:Clone();
			
			clone.Size = Vector3.new(0.1, 0.1, 0.1)
			
			clone.CanCollide = false;
			clone.CanQuery = false;
			clone.CanTouch = false;
			clone.Massless = true;
			
			clone.Transparency = 1;
			
			clone.Parent = hrp;
			
			local weld = Instance.new("Weld", clone)
			weld.Name = "Weld";
			weld.Part0 = hrp;
			weld.Part1 = clone;
			weld.C1 = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		end
	end)
end)