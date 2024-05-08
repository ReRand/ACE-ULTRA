local CameraShaker = require(workspace.Modules.CameraShaker);
local CameraShakeInstance = CameraShaker.CameraShakeInstance;


local Values = require(workspace.Modules.Values);
local Crouching = Values:FetchRel("Player", "Crouching");


local RunService = game:GetService("RunService");
local camera = workspace.CurrentCamera;
local character = script.Parent;
local humanoid = character:WaitForChild("Humanoid");
local hrp = character:WaitForChild("HumanoidRootPart");


local cs = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame *= shakeCFrame
end)


cs:Start()


local shaking = false;


local csi = nil;

local idleCsi = CameraShakeInstance.new( 0.1, 1, 1, 10)
idleCsi.PositionInfluence = Vector3.new(0.01, 0.01, 0.01)
idleCsi.RotationInfluence = Vector3.new(1, 1, 1);

local fadeTime = 0.3;


cs:ShakeSustain(idleCsi);


RunService.RenderStepped:Connect(function()
	if not (humanoid.MoveDirection == Vector3.new()) then
		if not shaking then
			
			shaking = true;
			
			task.wait(0.1);
			
			local mag = Crouching.Value and 1 or ((hrp.Velocity.Magnitude/3)/10 or 0.3)
			
			csi = CameraShakeInstance.new( ((hrp.Velocity.Magnitude/3)/10 or 0.3), 2, 1, fadeTime)
			csi.PositionInfluence = Vector3.new(0.15, 4, 0.15)
			csi.RotationInfluence = Vector3.new(0.5, 0.5, 3)
			
			if idleCsi then
				idleCsi:StartFadeOut(fadeTime)
			end
			
			cs:ShakeSustain(csi);
		end
		
	elseif shaking then
		
		local mag = 0.1 -- Crouching.Value and 0.5 or 0.1;
		
		if idleCsi:IsShaking() then
			idleCsi:StartFadeOut(0);
		end
		
		idleCsi = CameraShakeInstance.new( mag, 1, 1, 10)
		idleCsi.PositionInfluence = Vector3.new(0.01, 0.01, 0.01)
		idleCsi.RotationInfluence = Vector3.new(1, 1, 1)
		
		if csi then csi:StartFadeOut(fadeTime); end
		cs:ShakeSustain(idleCsi);
		
		shaking = false;
	end;
end)
