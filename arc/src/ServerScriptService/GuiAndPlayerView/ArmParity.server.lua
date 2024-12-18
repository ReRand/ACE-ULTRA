local parity = game.ReplicatedStorage.GameEvents:WaitForChild("ArmParity");

parity.OnServerEvent:Connect(function(...)
	parity:FireAllClients(...)
end)