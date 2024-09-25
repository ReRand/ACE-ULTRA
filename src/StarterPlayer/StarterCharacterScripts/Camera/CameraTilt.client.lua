local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("loaded").Value

local GOLMovement = require(script.Parent.Parent.Modules.GOLMovement);

local movement = GOLMovement.new();

local rs = game:GetService("RunService");

rs.RenderStepped:Connect(function()
	movement:updateCam();
end)