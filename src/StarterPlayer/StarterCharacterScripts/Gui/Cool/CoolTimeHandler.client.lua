local player = game.Players.LocalPlayer;
repeat task.wait() until player:WaitForChild("loaded").Value

local rs = game:GetService("RunService");

local timething = player.PlayerGui:WaitForChild("CoolGui").Middle.Playerlist.Leaderboard.GamemodeBoxFrame.timetext

local function formatTime(currentTime)
	local hours = math.floor(currentTime / 3600)
	local minutes = math.floor((currentTime - (hours * 3600))/60)
	local seconds = math.floor((currentTime - (hours * 3600) - (minutes * 60)))
	local milliseconds = math.floor(10 * (currentTime - math.floor(currentTime)))

	local t = nil;

	local format = "%02d:%02d"
	t = format:format(minutes, seconds, milliseconds)

	return t
end


local roundTime = workspace.GlobalValues.Game:WaitForChild("roundTime");
local elapsed = workspace.GlobalValues.Game:WaitForChild("elapsedTime");


rs.RenderStepped:Connect(function()
	local currentTime = roundTime.Value - elapsed.Value;
	timething.Text = formatTime(currentTime);
end)