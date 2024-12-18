local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("loaded").Value

local mapVoteEnd = game.ReplicatedStorage.GameEvents.GameRoundMapLoading:WaitForChild("MapVoteEnd");
local gmVoteEnd = game.ReplicatedStorage.GameEvents.GameRoundMapLoading:WaitForChild("GamemodeVoteEnd");


local ts = game:GetService("TweenService");

local voting = workspace.GlobalValues.Vote:WaitForChild("itsSoHappening");

local gui = player.PlayerGui:WaitForChild("CoolTitleGui").Right.Surf.Vote;
local label = gui.Countdown.TextFrame.cd;

local voteTime = workspace.GlobalValues.Vote:WaitForChild("voteTime");
local mapping = workspace.GlobalValues.Vote:WaitForChild("mapVoteHappening");
local gamemoding = workspace.GlobalValues.Vote:WaitForChild("gmVoteHappening");

local rs = game:GetService("RunService")


local doingMap = false;
local doingGm = false;


rs.RenderStepped:Connect(function()
	
	if mapping.Value and not doingMap then
		doingMap = true;
		local sec = voteTime.Value;

		while mapping.Value and sec > 0 do
			label.Text = sec;
			task.wait(1)
			sec -= 1
		end

		label.Text = 0;
		
	elseif gamemoding.Value and not doingGm then
		doingGm = true;
		local sec = voteTime.Value;

		while gamemoding.Value and sec > 0 do
			label.Text = sec;
			task.wait(1)
			sec -= 1
		end

		label.Text = 0;
		
	elseif not gamemoding.Value and not mapping.Value then
		doingGm = false;
		doingMap = false;
	end
	
end)


gmVoteEnd.OnClientEvent:Connect(function()
	
	task.wait(1);
	
	local tt = 0.7;
	
	local main = ts:Create(gui.Countdown, TweenInfo.new(tt), {
		BackgroundTransparency = 1
	});
	
	ts:Create(gui.Countdown.TextFrame.cd, TweenInfo.new(tt), {
		TextTransparency = 1,
		BackgroundTransparency = 1
	}):Play();
	
	main.Completed:Connect(function()
		gui.Countdown.BackgroundTransparency = 0.6
		
		gui.Countdown.TextFrame.cd.TextTransparency = 0;
	end)
	
	main:Play()
end)