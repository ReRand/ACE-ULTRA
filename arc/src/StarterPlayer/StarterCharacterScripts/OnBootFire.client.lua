local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("loaded").Value;

if not workspace.GlobalValues.Game.firstBooted.Value then
	game.ReplicatedStorage.GameEvents:WaitForChild("OnFirstBoot"):FireServer()
end