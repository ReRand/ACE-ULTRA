local started = game.ReplicatedStorage.GameEvents.GameRoundMapLoading.StartRound:WaitForChild("Server");
local elapsed = workspace.GlobalValues.Game.elapsedTime;
local roundGoing = workspace.GlobalValues.Game.started;

started.Event:Connect(function()
	
	elapsed.Value = 0;
	
	while roundGoing.Value do
		wait(1);
		elapsed.Value += 1;
	end
end)