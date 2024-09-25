local players = game.Players;
local values = workspace.GlobalValues.Player;


players.PlayerAdded:Connect(function(player)
	local loaded = Instance.new("BoolValue", player);
	loaded.Name = "valuesLoaded";
	loaded.Parent = player;
	
	--script.RemoteEvent:FireClient(player, loaded)
	
	for i, v in pairs(values:GetChildren()) do
		local val = v:Clone()
		val.Parent = player;
	end
	
	loaded.Value = true;
end)