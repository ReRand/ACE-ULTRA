local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("valuesLoaded").Value

repeat task.wait() until player.loaded.Value;
repeat task.wait() until player.menu.Value;


math.randomseed(os.time())
math.random(); math.random(); math.random()


local function ChangeSpawn(mapModel)
	for _, s in pairs(mapModel:WaitForChild("Spawns"):GetChildren()) do
		if s.TeamColor == player.TeamColor then
			player.RespawnLocation = s;
			return true;
		end
	end
end

local function RandomClaim(mapModel)
	local spawns = {};
	
	for _, s in pairs(mapModel:WaitForChild("Spawns"):GetChildren()) do
		table.insert(spawns, s);
	end
	
	return spawns[math.random(1, #spawns)]
end


local spawnloc = workspace.GameRoundMap:WaitForChild("PlayerLoaderPlatform");


if player.RespawnLocation == spawnloc and player.TeamColor ~= game.Teams.Loading.TeamColor and player.TeamColor ~= game.Teams.Spectator.TeamColor then
	local map = workspace.GlobalValues.Game.map.Value;
	local mapModel = map[map.Name];

	local changed = ChangeSpawn(mapModel);

	if not changed then
		player.RespawnLocation = RandomClaim();
	end
end