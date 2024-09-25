local GameRoundMap = {
	PeopleWhoHaveVotedForAMap = {},
	PeopleWhoHaveVotedForAGamemode = {},
	Maps = {},
	Gamemodes = {}
}

math.randomseed(os.time())
math.random(); math.random(); math.random()


local ts = game:GetService("TweenService");

local loaded = false;


repeat task.wait() until workspace.GlobalValues.Game.mapsStored.Value;

local events = game.ReplicatedStorage.GameEvents;
local mus = game.ReplicatedStorage.GameMus;


local start = events.GameRoundMapLoading:WaitForChild("FirstBoot");
local ktm = events.GameRoundMapLoading:WaitForChild("KickToMenu");
local mapVote = events.GameRoundMapLoading:WaitForChild("MapVote")
local mapUnvote = events.GameRoundMapLoading:WaitForChild("MapUnvote")
local mapVoteEnd = events.GameRoundMapLoading:WaitForChild("MapVoteEnd")
local gmVote = events.GameRoundMapLoading:WaitForChild("GamemodeVote")
local gmUnvote = events.GameRoundMapLoading:WaitForChild("GamemodeUnvote")
local gmVoteEnd = events.GameRoundMapLoading:WaitForChild("GamemodeVoteEnd")
local startRound = events.GameRoundMapLoading:WaitForChild("StartRound");
local endRound = events.GameRoundMapLoading:WaitForChild("EndRound");


local rgmm = events.GameRoundMapLoading:WaitForChild("RunGamemodeModule");
local rmm = events.GameRoundMapLoading:WaitForChild("RunMapModule");


start.Event:Connect(function()
	loaded = true;
end)


local Values = require(workspace.Modules.Values);
local Revared = require(workspace.Modules.Revared);
local glob = Revared:GetModule("PlayerGlob");

local gv = workspace.GlobalValues.Game;
local vv = workspace.GlobalValues.Vote;

local mapId = gv.mapId;
local gmId = gv.gmId;
local mapV = gv.map;
local song = gv.song;
local ended = gv.ended;
local started = gv.started;
local paused = gv.unendingHorrors;
local roundTime = gv.roundTime;

local voting = vv.itsSoHappening;
local voteTime = vv.voteTime;

local mapA = vv.mapA;
local mapB = vv.mapB;
local mapC = vv.mapC;

local gmA = vv.gmA;
local gmB = vv.gmB;
local gmC = vv.gmC;


local baseplate = script.Parent.Baseplate;


for _, m in pairs(game.ReplicatedStorage:WaitForChild("Maps"):GetChildren()) do
	if m:IsA("Model") and m:FindFirstChild("id") and (m:FindFirstChild("active") and m:FindFirstChild("active").Value) then
		GameRoundMap.Maps[#GameRoundMap.Maps+1] = m;
	end
end


for _, gm in pairs(game.ReplicatedStorage:WaitForChild("Gamemodes"):GetChildren()) do
	if gm:IsA("Configuration") and gm:FindFirstChild("id") and (gm:FindFirstChild("active") and gm:FindFirstChild("active").Value) then
		GameRoundMap.Gamemodes[#GameRoundMap.Gamemodes+1] = gm;
	end
end


function GameRoundMap:GetMapFromId(id)
	for i, map in ipairs(GameRoundMap.Maps) do
		if map.id.Value == id then
			return map;
		end
	end
end


function GameRoundMap:GetGamemodeFromId(id)
	for i, gm in ipairs(GameRoundMap.Gamemodes) do
		if gm.id.Value == id then
			return gm;
		end
	end
end


function GameRoundMap:StartRound(m_id, gm_id)
	for _, player in pairs(game.Players:GetPlayers()) do
		player:WaitForChild("kills").Value = 0;
		player:WaitForChild("style").Value = 0;

		player:WaitForChild("iframed").Value = false;
		player:WaitForChild("parrying").Value = false;
	end
	
	
	local map = GameRoundMap:GetMapFromId(m_id):Clone();
	map.Parent = workspace.GameRoundMap:FindFirstChild("Maps") or Instance.new("Folder", workspace.GameRoundMap);
	map.Parent.Name = "Maps";
	
	for _, mod in pairs(map.Modules.Server:GetChildren()) do
		require(mod)(m_id, gm_id);
	end
	
	rmm:FireAllClients(m_id, gm_id, map.Modules.Client);
	
	local sng = mus:FindFirstChild(map.Name);
	if sng then song.Value = sng; end

	local gm = GameRoundMap:GetGamemodeFromId(gm_id);
	for _, mod in pairs(gm.Modules.Server:GetChildren()) do
		require(mod)(m_id, gm_id);
	end
	
	rgmm:FireAllClients(m_id, gm_id, gm.Modules.Client);


	mapV.Value = map;
	mapId.Value = m_id;

	gmId.Value = gm_id;


	started.Value = true;
	ended.Value = false;


	startRound.Client:FireAllClients(m_id, gm_id);
	startRound.Server:Fire(m_id, gm_id);

	-- script.Events.ClientPoster:FireAllClients(map);

	for _, spwn in pairs(map[map.Name].Spawns:GetChildren()) do
		spwn.Enabled = true;
	end

	repeat task.wait() until loaded

	for _, p in pairs(map:GetDescendants()) do
		if p:GetAttribute("Anchored") then
			p.Anchored = true;
		end
	end

	map:MoveTo(baseplate.Position + map.offset.Value)


	if game.Lighting.MapEffects:FindFirstChild(map.Name) then
		for _, effect in pairs(game.Lighting.MapEffects[map.Name]:GetChildren()) do
			effect:Clone().Parent = game.Lighting;
		end
	end
end


function GameRoundMap:EndRound()
	task.wait(1)
	

	local map = mapV.Value;
	local gm_id = gmId.Value;
	
	
	endRound.Client:FireAllClients(map:WaitForChild("id").Value, gm_id);
	endRound.Server:Fire(map:WaitForChild("id").Value, gm_id);


	for _, spwn in pairs(map[map.Name].Spawns:GetChildren()) do
		spwn.Enabled = false;
	end

	for _, effect in pairs(game.Lighting:GetChildren()) do
		if effect:HasTag(map.Name) then
			effect:Destroy();
		end
	end


	map:Destroy();


	started.Value = false;
	ended.Value = true;


	for _, player in pairs(game.Players:GetPlayers()) do
		ktm.OnServerEvent:Connect(function(recieving, pl, reset)
			if pl == player and reset then
				player.TeamColor = game.Teams.Spectator.TeamColor;
				
				glob:Respawn(player);

				task.wait(0.5)

				events.GameRoundMapLoading:WaitForChild("ReloadMap"):FireClient(player, player);
			end
		end);

		ktm:FireClient(player, player);
	end
end


function GameRoundMap:GetMapChoice(maps)
	local maInd = math.random(1, #maps);
	local ma = maps[maInd];

	return ma, maInd;
end


function GameRoundMap:GetGamemodeChoice(maps)
	local maInd = math.random(1, #GameRoundMap.Gamemodes);
	local ma = GameRoundMap.Gamemodes[maInd];

	return ma, maInd;
end



function GameRoundMap:HasVotedForAMap(player)
	for i, pid in pairs(GameRoundMap.PeopleWhoHaveVotedForAMap) do
		if pid == player.UserId then return true, i end;
	end
	return false
end

function GameRoundMap:HasVotedForAGamemode(player)
	for i, pid in pairs(GameRoundMap.PeopleWhoHaveVotedForAGamemode) do
		if pid == player.UserId then return true, i end;
	end
	return false
end


function GameRoundMap:StartMapVote()
	
	if vv.mapVoteHappening.Value then return end;
	vv.mapVoteHappening.Value = true;
	vv.gmVoteHappening.Value = false;
	
	ts:Create(workspace.GameRoundMap.Baseplate, TweenInfo.new(0.2), {
		Transparency = 0;
	}):Play();

	ts:Create(workspace.GameRoundMap.Baseplate.Texture, TweenInfo.new(0.2), {
		Transparency = workspace.GameRoundMap.Baseplate.Texture.def.Value;
	}):Play();


	voting.Value = true;
	GameRoundMap.PeopleWhoHaveVotedForAMap = {};

	local ma = GameRoundMap:GetMapChoice(GameRoundMap.Maps);
	local mb = GameRoundMap:GetMapChoice(GameRoundMap.Maps);

	if mb == ma then
		while mb == ma do
			mb = GameRoundMap:GetMapChoice(GameRoundMap.Maps);
			task.wait()
		end
	end

	local mc = GameRoundMap:GetMapChoice(GameRoundMap.Maps);

	if mc == ma or mc == mb then
		while mc == ma or mc == mb do
			mc = GameRoundMap:GetMapChoice(GameRoundMap.Maps);
			task.wait()
		end
	end

	if ma then
		mapA.id.Value = ma.id.Value;
		mapA.votes.Value = 0;
		mapA.icon.Value = ma.icon;
		mapA.name.Value = string.upper(ma.Name)
	end

	if mb then
		mapB.id.Value = mb.id.Value;
		mapB.votes.Value = 0;
		mapB.icon.Value = mb.icon;
		mapB.name.Value = string.upper(mb.Name);
	end

	if mc then
		mapC.id.Value = mc.id.Value;
		mapC.votes.Value = 0;
		mapC.icon.Value = mc.icon;
		mapC.name.Value = string.upper(mc.Name)
	end


	mapVote:FireAllClients();
	
	mapUnvote.OnServerEvent:Connect(function(player, map)
		if GameRoundMap:HasVotedForAMap(player) then
			vv:FindFirstChild("map"..string.upper(map)).votes.Value -= 1;
			local _, i = GameRoundMap:HasVotedForAMap(player);
			table.remove(GameRoundMap.PeopleWhoHaveVotedForAMap, i);
		end
	end)

	mapVote.OnServerEvent:Connect(function(player, map)
		if not GameRoundMap:HasVotedForAMap(player) then
			vv:FindFirstChild("map"..string.upper(map)).votes.Value += 1;
			table.insert(GameRoundMap.PeopleWhoHaveVotedForAMap, player.UserId);
		end
	end)
end


function GameRoundMap:TallyMapVotes()
	local t = {
		[mapA.votes.Value] = mapA,
		[mapB.votes.Value] = mapB,
		[mapC.votes.Value] = mapC
	};

	table.sort(t);
	
	for votes, map in pairs(t) do
		if map:FindFirstChild("overwrite") and map.overwrite.Value then
			map.overwrite.Value = false;
			return map.id.Value, map.Name;
		end
	end

	for votes, map in pairs(t) do
		return map.id.Value, map.Name;
	end
end


function GameRoundMap:EndMapVote()
	
	if not vv.mapVoteHappening.Value then return end;
	vv.mapVoteHappening.Value = false;
	
	local winner, mapConot = GameRoundMap:TallyMapVotes();
	mapVoteEnd:FireAllClients(winner, mapConot);
	return winner;
end


function GameRoundMap:StartGamemodeVote()
	
	if vv.gmVoteHappening.Value then return end;
	vv.mapVoteHappening.Value = false;
	vv.gmVoteHappening.Value = true;
	
	GameRoundMap.PeopleWhoHaveVotedForAGamemode = {};

	local gma = GameRoundMap:GetGamemodeChoice(GameRoundMap.Gamemodes);
	local gmb = GameRoundMap:GetGamemodeChoice(GameRoundMap.Gamemodes);

	if gmb == gma then
		while gmb == gma do
			gmb = GameRoundMap:GetGamemodeChoice(GameRoundMap.Gamemodes);
			task.wait()
		end
	end

	local gmc = GameRoundMap:GetGamemodeChoice(GameRoundMap.Gamemodes);

	if gmc == gma or gmc == gmb then
		while gmc == gma or gmc == gmb do
			gmc = GameRoundMap:GetGamemodeChoice(GameRoundMap.Gamemodes);
			task.wait()
		end
	end

	if gma then
		gmA.id.Value = gma.id.Value;
		gmA.votes.Value = 0;
		gmA.icon.Value = gma.icon;
		gmA.name.Value = string.upper(gma.Name)
	end

	if gmb then
		gmB.id.Value = gmb.id.Value;
		gmB.votes.Value = 0;
		gmB.icon.Value = gmb.icon;
		gmB.name.Value = string.upper(gmb.Name);
	end

	if gmc then
		gmC.id.Value = gmc.id.Value;
		gmC.votes.Value = 0;
		gmC.icon.Value = gmc.icon;
		gmC.name.Value = string.upper(gmc.Name)
	end


	gmVote:FireAllClients();
	
	gmUnvote.OnServerEvent:Connect(function(player, gm)
		if GameRoundMap:HasVotedForAGamemode(player) then
			vv:FindFirstChild("gm"..string.upper(gm)).votes.Value -= 1;
			local _, i = GameRoundMap:HasVotedForAGamemode(player);
			table.remove(GameRoundMap.PeopleWhoHaveVotedForAGamemode, i);
		end
	end)

	gmVote.OnServerEvent:Connect(function(player, gm)
		if not GameRoundMap:HasVotedForAGamemode(player) then
			vv:FindFirstChild("gm"..string.upper(gm)).votes.Value += 1;
			table.insert(GameRoundMap.PeopleWhoHaveVotedForAGamemode, player.UserId);
		end
	end)
end


function GameRoundMap:TallyGamemodeVotes()
	local t = {
		[gmA.votes.Value] = gmA,
		[gmB.votes.Value] = gmB,
		[gmC.votes.Value] = gmC
	};

	table.sort(t);

	for votes, gm in pairs(t) do
		if gm:FindFirstChild("overwrite") and gm.overwrite.Value then
			gm.overwrite.Value = false;
			return gm.id.Value, gm.Name;
		end
	end

	for votes, gm in pairs(t) do
		return gm.id.Value, gm.Name;
	end
end


function GameRoundMap:EndGamemodeVote()
	
	if not vv.gmVoteHappening.Value then return end;
	vv.gmVoteHappening.Value = false;
	
	ts:Create(workspace.GameRoundMap.Baseplate, TweenInfo.new(0.2), {
		Transparency = 1;
	}):Play();

	ts:Create(workspace.GameRoundMap.Baseplate.Texture, TweenInfo.new(0.2), {
		Transparency = 1;
	}):Play();

	voting.Value = false;

	local winner, gmConot = GameRoundMap:TallyGamemodeVotes();

	gmVoteEnd:FireAllClients(winner, gmConot);

	return winner;
end



function GameRoundMap:ReloadPlaza()
	
end


return GameRoundMap