local att = require(game.ReplicatedStorage.Modules.Attributes);
local Events = game.ReplicatedStorage.GameCore.Events.Attributes;

Events.PlayerAttributed.OnClientEvent:Connect(function(...)
	att.PlayerAttributed:Fire(...);
end)

Events.CharacterAttributed.OnClientEvent:Connect(function(...)
	att.CharacterAttributed:Fire(...);
end)