-- repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;
repeat task.wait() until player.spawned.Value;

local TweenService = game:GetService("TweenService");
local Values = require(workspace.Modules.Values);
local RunService = game:GetService("RunService");
local StarterPlayer = game:GetService("StarterPlayer");

local uis = game:GetService("UserInputService")
local character = player.Character or player.CharacterAdded:Wait();

local humanoid = character:WaitForChild("Humanoid");
local Animator = humanoid:WaitForChild("Animator");
local hrp = character:WaitForChild("HumanoidRootPart");
local baseVel = nil;

local baseGrav = workspace.Gravity;
local cooldown = false;
local jumpCooldown = false;

local slamJump = Values:Fetch("slamJump");
local gravityAlter = Values:Fetch("GravityAlteration");

local jumpHeight = nil;
local topHeight = nil;
local groundHeight = nil;
local speedEmitter = nil;

local camera = workspace.CurrentCamera;

local CameraShaker = require(workspace.Modules.CameraShaker);

local function ShakeCamera(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end


local renderPriority = Enum.RenderPriority.Camera.Value + 1

local cs = CameraShaker.new(renderPriority, ShakeCamera)
cs:Start();

-- 16799486334


local Sound = game.ReplicatedStorage.GameSounds.SlideSlam:WaitForChild("Slam")


local GlobalDamage = require(workspace.Modules.GlobalDamage);


-- if not player:HasAppearanceLoaded() then player.CharacterAppearanceLoaded:Wait() end

task.wait()

local mainAnim = game.ReplicatedStorage.PlayerAnimations.Slam.SlamMain;
local SlamMainAnim = Animator:LoadAnimation(mainAnim);

repeat task.wait() until SlamMainAnim.Length > 0


local stamina = Values:Fetch("stamina");
local staminaHold = Values:Fetch("staminaHold");
local typing = Values:Fetch("typing");
local wallJumping = Values:Fetch("wallJumping");
local slamStorage = Values:Fetch("slamStorage");

local spawned = player.spawned


local event = game.ReplicatedStorage.GameEvents.SlideSlam:WaitForChild("Slam");


local peakVel = 0;
local thirdPerson = Values:Fetch("thirdPerson");
local emotesMenuOpen = Values:Fetch("emotesMenuOpen");


event.Event:Connect(function(Input)
	
	if player:WaitForChild("slamEnabled").Value and not typing.Value and not emotesMenuOpen.Value and not thirdPerson.Value and stamina.Value > 0 and spawned.Value and humanoid.FloorMaterial == Enum.Material.Air then

		topHeight = hrp.Position.Y;
		local damaged = {};
		peakVel = 0;

		local stoppers = { "slamming", "ragdoll" };
		local disablers = {
			wallJumping = "guh"
		}


		local slamming = Values:Fetch("slamming");


		for _, stopper in ipairs(stoppers) do
			local val = Values:Fetch(stopper);
			if (val.Value) then return; end
		end


		for valueName, hitboxName in pairs(disablers) do
			local val = Values:Fetch(valueName);
			local playerval = player:FindFirstChild("valueName");
			
			if val.Value then
				val.Value = false;
			end
			
			if playerval then
				playerval.Value = false;
			end
			
			local hitbox = hrp:FindFirstChild(hitboxName);
			if hitbox then hitbox:Destroy(); end
		end


		baseVel = hrp.Velocity;


		local launchHb = Instance.new("Part", hrp)
		launchHb.Name = "GroundSlaméHitbox";
		launchHb.Size = Vector3.new(10,3,10)
		launchHb.CanCollide = false
		launchHb.Massless = true
		launchHb.Transparency = 1
		launchHb.Color = Color3.fromRGB(217, 0, 0)
		launchHb.Material = 'Neon'

		local weld = Instance.new("Weld", launchHb)
		weld.Name = "SillyCDHBWeld";
		weld.Part0 = hrp;
		weld.Part1 = launchHb;
		weld.C1 = CFrame.new(0, 5.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);


		local cooleffect = game.ReplicatedStorage:WaitForChild("Particles").SlamThing:Clone();
		cooleffect.Anchored = false;
		cooleffect.Parent = workspace;

		local ceWeld = Instance.new("Weld", cooleffect);
		ceWeld.Part0 = cooleffect;
		ceWeld.Part1 = launchHb
		ceWeld.C1 = CFrame.new(0, 3, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);



		local dmgHb = Instance.new("Part", hrp)
		dmgHb.Name = "GroundSlaméDamageHitbox";
		dmgHb.Size = Vector3.new(2,6,2)
		dmgHb.CanCollide = false
		dmgHb.Massless = true
		dmgHb.Transparency = 1
		dmgHb.Color = Color3.fromRGB(217, 0, 0)
		dmgHb.Material = 'Neon'

		local weld = Instance.new("Weld", dmgHb)
		weld.Name = "SillyCDHBWeld";
		weld.Part0 = hrp;
		weld.Part1 = dmgHb;
		weld.C1 = CFrame.new(0, 5.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);


		dmgHb.Touched:Connect(function(v)
			local eChar = v.Parent

			if eChar and eChar ~= character and eChar:FindFirstChild("Humanoid") and not damaged[eChar.Name] and peakVel/100 >= 1.5 then
				local eHuman = eChar.Humanoid;

				groundHeight = hrp.Position.Y;
				local height = topHeight - groundHeight;

				if height < 0 then height = -height end

				if  not workspace.GlobalValues.Game.ended.Value then
					damaged[eChar.Name] = true;

					GlobalDamage:Inflict(eHuman, math.floor(peakVel/20)*2 );
				end

				dmgHb:Destroy();

				cooldown = true;
			end
		end)

		launchHb.Touched:Connect(function(v)
			local eChar = v.Parent

			if eChar ~= character and eChar:FindFirstChild("Humanoid") and not damaged[eChar.Name] and peakVel/100 >= 1.5 then
				local eHuman = eChar.Humanoid;

				groundHeight = hrp.Position.Y;
				local height = topHeight - groundHeight;

				if height < 0 then height = -height end

				if  not workspace.GlobalValues.Game.ended.Value then

					damaged[eChar.Name] = true;

					GlobalDamage:Inflict(eHuman, 1, "fling", Vector3.new(0, math.floor(peakVel)/2, 0));
				end

				launchHb:Destroy();

				local effects = game.ReplicatedStorage.GameEvents.SlideSlam:WaitForChild("SlamEffects");
				effects:FireServer(character, hrp.Position, peakVel)
				cooleffect:Destroy();

				cooldown = true;
			end
		end)

		local cooldownTime = nil;

		if cooldown then
			cooldownTime = 3;
		else
			cooldownTime = 0;
		end

		cooldown = true;

		hrp.Velocity += Vector3.new(0, -200, 0);
		jumpHeight = hrp.Position.Y
		slamming.Value = true;
		staminaHold.Value = true;
		
		
		if wallJumping.Value then
			slamStorage.Value = true;
		end


		SlamMainAnim:Play();


		local baseOffset = Vector3.new(0, 0, -1);

		(TweenService:Create(humanoid, TweenInfo.new(1), {
			CameraOffset = Vector3.new(0, 2, -2)
		})):Play();


		local done = false;
		local rottime = 3;


		--[[local thing = TweenService:Create(cooleffect, TweenInfo.new(rottime, Enum.EasingStyle.Linear), {
			Rotation = Vector3.new(0, math.random(10, 180), 0)
		});

		thing.Completed:Connect(function()
			if not done then
				TweenService:Create(cooleffect, TweenInfo.new(rottime, Enum.EasingStyle.Linear), {
					Rotation = Vector3.new(0, math.random(10, 180), 0)
				}):Play()
			end
		end)


		thing:Play()]]


		repeat (function()
				local vel = math.abs(hrp.Velocity.Y);

				if vel > peakVel then
					peakVel = vel;
				end

				launchHb.Size = Vector3.new(vel/100*4, launchHb.Size.Y, vel/100*4);
				cooleffect.Size = launchHb.Size;

				if peakVel/100 >= 1.5 then
					-- speedEmitter.Enabled = true;
				end

				task.wait();
			end)()until humanoid.FloorMaterial ~= Enum.Material.Air;


		done = true;
		slamming.Value = false;


		if hrp:FindFirstChild("SlamWindEmitter") then hrp:FindFirstChild("SlamWindEmitter"):Destroy(); end


		if peakVel > 200 then
			stamina.Value -= math.round(peakVel/15);
		end


		local baseVol = Sound.Volume;

		Sound.Volume = ((peakVel/100)/2)/3;


		SlamMainAnim:Stop();
		Sound:Play();

		Sound.Ended:Connect(function()
			Sound.Volume = baseVol
		end);


		(TweenService:Create(humanoid, TweenInfo.new(0.1), {
			CameraOffset = baseOffset
		})):Play();


		cs:ShakeOnce(math.abs(peakVel)/225, 25, 0, 0.6);


		gravityAlter.Value = true;
		
		local GravityTween = TweenService:Create(workspace, TweenInfo.new(1), {
			Gravity = 500000000
		});
		
		GravityTween:Play();

		hrp.Velocity = baseVel;
		damaged = {};

		local effects = game.ReplicatedStorage.GameEvents.SlideSlam:WaitForChild("SlamEffects")
		effects:FireServer(character, hrp.Position, peakVel)
		cooleffect:Destroy();

		slamJump.Value = true;
		groundHeight = hrp.Position.Y;

		task.wait(0.1)
		
		launchHb:Destroy();
		dmgHb:Destroy();
		
		GravityTween:Cancel();

		gravityAlter.Value = false;
		workspace.Gravity = baseGrav;

		task.delay(math.abs(peakVel/1000), function()
			staminaHold.Value = false;
		end)

		task.wait(cooldownTime)
		
		cooldown = false;


	elseif not typing.Value and not thirdPerson.Value and stamina.Value <= 0 and humanoid.FloorMaterial == Enum.Material.Air then
		local label = player.PlayerGui.CoolGui.Left.Frame.dash

		local t1 = TweenService:Create(label, TweenInfo.new(0.2), {
			TextColor3 = Color3.fromRGB(255)
		});

		local t2 = TweenService:Create(label, TweenInfo.new(0.2), {
			TextColor3 = Color3.fromRGB(25, 184, 179)
		});

		t1.Completed:Connect(function()
			t2:Play();
		end)

		t1:Play();
	end
end)


uis.InputBegan:Connect(function(Input)
	
	if Input.KeyCode == Enum.KeyCode.Space and slamJump.Value and humanoid.FloorMaterial ~= Enum.Material.Air then
		
		pcall(function()
			
			local mult = 0.4;
			
			local height = ((topHeight - groundHeight)*mult) > humanoid.JumpHeight/2 and ((topHeight - groundHeight)*mult) or StarterPlayer.CharacterJumpHeight/2;

			if slamStorage.Value then
				slamStorage.Value = false;
				height *= 3;
			end

			humanoid.JumpHeight = height;

			task.delay(0.7, function()
				humanoid.JumpHeight = StarterPlayer.CharacterJumpHeight;
			end)
		end)
	end 
end)