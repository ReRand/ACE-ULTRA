-- repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;
repeat task.wait() until player.spawned.Value;

local character = script.Parent.Parent;
local humanoid = character:WaitForChild("Humanoid");
-- humanoid.BreakJointsOnDeath = false;

local camera = workspace.Camera;

local Values = require(workspace.Modules.Values);

local uis = game:GetService("UserInputService")

local GlobalRagdoll = require(workspace.Modules.GlobalRagdoll);
local ragdoll = Values:Fetch("ragdoll");

local baseSubject = camera.CameraSubject

local leftArm = character:WaitForChild("Left Arm");

local typing = Values:Fetch("typing");

local spawned = player.spawned

uis.InputBegan:Connect(function(Input)

	if Input.KeyCode == Enum.KeyCode.R or (Input.KeyCode == Enum.KeyCode.Space and ragdoll.Value) and not typing.Value and spawned.Value then
		if ragdoll.Value then
			
			leftArm.Transparency = 1;
			leftArm.LocalTransparencyModifier = 1
			
			GlobalRagdoll:UnRagdoll(humanoid);
			player.CameraMode = Enum.CameraMode.LockFirstPerson
			camera.CameraSubject = baseSubject
			player.CameraMinZoomDistance = game.StarterPlayer.CameraMinZoomDistance;
			ragdoll.Value = false;
			
			player.PlayerGui.CoolGui.Left.Enabled = true;
			player.PlayerGui.CoolGui.Right.Enabled = true;
		elseif Input.KeyCode == Enum.KeyCode.R or (Input.KeyCode == Enum.KeyCode.Space and not ragdoll.Value) and not typing.Value and spawned.Value then
			leftArm.Transparency = 0;
			leftArm.LocalTransparencyModifier = 0
			
			GlobalRagdoll:Ragdoll(humanoid);
			player.CameraMode = Enum.CameraMode.Classic
			camera.CameraSubject = character:WaitForChild("Head");
			player.CameraMinZoomDistance = game.StarterPlayer.ZoomOutMax.Value;
			ragdoll.Value = true;
			
			player.PlayerGui.CoolGui.Left.Enabled = false;
			player.PlayerGui.CoolGui.Right.Enabled = false;
		end
	end
end)