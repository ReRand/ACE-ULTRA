local player = game.Players.LocalPlayer;
local trail = script.Parent;

local camera = workspace.CurrentCamera;

local rs = game:GetService("RunService");

local character = player.Character or player.CharacterAdded:Wait();

local head = character:WaitForChild("Head");
	
rs.RenderStepped:Connect(function()
	trail.Transparency = NumberSequence.new(head.LocalTransparencyModifier)
end)
