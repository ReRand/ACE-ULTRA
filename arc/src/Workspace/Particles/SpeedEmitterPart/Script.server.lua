local players = game.Players;

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local clone = script.Parent:Clone();
		local head = character:WaitForChild("Head");

		clone.Size = Vector3.new(0.1, 0.1, 0.1)

		clone.CanCollide = false;
		clone.CanQuery = false;
		clone.CanTouch = false;
		clone.Massless = true;

		clone.Transparency = 1;

		clone.Parent = head;

		local weld = Instance.new("Weld", clone)
		weld.Name = "Weld";
		weld.Part0 = head;
		weld.Part1 = clone;
		weld.C1 = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		
		clone.Anchored = false;

		clone.SpeedEmitter.Enabled = false;
		
		
		local humanoid = character:WaitForChild("Humanoid");
		local hrp = character:WaitForChild("HumanoidRootPart");
		
		humanoid.StateChanged:Connect(function(oldState, newState)
			if oldState == Enum.HumanoidStateType.Freefall and newState == Enum.HumanoidStateType.Landed then

				if clone.SpeedEmitter.Enabled then
					clone.SpeedEmitter.Enabled = false;
				end
			end
		end)
		
		
		while task.wait() do
			if humanoid:GetState() == Enum.HumanoidStateType.Freefall and hrp.Velocity.Y < -10 then
				clone.SpeedEmitter.Enabled = true;
			end
		end
	end)
end)