local gettc = game.ReplicatedStorage.GameEvents:WaitForChild("GetTeamColor");
local gottc = game.ReplicatedStorage.GameEvents:WaitForChild("GotTeamColor");

local player = game.Players.LocalPlayer;

gettc.OnClientEvent:Connect(function(localplayer)
	gottc:FireServer(player.TeamColor);
end)