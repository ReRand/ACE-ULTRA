local CameraShaker = require(workspace.Modules.CameraShaker);
local CameraShakeInstance = CameraShaker.CameraShakeInstance;


local RBXScriptSignal = require(workspace.Modules.Signal);
local startShake = RBXScriptSignal.new();
local endShake = RBXScriptSignal.new();


local RunService = game:GetService("RunService");
local camera = workspace.CurrentCamera;
local player = game.Players.LocalPlayer;
local character = player.Character or player.CharacterAdded:Wait();
local humanoid = character:WaitForChild("Humanoid");
local hrp = character:WaitForChild("HumanoidRootPart");

local standing = player:WaitForChild("standing");


local cs = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame *= shakeCFrame
end)


cs:Start()


local shaking = false;


local csi = nil;

local idleCsi = CameraShakeInstance.new( 0.1, 0.1, 1, 10)
idleCsi.PositionInfluence = Vector3.new(0.01, 0.01, 0.01)
idleCsi.RotationInfluence = Vector3.new(1, 1, 1);

local fadeTime = 0.3;


cs:ShakeSustain(idleCsi);


RunService.RenderStepped:Connect(function()
	
	--print("standing: " .. tostring(standing.Value) .. " shaking: " .. tostring(shaking))
	
	if not standing.Value and not shaking then
		shaking = true;
			
		if shaking then
			local mag = ((hrp.Velocity.Magnitude/3)/50 or 0.2)

			csi = CameraShakeInstance.new( ((((hrp.Velocity*Vector3.new(1, 0, 1)).Magnitude)/3)/50 or 0.2), 2, 1, fadeTime)
			csi.PositionInfluence = Vector3.new(0.15, 4, 0.15)
			csi.RotationInfluence = Vector3.new(0.5, 0.5, 3)

			if idleCsi then
				idleCsi:StartFadeOut(fadeTime)
			end

			cs:ShakeSustain(csi);	
		end
		
	elseif standing.Value and shaking then
		
		shaking = false;
		
		local mag = 0.1 -- Crouching.Value and 0.5 or 0.1;
		
		if idleCsi:IsShaking() then
			idleCsi:StartFadeOut(0);
		end
		
		idleCsi = CameraShakeInstance.new( mag, 1, 1, 10)
		idleCsi.PositionInfluence = Vector3.new(0.01, 0.01, 0.01)
		idleCsi.RotationInfluence = Vector3.new(1, 1, 1)
		
		if csi then csi:StartFadeOut(fadeTime); end
		cs:ShakeSustain(idleCsi);
	end;
end)