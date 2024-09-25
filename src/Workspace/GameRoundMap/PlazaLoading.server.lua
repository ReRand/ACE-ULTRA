local grm = require(script.Parent.GameRoundMap);

local loaded = false;

repeat task.wait() until workspace.GlobalValues.Game.mapsStored.Value;

local start = game.ReplicatedStorage.GameEvents.GameRoundMapLoading:WaitForChild("FirstBoot");

start.Event:Connect(function()
	loaded = true;
	workspace.GlobalValues.Game.firstBooted.Value = true;
end)


repeat task.wait() until loaded;

grm:ReloadPlaza();