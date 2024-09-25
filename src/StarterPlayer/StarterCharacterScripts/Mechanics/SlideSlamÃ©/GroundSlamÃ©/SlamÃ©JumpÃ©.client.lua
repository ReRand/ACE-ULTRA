-- repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;
repeat task.wait() until player.spawned.Value;

local Values = require(workspace.Modules.Values);
local StarterPlayer = game:GetService("StarterPlayer");

local uis = game:GetService("UserInputService")
local character = player.Character or player.CharacterAdded:Wait();

local humanoid = character:WaitForChild("Humanoid");
local hrp = character:WaitForChild("HumanoidRootPart");

local slamJump = Values:Fetch("slamJump");


slamJump.Changed:Connect(function()
	if slamJump.Value == true then
		
		task.wait(0.3);
		
		slamJump.Value = false;
		humanoid.JumpHeight = StarterPlayer.CharacterJumpHeight;
	end
end)