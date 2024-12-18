repeat task.wait() until script;
repeat task.wait() until script.Parent;


local player = game.Players.LocalPlayer;

local images = player.PlayerGui:WaitForChild("ScreenGui").border:WaitForChild("Images"):GetChildren();

local rs = game:GetService("RunService");

rs.RenderStepped:Connect(function()
	player.PlayerGui.ScreenGui.border.Image = images[math.random(1,#images)].Image;
	player.PlayerGui.ScreenGui.border.Rotation = math.random(-1, 1)/10
	task.wait(0.05);
end)