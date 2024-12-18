local events = game.ReplicatedStorage.GameEvents;

local esm = events:WaitForChild("EmoteServerModules");

esm.OnServerEvent:Connect(function(player, modules, ...)
	for _, mod in pairs(modules:GetChildren()) do
		require(mod)(player, ...);
	end
end)