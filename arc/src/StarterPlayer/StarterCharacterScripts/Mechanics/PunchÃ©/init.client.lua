-- repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;
repeat task.wait() until player.spawned.Value;

local TweenService = game:GetService("TweenService");
local Values = require(workspace.Modules.Values);
local RunService = game:GetService("RunService");
local StarterPlayer = game:GetService("StarterPlayer");

local uis = game:GetService("UserInputService")
local cas = game:GetService("ContextActionService");
local character = player.Character or player.CharacterAdded:Wait();

local humanoid = character:WaitForChild("Humanoid");
local Animator = humanoid:WaitForChild("Animator");
local hrp = character:WaitForChild("HumanoidRootPart");

local cooldown = false;

local camera = workspace.CurrentCamera;

local mmg = require(script.Parent.Parent.Modules.MobileMockGui);
local CWeld = require(script.Parent.Parent.Modules.CWeld);

local CameraShaker = require(workspace.Modules.CameraShaker);

local function ShakeCamera(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end

local lighting = game.Lighting;

local Values = require(workspace.Modules.Values);
local stamina = Values:Fetch("stamina");

local pdisplay = Instance.new("Part", hrp)
pdisplay.Name = "ParryDisplay";
pdisplay.Size = Vector3.new(1, 1, 1)
pdisplay.CanCollide = false
pdisplay.Massless = true
pdisplay.Transparency = 1
pdisplay.Color = Color3.fromRGB(217, 0, 0)
pdisplay.Material = 'Neon'

local weld = Instance.new("Weld", pdisplay)
weld.Name = "SillyCDHBWeld";
weld.Part0 = hrp;
weld.Part1 = pdisplay;
weld.C1 = CFrame.new(-0.000244140625, -1, 3.99987793, 1, 0, 0, 0, 1, 0, 0, 0, 1)

local parry = game.ReplicatedStorage:WaitForChild("Particles"):WaitForChild("ParryEmitter").ParryEmitter:Clone();
parry.Enabled = false;
parry.Parent = pdisplay;

parry.ImageLabel.Rotation = 10;
parry.ImageLabel.ImageTransparency = 1;
parry.Size = UDim2.new(0, 0, 0, 0);

local tweenTime = 0.1;


local renderPriority = Enum.RenderPriority.Camera.Value + 1

local cs = CameraShaker.new(renderPriority, ShakeCamera)
cs:Start();

-- 16799486334



local colser = game:GetService("CollectionService");


local GlobalDamage = require(workspace.Modules.GlobalDamage);
local GlobalHealing = require(workspace.Modules.GlobalHealing);

local mainAnim = game.ReplicatedStorage.PlayerAnimations.Punch.PunchMain;
local PunchAnim = Animator:LoadAnimation(mainAnim);
PunchAnim.Looped = false;


local mainParryAnim = game.ReplicatedStorage.PlayerAnimations.Parry.ParryMain;
local ParryAnim = Animator:LoadAnimation(mainParryAnim);
ParryAnim.Looped = false;


local leftArm = character:WaitForChild("Left Arm");

leftArm.Transparency = 1;
leftArm.LocalTransparencyModifier = 1;


local sounds = game.ReplicatedStorage.GameSounds.PunchParry


local Woosh = sounds.Woosh;
local Impact = sounds.Impact;
local ParryImpact = sounds.ParryImpact;
local Parry = sounds.Parry;
local Guardbreak = sounds.Guardbreak;
local Pierce = sounds.Pierce;


local wid = player:WaitForChild("weaponId");


local boomMsg = game.ReplicatedStorage.GameEvents.PunchParry:WaitForChild("BoomMessage")

boomMsg.OnClientEvent:Connect(function(part, radius)
	
	local mag = radius/125
	print(mag)
	
	cs:ShakeOnce(mag, radius/5, (0.1*radius)/1000, (radius/1000*(radius/10))/1.8 );
end)


local typing = Values:Fetch("typing")
local thirdPerson = Values:Fetch("thirdPerson");
local emotesMenuOpen = Values:Fetch("emotesMenuOpen");
local spawned = player.spawned


function Began(Input)

	if player:WaitForChild("punchEnabled").Value and not emotesMenuOpen.Value and not cooldown and not thirdPerson.Value and not typing.Value and spawned.Value and not workspace.GlobalValues.Game.ended.Value then
		
		local damaged = {};
		local peakVel = 0;
		
		local stoppers = { "ragdoll" };
		local disablers = {}
		
		
		local punching = Values:Fetch("punching");
		

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
		
		
		local punchHb = Instance.new("Part", hrp)
		punchHb.Archivable = true;
		punchHb.Name = "PunchéHitbox";
		punchHb.Size = Vector3.new(3, 4, 3)
		punchHb.CanCollide = false;
		punchHb.Massless = true;
		punchHb.Transparency = 0.5
		punchHb.Color = Color3.fromRGB(217, 0, 0)
		punchHb.Material = 'Neon'
		
		local weld = Instance.new("Weld", punchHb)
		weld.Name = "TheWeldingness";
		weld.Part0 = hrp;
		weld.Part1 = punchHb;
		weld.C1 = CFrame.new(-0.000244140625, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		
		
		local parryHb = punchHb:Clone();
		parryHb.Parent = hrp;
		parryHb.Name = "ParryHitbox"
		parryHb.Size = Vector3.new(8, 12, 6);
		parryHb.TheWeldingness.C1 = CFrame.new(-0.000244140625, 0, 3, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		
		
		punchHb.Touched:Connect(function(v)
			local eChar = v.Parent

			if eChar ~= character and eChar:FindFirstChild("Humanoid") and not damaged[eChar.Name] then
				local eHuman = eChar.Humanoid;
				
				damaged[eChar.Name] = true;
				
				GlobalDamage:Inflict(eHuman, 2);
				
				punchHb:Destroy();
				parryHb:Destroy();
				
				cooldown = true;
				
				wait(0.1);
				
				Impact:Play();
			end
		end)
		
		local cooldownTime = nil;
		
		if cooldown then
			cooldownTime = 1;
		else
			cooldownTime = 0;
		end
		
		cooldown = true;
	
	
		punching.Value = true;
		
		
		Woosh:Play();
		
		
		(TweenService:Create(leftArm, TweenInfo.new(0.1), {
			Transparency = 0,
			LocalTransparencyModifier = 0
		})):Play();
		
		
		PunchAnim:Play();
		cs:ShakeOnce(1, 5, 0.1, 0.5);
		
		
		parryHb.Touched:Connect(function() end)
		
		
		for i, part in ipairs(parryHb:GetTouchingParts()) do
			if not colser:HasTag(part, player.UserId) or (part:FindFirstChild("ParryConfig") and part.ParryConfig:FindFirstChild("boostable") and part.ParryConfig.boostable.Value) then
				if part:FindFirstChild("ParryConfig") and part.ParryConfig:FindFirstChild("parryable") and part.ParryConfig:FindFirstChild("parryable").Value then
					
					local config = part:FindFirstChild("ParryConfig");
					
					local parryLabelAnimIn = TweenService:Create(parry.ImageLabel, TweenInfo.new(tweenTime), {
						Rotation = math.random(10, 360),
						ImageTransparency = 0.5
					});
					local parryAnimIn = TweenService:Create(parry, TweenInfo.new(tweenTime), {
						Size = UDim2.new(10, 0, 10, 0)
					});
					local parryLabelAnimOut = TweenService:Create(parry.ImageLabel, TweenInfo.new(tweenTime), {
						Rotation = 0,
						ImageTransparency = 1
					});
					local parryAnimOut = TweenService:Create(parry, TweenInfo.new(tweenTime), {
						Size = UDim2.new(0, 0, 0, 0)
					});
					
					PunchAnim:AdjustSpeed(2);
					
					task.wait(0.1)
					
					lighting.ParryEffect.Enabled = true;
					
					PunchAnim:AdjustSpeed(0);
					
					local ignored = {};
					
					for i,v in pairs(workspace:GetDescendants()) do 
						if v:IsA("BasePart") then
							
							if v.Anchored then
								ignored[#ignored+1] = v;
							end
							
							v.Anchored = true
						end
					end
					
					camera.CameraType = Enum.CameraType.Scriptable;
					local behavior = part.ParryConfig:FindFirstChild("behavior") or { Value = "boom" };
					local radius = part.ParryConfig:FindFirstChild("radius") or { Value = 30 };
					local healing = part.ParryConfig:FindFirstChild("healing") or { Value = 15 };
					
					parryAnimIn.Completed:Connect(function()
						
						task.wait(0.3);
					
						if behavior.Value == "guardbreak" then
							wait(0.2)
							
							if part.Name == "HumanoidRootPart" then

								local damage = part.ParryConfig:FindFirstChild("damage") or { Value = 25 };

								local eHuman = part.Parent:FindFirstChild("Humanoid");
								GlobalDamage:Inflict(eHuman, damage.Value, "ace", 1);
							end
						end
						
						
						GlobalHealing:Inflict(humanoid, healing.Value);
						stamina.Value = 90;
						
						parryLabelAnimOut:Play();
						parryAnimOut:Play();
						lighting.ParryEffect.Enabled = false;
						
						if behavior.Value == "guardbreak" then
							Guardbreak:Play()
						elseif behavior.Value == "pierce" then
							Pierce:Play();
						else
						
							Parry:Play();
						end
							

						PunchAnim:AdjustSpeed(1);
						PunchAnim:Stop();
						
						camera.CameraType = Enum.CameraType.Custom
						
						local function isIgnored(part)
							for i, p in ipairs(ignored) do
								if p == part then return true end
							end
							return false;
						end
						
						for i,v in pairs(workspace:GetDescendants()) do 
							if v:IsA("BasePart") and not isIgnored(v) then
								v.Anchored = false
							end
						end
						
						local ServerVelocity = game.ReplicatedStorage.GameEvents.PunchParry:WaitForChild("ServerVelocity")
						ServerVelocity:FireServer(hrp, part, config, camera.CFrame.LookVector, camera.CFrame);
						
						ParryAnim:Play();
					end)
					
					parry.Enabled = true;
					
					ParryImpact:Play();

					parryLabelAnimIn:Play();
					parryAnimIn:Play();
					
					wait(0.7)
					
					punching.Value = false;
					parry.Enabled = false;
					damaged = {};

					punchHb:Destroy();
					parryHb:Destroy();

					local tween = TweenService:Create(leftArm, TweenInfo.new(0.5), {
						Transparency = 1,
						LocalTransparencyModifier = 1
					});

					leftArm.Transparency = 0;

					tween:Play()

					wait(0.05);

					cooldown = false;
					
					return;
				end
			end
		end
		
		wait(0.3)

		punching.Value = false;
		damaged = {};
		
		punchHb:Destroy();
		parryHb:Destroy();
		
		local tween = TweenService:Create(leftArm, TweenInfo.new(0.5), {
			Transparency = 1,
			LocalTransparencyModifier = 1
		});
		
		leftArm.Transparency = 0;
		
		tween:Play()
		
		wait(0.05);
		
		cooldown = false;
		
	end
end


cas:BindAction("Punch", function(name, state, Input)
	if state == Enum.UserInputState.Begin then
		Began(Input);
	end
end, true, Enum.KeyCode.F, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);


mmg:Replicate("Punch");





uis.InputBegan:Connect(function(Input)
	if (Input.UserInputType == Enum.UserInputType.MouseButton1 and wid.Value == 0) then
		Began(Input)
	end
end)