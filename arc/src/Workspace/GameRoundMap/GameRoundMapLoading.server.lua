local grm = require(script.Parent.GameRoundMap);

local loaded = false;

repeat task.wait() until workspace.GlobalValues.Game.mapsStored.Value;

local start = game.ReplicatedStorage.GameEvents.GameRoundMapLoading:WaitForChild("FirstBoot");

start.Event:Connect(function()
	loaded = true;
	workspace.GlobalValues.Game.firstBooted.Value = true;
end)


local gv = workspace.GlobalValues.Game;
local vv = workspace.GlobalValues.Vote;

local ended = gv.ended;
local started = gv.started;
local paused = gv.unendingHorrors;
local roundTime = gv.roundTime;

local voting = vv.itsSoHappening;
local voteTime = vv.voteTime;


local mapVote = game.ReplicatedStorage.GameEvents.GameRoundMapLoading:WaitForChild("MapVote")
local gmVote = game.ReplicatedStorage.GameEvents.GameRoundMapLoading:WaitForChild("GamemodeVote")


local doneA = false;
local doneB = false;
local doneC = false;

local mapId = nil;



local function C()
	
	if doneC then return end;
	
	doneB = true;
	
	if not paused.Value then
		grm:EndRound();
		doneA = false;
		doneB = false;
		doneC = false;
	end
end


local function B(mapId)
	
	if doneB then return end;
	
	doneA = true;
	
	local gmId = grm:EndGamemodeVote();

	grm:StartRound(mapId, gmId);

	task.delay(roundTime.Value, C)
end


local function A()
	if doneA then return end;
	
	mapId = grm:EndMapVote();


	task.wait(1.2)


	grm:StartGamemodeVote()


	task.delay(voteTime.Value, function()
		B(mapId);
	end)
end



--[[mapVote.OnServerEvent:Connect(function()
	if #grm.PeopleWhoHaveVotedForAMap >= #game.Players:GetPlayers() and not doneA then
		A();
	end
end)


gmVote.OnServerEvent:Connect(function()
	if #grm.PeopleWhoHaveVotedForAGamemode >= #game.Players:GetPlayers() and not doneB then
		B(mapId);
	end
end)]]



while task.wait() do
	if not started.Value and not voting.Value and not paused.Value and loaded then
		task.wait(0.1)
		grm:StartMapVote()
		task.delay(voteTime.Value, A)
	end
end