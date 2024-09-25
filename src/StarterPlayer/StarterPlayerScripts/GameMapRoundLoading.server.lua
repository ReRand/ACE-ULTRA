repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;
repeat task.wait() until player:WaitForChild("loaded").Value

local post = game.ReplicatedStorage.GameEvents.GameRoundMapLoading:WaitForChild("ClientPoster")
local kick = game.ReplicatedStorage.GameEvents.GameRoundMapLoading:WaitForChild("KickToMenu")
local reload = game.ReplicatedStorage.GameEvents.GameRoundMapLoading:WaitForChild("ReloadMap")

local gv = workspace.GlobalValues.Game;

local mapId = gv.mapId;
local mapV = gv.map;


--[[post.OnClientEvent:Connect(function(map)
	mapV.Value = map;
	mapId.Value = map.id.Value;
end)]]


kick.OnClientEvent:Connect(function()
		
	local reset = false;
	
	if player.TeamColor ~= game.Teams.Plaza.TeamColor and not player.menu.Value then
		player.TeamColor = game.Teams.Spectator.TeamColor;
		player.menu.Value = true;
		player.spawned.Value = false;
		player.mapLocallyLoaded.Value = false;
		
		reset = true;
	end
	
	kick:FireServer(player, reset);
end)


reload.OnClientEvent:Connect(function()
	game.ReplicatedStorage.GameEvents:WaitForChild("OnMenuReload"):Fire();
end)