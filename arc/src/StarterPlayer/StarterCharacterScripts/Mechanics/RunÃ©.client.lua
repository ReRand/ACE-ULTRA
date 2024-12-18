repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;

repeat task.wait() until player.spawned.Value;

local TweenService = game:GetService("TweenService");
local Values = require(workspace.Modules.Values);

local uis = game:GetService("UserInputService")
local character = player.Character or player.CharacterAdded:Wait();

local humanoid = character:WaitForChild("Humanoid");
local baseSpeed = humanoid.WalkSpeed;

local info = TweenInfo.new(2);
local NormalWalk = TweenService:Create(humanoid, info, { WalkSpeed = baseSpeed})

local info = TweenInfo.new(2);
local Run = TweenService:Create(humanoid, info, { WalkSpeed = 30 });


local running = Values:Fetch("running");


local emoting = Values:Fetch('emoting');

emoting.Changed:Connect(function()
	if not emoting.Value then
		humanoid.WalkSpeed = baseSpeed;
	end
	
	running.Value = false;
	Run:Cancel();
	NormalWalk:Cancel();
end)


uis.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.W and not emoting.Value then
		Run:Play();
		running.Value = true
	end
end)


uis.InputEnded:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.W and not emoting.Value then
		NormalWalk:Play();
		running.Value = false
	end
end)