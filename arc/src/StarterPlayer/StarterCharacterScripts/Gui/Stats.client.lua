repeat task.wait() until game:IsLoaded();
local player = game.Players.LocalPlayer;

local rs = game:GetService("RunService");

repeat task.wait() until script;
repeat task.wait() until player.loaded.Value;

local rem = game.ReplicatedStorage.GameEvents:WaitForChild("StatsRem")

local statz = player.PlayerGui:WaitForChild("StatsGui");

local peakFps = 0;
local minPing = 1;


statz:GetPropertyChangedSignal("Enabled"):Connect(function()
	if statz.Enabled then
		while statz.Enabled do
			local fps = math.round(1 / rs.RenderStepped:wait())

			if fps > peakFps then
				peakFps = fps;
			end

			local start = time()
			rem:InvokeServer()

			local endd = time()

			local ping = math.round((endd - start)*1000)

			-- 30 fps 

			statz.fps.Text = fps.." FPS"
			statz.fps.TextColor3 = Color3.new(1-(fps/peakFps)+0.1, fps/peakFps+0.5, 0)

			statz.ping.Text = ping.."ms Ping"
			statz.ping.TextColor3 = Color3.new(1-(minPing-(ping/100))+0.1, minPing-(ping/100)+0.3, 0)	
			
			task.wait(0.00005)
		end
	end
	
end)


if player.stats.Value then
	statz.Enabled = true;	
end