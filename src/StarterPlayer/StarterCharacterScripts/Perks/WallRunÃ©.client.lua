local TweenService = game:GetService("TweenService");
local Values = require(workspace.Modules.Values);
local RunService = game:GetService("RunService");
local StarterPlayer = game:GetService("StarterPlayer");

local player = game.Players.LocalPlayer;
local loaded = player.loaded;

repeat task.wait() until game:IsLoaded();
repeat task.wait() until loaded.Value;
repeat task.wait() until player.spawned.Value;

repeat task.wait() until script;
repeat task.wait() until script.Parent;
repeat task.wait() until script.Parent.Parent;

-- if not player:HasAppearanceLoaded() then player.CharacterAppearanceLoaded:Wait() end

local ts = game:GetService("TweenService");

local uis = game:GetService("UserInputService");
local character = player.Character or player.CharacterAdded:Wait();

local humanoid = character:WaitForChild("Humanoid");
local Animator = humanoid:WaitForChild("Animator");
local hrp = character:WaitForChild("HumanoidRootPart");
local baseVel = nil;

local baseGrav = workspace.Gravity;
local cooldown = false;

local gravityAlter = Values:Fetch("GravityAlteration");


local camera = workspace.CurrentCamera;


local wallSliding = Values:Fetch('wallSliding');


local Sound = game.ReplicatedStorage.GameSounds:WaitForChild("SlideButDifferentForWallSlide");
local Jumping = game.ReplicatedStorage.GameSounds:WaitForChild("Jumping")


local GlobalDamage = require(workspace.Modules.GlobalDamage);

task.wait()

local mainAnim = game.ReplicatedStorage.PlayerAnimations.Slam.SlamMain;
local SlamMainAnim = Animator:LoadAnimation(mainAnim);
repeat task.wait() until SlamMainAnim.Length > 0


local stamina = Values:Fetch("stamina");
local staminaHold = Values:Fetch("staminaHold");
local wallJumping = Values:Fetch("wallJumping");
local slamJump = Values:Fetch("slamJump");
local slamming = Values:Fetch('slamming');
local slamStorage = Values:Fetch('slamStorage');


local hitbox = workspace:WaitForChild("WallSlideHitbox"):Clone();
hitbox.Parent = hrp;


local weld = Instance.new("Weld", hitbox);
weld.Part0 = hitbox;
weld.Part1 = hrp;


hitbox.Anchored = false;
hitbox.Transparency = 1;


local jumps = Values:Fetch("wallJumpMax").Value;


humanoid.StateChanged:Connect(function(old, new)
	if old == Enum.HumanoidStateType.Freefall and new == Enum.HumanoidStateType.Landed then
		coroutine.wrap(function()
			
			repeat task.wait() until not slamming.Value;
			repeat task.wait() until not slamJump.Value
		
			task.wait(0.1);
			
			if humanoid:GetState() == Enum.HumanoidStateType.Landed then
				jumps = Values:Fetch("wallJumpMax").Value;
			end
		
		end)()
	end
end)


local function Raycast(part)
	--[[local visual = Instance.new("Part", workspace);
	visual.Anchored = true;
	visual.CanCollide = false;]]

	-- visual.CFrame = CFrame.lookAt(, origin)*CFrame.new(0, 0, -distance/2) 

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = { character }
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local peak = { Dist = 1000, Pos = nil, Face = nil };

	local a = workspace:Raycast(hitbox.Position, Vector3.new(-100, 0, 0), raycastParams);
	local b = workspace:Raycast(hitbox.Position, Vector3.new(0, 0, -100), raycastParams);
	local c = workspace:Raycast(hitbox.Position, Vector3.new(100, 0, 0), raycastParams);
	local d = workspace:Raycast(hitbox.Position, Vector3.new(0, 0, 100), raycastParams);


	if a and a.Instance == part then
		--[[visual.Position = hrp.Position;
		visual.CFrame = CFrame.lookAt(a.Position, hitbox.Position)*CFrame.new(0, 0, -a.Distance/2)]]

		if a.Distance < peak.Dist then
			peak.Dist = a.Distance;
			peak.Pos = a.Position;
			
			peak.Face = Enum.NormalId.Right
			
			-- print('a');
			
		elseif a.Distance == peak.Dist then
			peak.Dist = a.Distance;
			peak.Pos = peak.Pos >= a.Position and peak.Pos - a.Position or a.Position - peak.Pos;
			
			peak.Face = Enum.NormalId.Right
			
			-- print('a');
		end

		-- visual.CFrame = CFrame.lookAt(peak.Pos, hitbox.Position)*CFrame.new(0, 0, -peak.Dist/2) 



	elseif b and b.Instance == part then
		--[[visual.Position = hrp.Position;
		visual.CFrame = CFrame.lookAt(b.Position, hitbox.Position)*CFrame.new(0, 0, -b.Distance/2)]]

		if b.Distance < peak.Dist then
			peak.Dist = b.Distance;
			peak.Pos = b.Position;
			
			peak.Face = Enum.NormalId.Back
			
			-- print('b');
			
		elseif b.Distance == peak.Dist then
			peak.Dist = b.Distance;
			peak.Pos = peak.Pos >= b.Position and peak.Pos - b.Position or b.Position - peak.Pos;
		
			peak.Face = Enum.NormalId.Back
		
			-- print('b');
		end

		-- visual.CFrame = CFrame.lookAt(peak.Pos, hitbox.Position)*CFrame.new(0, 0, -peak.Dist/2) 


	elseif c and c.Instance == part then
		--[[visual.Position = hrp.Position;
		visual.CFrame = CFrame.lookAt(c.Position, hitbox.Position)*CFrame.new(0, 0, -c.Distance/2)]]

		if c.Distance < peak.Dist then
			peak.Dist = c.Distance;
			peak.Pos = c.Position;
			
			
			peak.Face = Enum.NormalId.Left
			
			
			-- print('c');
			
		elseif c.Distance == peak.Dist then
			peak.Dist = c.Distance;
			peak.Pos = peak.Pos >= c.Position and peak.Pos - c.Position or c.Position - peak.Pos;
			
			
			peak.Face = Enum.NormalId.Left
			
			-- print('c');
			
		end

		-- visual.CFrame = CFrame.lookAt(peak.Pos, hitbox.Position)*CFrame.new(0, 0, -peak.Dist/2)


	elseif d and d.Instance == part then
		--[[visual.Position = hrp.Position;
		visual.CFrame = CFrame.lookAt(d.Position, hitbox.Position)*CFrame.new(0, 0, -d.Distance/2)]]

		if d.Distance < peak.Dist then
			peak.Dist = d.Distance;
			peak.Pos = d.Position;
			
			peak.Face = Enum.NormalId.Front
			
			-- print('d');
			
		elseif d.Distance == peak.Dist then
			peak.Dist = d.Distance;
			peak.Pos = peak.Pos >= d.Position and peak.Pos - d.Position or d.Position - peak.Pos;
			
			peak.Face = Enum.NormalId.Front
			
			-- print('d');
			
		end

		-- visual.CFrame = CFrame.lookAt(peak.Pos, hitbox.Position)*CFrame.new(0, 0, -peak.Dist/2) 
	end
	
	return peak;
end


humanoid.StateChanged:Connect(function(old, new)
	if old == Enum.HumanoidStateType.Freefall and new == Enum.HumanoidStateType.Landed and wallJumping.Value then
		wallJumping.Value = false;
	end
end)


uis.InputBegan:Connect(function(Input)

	if Input.KeyCode == Enum.KeyCode.Space and wallSliding.Value and humanoid.FloorMaterial == Enum.Material.Air and jumps > 0 then
		Jumping:Play();
		jumps -= 1;
		wallJumping.Value = true;
		
		if slamming.Value or slamJump.Value then
			slamStorage.Value = true;
		end
		
		local ignored = {};

		for _, p in pairs(character:GetDescendants()) do
			if p:IsA("BasePart") then
				table.insert(ignored, p);
			end
		end

		local function IsIgnored(part)
			for i, p in pairs(ignored) do
				if p == part then
					return true;
				end
			end
			return false;
		end

		for _, part in pairs(hitbox:GetTouchingParts()) do

			if not IsIgnored(part) then
				
				local peak = Raycast(part);
				
				if peak.Pos then
					hrp.AssemblyLinearVelocity = CFrame.lookAt(hitbox.Position, peak.Pos).LookVector * Vector3.new(100, 100, 100) + Vector3.new(0, 115, 0)
				end	
			end
		end
	end
	
end)


local thirdPerson = Values:Fetch("thirdPerson");


wallSliding.Changed:Connect(function()
	if wallSliding.Value == true then
		Sound:Play()
	else
		Sound:Stop();
	end
end)


hitbox.Touched:Connect(function() end);


local cameraTween = nil;


RunService.RenderStepped:Connect(function()
	
	if not player:WaitForChild("wallSlideEnabled").Value then return end;
	
	local ignored = {};
	
	for _, p in pairs(character:GetDescendants()) do
		if p:IsA("BasePart") then
			table.insert(ignored, p);
		end
	end
	
	local function IsIgnored(part)
		for i, p in pairs(ignored) do
			if p == part then
				return true;
			end
		end
		return false;
	end
	
	for _, part in pairs(hitbox:GetTouchingParts()) do
		
		if not IsIgnored(part) and hrp.Velocity.Y < 0 and humanoid.FloorMaterial == Enum.Material.Air and part.CanCollide and not thirdPerson.Value then
			wallSliding.Value = true;
			
			local tilt = 25;
			
			
			local peak = Raycast(part);
			
			if peak.Pos then
				
				local pp = peak.Pos - hrp.Position;
				
				-- pp = Vector3.new(math.clamp(math.round(pp.X), 0, 1), math.clamp(math.round(pp.Y), 0, 1), math.clamp(math.round(pp.Z), 0, 1));
				
				-- print(pp);
				
				local x, y, z = CFrame.lookAt(hitbox.Position, peak.Pos):ToOrientation();
			end
			
			
			cameraTween = ts:Create(camera, TweenInfo.new(2), {
				CFrame = camera.CFrame * CFrame.fromOrientation(0, 0, 0)
			});
			
			cameraTween:Play();
			
			hrp.Velocity = Vector3.new(hrp.Velocity.X/2, -15, hrp.Velocity.Z/2);
			
			return;
		end
	end
	
	if cameraTween then
		cameraTween:Cancel();
	end
	wallSliding.Value = false;
end)