-- repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;
repeat task.wait() until player:WaitForChild("spawned").Value;

local TweenService = game:GetService("TweenService");
local Values = require(workspace.Modules.Values);
local RunService = game:GetService("RunService");
local StarterPlayer = game:GetService("StarterPlayer");

local uis = game:GetService("UserInputService");
local cas = game:GetService("ContextActionService");
local character = player.Character or player.CharacterAdded:Wait();

local humanoid = character:WaitForChild("Humanoid");
local Animator = humanoid:WaitForChild("Animator");
local hrp = character:WaitForChild("HumanoidRootPart");
local baseVel = nil;

local Keyboard = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"):WaitForChild("Keyboard"));

local kb = Keyboard.new(2000);

local camera = workspace.CurrentCamera;
local speedEmitter = nil;
local trail = nil;

local leftInfo = nil;
local rightInfo = nil;

local speed = 250;
local tween = nil;

local damaged = {};

local GlobalDamage = require(workspace.Modules.GlobalDamage);
-- local GlobalAnimator = require(workspace.GlobalAnimator);
local sliding = Values:Fetch("sliding");



local offset = Values:Fetch("armOffset");
local baseArmOffset = offset.Value;


-- if not player:HasAppearanceLoaded() then print('appearance not loaded'); player.CharacterAppearanceLoaded:Wait() end
-- print('appearance loaded');

task.wait()


local anim = game.ReplicatedStorage.PlayerAnimations.Slide.SlideAnim;
local SlideAnim = Animator:LoadAnimation(anim);

repeat task.wait() until SlideAnim.Length > 0


local Sound = game.ReplicatedStorage.GameSounds.SlideSlam:WaitForChild("Slide");
local WalkVolume = nil;

local baseOffset = Vector3.new(0, 0, -1);
local uiOffset = player:WaitForChild("uiOffset");

local forward = false;
local backward = false;
local left = false;
local right = false;


local camera = workspace.CurrentCamera;

local CameraShaker = require(workspace.Modules.CameraShaker);

local function ShakeCamera(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end

local renderPriority = Enum.RenderPriority.Camera.Value + 2

local cs = CameraShaker.new(renderPriority, ShakeCamera)
cs:Start();


local baseFOV = camera.FieldOfView;



uis.InputEnded:Connect(function(Input)
	
	if Input.KeyCode == Enum.KeyCode.Thumbstick1 then
		if Input.Delta.X >= 0.1 then
			right = false;
		elseif Input.Delta.X <= 0.1 then
			left = false;
		elseif Input.Delta.Y >= 0.1 then
			forward = false;
		elseif Input.Delta.Y <= 0.1 then
			backward = false;
		end
	end

	if Input.KeyCode == Enum.KeyCode.W then
		forward = false;
	end
	
	if Input.KeyCode == Enum.KeyCode.S then
		backward = false;
	end
	
	if Input.KeyCode == Enum.KeyCode.A then
		left = false
	end

	if Input.KeyCode == Enum.KeyCode.D then
		right = false
	end
end)

local endevent = game.ReplicatedStorage.GameEvents.SlideSlam:WaitForChild("SlideEnded")
local startevent = game.ReplicatedStorage.GameEvents.SlideSlam:WaitForChild("SlideBegan")

endevent.Event:Connect(function(Input)

	if sliding.Value then
		sliding.Value = false;
		-- camera.CameraType = Enum.CameraType.Custom
		
		--[[local Walk = hrp:FindFirstChild("Running");
		Walk.Volume = WalkVolume;]]
		
		cs:StopSustained(0.1);
		
		SlideAnim:Stop();
		Sound:Stop();
		
		(TweenService:Create(camera, TweenInfo.new(0.4), {
			FieldOfView = baseFOV;
		})):Play();
		
		(TweenService:Create(humanoid, TweenInfo.new(0.1), {
			CameraOffset = baseOffset
		})):Play();
		
		(TweenService:Create(offset, TweenInfo.new(0.5), {
			Value = baseArmOffset
		})):Play();
		
		(TweenService:Create(uiOffset, TweenInfo.new(0.5), {
			Value = CFrame.new()
		})):Play();
		
		-- trail:WaitForChild("Weld").C1 = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		
		hrp["sool"]:Destroy();
	end
end)


local typing = Values:Fetch('typing');
local spawned = player.spawned


uis.InputBegan:Connect(function(Input)
	
	
	if Input.KeyCode == Enum.KeyCode.Thumbstick1 then
		if Input.Delta.X >= 0.1 then
			right = true;
		elseif Input.Delta.X <= 0.1 then
			left = true;
		elseif Input.Delta.Y >= 0.1 then
			forward = true;
		end
	end
	
	if Input.KeyCode == Enum.KeyCode.W then
		forward = true
	end
	
	if Input.KeyCode == Enum.KeyCode.S then
		backward = true
	end
	
	if Input.KeyCode == Enum.KeyCode.A then
		left = true
	end
	
	if Input.KeyCode == Enum.KeyCode.D then
		right = true
	end
	
end)	


local thirdPerson = Values:Fetch("thirdPerson");
local emotesMenuOpen = Values:Fetch("emotesMenuOpen");
local slamStorage = Values:Fetch("slamStorage");

startevent.Event:Connect(function(Input)
	if player:WaitForChild("slideEnabled").Value and not emotesMenuOpen.Value and humanoid.FloorMaterial ~= Enum.Material.Air and not sliding.Value and not thirdPerson.Value and not typing.Value and spawned.Value then
		damaged = {};

		
		local stoppers = { "slamming", "ragdoll" };
		local disablers = {
			slamming = "GroundSlaméHitbox"
		}


		for _, stopper in ipairs(stoppers) do
			local val = Values:Fetch(stopper);
			if (val.Value) then return; end
		end


		for valueName, hitboxName in pairs(disablers) do
			local val = Values:Fetch(valueName);
			if (val.Value and hrp:FindFirstChild(hitboxName)) then
				hrp:FindFirstChild(hitboxName):Destroy();
			end
		end
		
		local rotOrigin = hrp.Rotation;
		
		
		local sool = Instance.new("BodyVelocity", hrp);
		
		sool.Name = "sool";
		sool.MaxForce = Vector3.new(100000,0,100000)
		local magnitude = ((hrp.Velocity.Magnitude+2) * 1.15);
		local lookVector = hrp.CFrame.lookVector;
		local rightVector = hrp.CFrame.rightVector;
	
		
		if math.floor(hrp.Velocity.Magnitude) <= game.StarterPlayer.CharacterWalkSpeed+5 then
			magnitude = 43;
		end
		
		if slamStorage.Value then
			slamStorage.Value = false;
			magnitude *= 3;
		end
		
		-- print(magnitude);
		
		local vel = nil;
		local camoffset = nil;
		local fovoffset = nil;
		local uio = uiOffset.Value;
		
	
		if forward and not right and not left or (not forward and not right and not left and not backward) then
			vel = lookVector * magnitude;
			fovoffset = baseFOV + 4;
			camoffset = Vector3.new(0, -3, -1);
		
		
		elseif forward and right and not left then
			vel = (lookVector + rightVector) * magnitude;
			fovoffset = baseFOV + 2;
			camoffset = Vector3.new(0, -3, -1);
			uio += Vector3.new(0.1, 0, 0);
		
		
		elseif forward and not right and left then
			vel = (lookVector + (-rightVector)) * magnitude
			fovoffset = baseFOV + 2;
			camoffset = Vector3.new(0, -3, -1);
			uio += Vector3.new(-0.1, 0, 0);
		
		
		elseif backward and not right and not left then
			vel = (-lookVector) * magnitude
			fovoffset = baseFOV - 3;
			camoffset = Vector3.new(0, -3, 1);


		elseif backward and right and not left then
			vel = ((-lookVector) + rightVector) * magnitude
			fovoffset = baseFOV - 2;
			camoffset = Vector3.new(0, -3, 1);
			uio += Vector3.new(0.1, 0, 0);


		elseif backward and not right and left then
			vel = ((-lookVector) + (-rightVector)) * magnitude
			fovoffset = baseFOV - 2;
			camoffset = Vector3.new(0, -3, 1);
			uio += Vector3.new(-0.1, 0, 0);


		elseif right then
			vel = rightVector * magnitude
			fovoffset = baseFOV + 2;
			camoffset = Vector3.new(-1, -3, 0);
			uio += Vector3.new(0.2, 0, 0);
			
			
		elseif left then
			vel = -rightVector * magnitude
			fovoffset = baseFOV + 2;
			camoffset = Vector3.new(-1, -3, 0);
			uio += Vector3.new(0.2, 0, 0);
			
			
		else
			vel = lookVector * magnitude;
			fovoffset = baseFOV + 4;
			camoffset = Vector3.new(0, -3, -1);
			
		end
		
		sool.Velocity = vel;
		
		
		-- sool lives...
		
		
		sliding.Value = true;
		
		local shakeInst = CameraShaker.CameraShakeInstance.new(1, 10, 0.3, 0.1);
		cs:ShakeSustain(shakeInst);
		
		
		(TweenService:Create(camera, TweenInfo.new(0.4), {
			FieldOfView = fovoffset;
		})):Play();
		
		
		(TweenService:Create(uiOffset, TweenInfo.new(0.5), {
			Value = uio
		})):Play();
		
		
		(TweenService:Create(humanoid, TweenInfo.new(0.4), {
			CameraOffset = camoffset
		})):Play();
		
		--camera.CFrame = camera.CFrame * CFrame.Angles(0, 0, math.deg(25));
		
		(TweenService:Create(offset, TweenInfo.new(0.4), {
			Value = -3
		})):Play();
		
		--[[trail = hrp:WaitForChild("TrailEmitter");
		trail.Weld.C1 = CFrame.new(0, 1, -1, 1, 0, 0, 0, 1, 0, 0, 0, 1);]]
		
		SlideAnim:Play();
		

		--[[local Walk = hrp:FindFirstChild("Running");
		WalkVolume = Walk.Volume;
		Walk.Volume = 0;]]

	end
end)