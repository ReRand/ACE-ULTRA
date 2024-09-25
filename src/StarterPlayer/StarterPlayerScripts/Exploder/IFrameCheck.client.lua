repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("spawned").Value;

local ifrmEvent = game.ReplicatedStorage.GameEvents.Exploder:WaitForChild("IFramed")
local iframed = player:WaitForChild("iframed");

ifrmEvent.OnClientEvent:Connect(function()
	print('iframe check client')
	ifrmEvent:FireServer(iframed.Value);
end)