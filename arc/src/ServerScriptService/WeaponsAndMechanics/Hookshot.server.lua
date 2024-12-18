local event = game.ReplicatedStorage.GameEvents.Hookshot;
local ts = game:GetService("TweenService");
local particle = game.ReplicatedStorage:WaitForChild("Particles").HookParticle;



event.OnServerEvent:Connect(function(player, target)
	local character = player.Character or player.CharacterAdded:Wait();
	local hrp = character:FindFirstChild("HumanoidRootPart");
end)