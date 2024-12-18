local player = game.Players.LocalPlayer;

repeat task.wait() until game:IsLoaded();
repeat task.wait() until player.spawned.Value;


local character = player.Character or player.CharacterAdded:Wait();
local humanoid = character:WaitForChild("Humanoid");
local RunService = game:GetService("RunService");
local pressedOnce = false


local Values = require(workspace.Modules.Values);
local falldown = Values:Fetch("falldown");

RunService.RenderStepped:Connect(function()
	if falldown.Value then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
	else
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	end
end)

humanoid.StateChanged:Connect(function(State)
	-- print(State)
end)


--[[
local hrp = character:WaitForChild("HumanoidRootPart");
local particles = workspace:WaitForChild("Particles");

local se = particles:WaitForChild("SpeedEmitterPart");

local speedEmitter = se:WaitForChild("SpeedEmitter"):Clone();
local endTrail = se:WaitForChild("EndTrail"):Clone();
local startTrail = se:WaitForChild("StartTrail"):Clone();

endTrail.Name = "EndSETrail";
startTrail.Name = "StartSETrail";

speedEmitter.Attachment0 = startTrail;
speedEmitter.Attachment1 = endTrail;

speedEmitter.Parent = hrp;
speedEmitter.Enabled = false;

endTrail.Parent = hrp;
startTrail.Parent = hrp;
]]