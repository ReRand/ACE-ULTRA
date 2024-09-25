while not game.ReplicatedStorage:FindFirstChild("Particles") do
	workspace.Particles.Parent = game.ReplicatedStorage;
	task.wait(1)
end


while not game.ReplicatedStorage:FindFirstChild("AmmoTypes") do
	workspace.AmmoTypes.Parent = game.ReplicatedStorage;
	task.wait(1)
end