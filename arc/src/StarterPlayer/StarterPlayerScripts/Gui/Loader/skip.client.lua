repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;

local button = player.PlayerGui:WaitForChild("LoaderGui").skipButton;
local loaded = player.loaded;

button.Activated:Connect(function()
	loaded.Value = true;
end)