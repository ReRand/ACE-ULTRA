repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;

repeat task.wait() until player.spawned.Value;

repeat task.wait() until script;
repeat task.wait() until script.Parent;

local ifrmEvent = game.ReplicatedStorage.GameEvents.PunchParry:WaitForChild("IFramed")
local iframed = player:WaitForChild("iframed");

ifrmEvent.OnClientEvent:Connect(function()
	ifrmEvent:FireServer(iframed.Value);
end)