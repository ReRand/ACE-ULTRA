local started = game.ReplicatedStorage.GameCore.Events.GameRoundMapLoading.StartRound:WaitForChild("Server");
local elapsed = game.ReplicatedStorage.GameCore.GlobalValues.Game.elapsedTime;
local roundGoing = game.ReplicatedStorage.GameCore.GlobalValues.Game.started;

started.Event:Connect(function()
	
	elapsed.Value = 0;
	
	while roundGoing.Value do
		wait(1);
		elapsed.Value += 1;
	end
end)