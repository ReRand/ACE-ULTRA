local events = game.ReplicatedStorage.GameEvents;

local rgmm = events.GameRoundMapLoading:WaitForChild("RunGamemodeModule");
local rmm = events.GameRoundMapLoading:WaitForChild("RunMapModule");

rmm.OnClientEvent:Connect(function(mapId, gmId, modules)
	for _, mod in pairs(modules:GetChildren()) do
		require(mod)(mapId, gmId);
	end
end)


rgmm.OnClientEvent:Connect(function(mapId, gmId, modules)
	for _, mod in pairs(modules:GetChildren()) do
		require(mod)(mapId, gmId);
	end
end)