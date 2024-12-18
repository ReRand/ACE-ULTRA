local Values = require(workspace.Modules.Values);
local players = game.Players;

players.PlayerAdded:Connect(function(player)
	
	local slamming = Values:FetchRemote("slamming", player);
	
	print(slamming);
	
	while task.wait(0.5) do
		print(slamming.LocalValue)
		print(slamming.ServerValue)
	end
end)