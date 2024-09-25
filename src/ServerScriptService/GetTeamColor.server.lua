local gettc = game.ReplicatedStorage.GameEvents.GetTeamColor;
local gottc = game.ReplicatedStorage.GameEvents.GotTeamColor;

gettc.OnServerEvent:Connect(function(localplayer, player)
	local tc = nil;
	local waiting = false;

	coroutine.wrap(function()
		tc = gottc.OnServerEvent:Wait();
		
		print(tc);
		
		waiting = false
	end)();

	gettc:FireClient(player);
	waiting = true;

	coroutine.wrap(function()
		repeat task.wait() until not waiting;
		gottc:FireClient(localplayer, tc);
		
	end)();
end)