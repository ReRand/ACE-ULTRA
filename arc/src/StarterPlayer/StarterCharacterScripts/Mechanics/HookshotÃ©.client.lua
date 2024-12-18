-- repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;
repeat task.wait() until player.spawned.Value;

local event = game.ReplicatedStorage.GameEvents.Hookshot;
local endclient = game.ReplicatedStorage.GameEvents.HookshotEnd.Client;
local endserver = game.ReplicatedStorage.GameEvents.HookshotEnd.Server;

local storedparticle = game.ReplicatedStorage:WaitForChild("Particles").HookParticle

local ts = game:GetService("TweenService");
local Values = require(workspace.Modules.Values);
local GlobalDamage = require(workspace.Modules.GlobalDamage);
local RunService = game:GetService("RunService");
local StarterPlayer = game:GetService("StarterPlayer");

local uis = game:GetService("UserInputService");
local cas = game:GetService("ContextActionService");
local character = player.Character or player.CharacterAdded:Wait();

local camera = workspace.CurrentCamera;

local mmg = require(script.Parent.Parent.Modules.MobileMockGui);


local humanoid = character:WaitForChild("Humanoid");
local hrp = character:WaitForChild("HumanoidRootPart");

local baseVel = nil;

local speedEmitter = nil;

local hooking = Values:Fetch("hooking");

local Sounds = game.ReplicatedStorage.GameSounds.Hookshot;

local typing = Values:Fetch("typing");
local thirdPerson = Values:Fetch("thirdPerson");
local emotesMenuOpen = Values:Fetch("emotesMenuOpen");
local viewportModel = Values:Fetch("viewportModel");
local spawned = player.spawned;
local hookObject = player:WaitForChild("hookObject");

local mouse = player:GetMouse();
local cooldown = false;
local cd = 0.1;
local readytostop = false;

local alreadytouched = {};


local function Began(Input)

	if not emotesMenuOpen.Value and not cooldown and not hooking.Value and not thirdPerson.Value and not typing.Value and spawned.Value and player:WaitForChild("hookEnabled").Value then

		readytostop = false;

		local vp = viewportModel.Value;
		local arm = vp:WaitForChild("Right Arm");
		local rga = arm:WaitForChild("RightGripAttachment");
		
		local length = 75;
		
		local params = RaycastParams.new()
		params.IgnoreWater = true;
		params.FilterDescendantsInstances = { character };
		params.FilterType = Enum.RaycastFilterType.Exclude;
		
		local raycast = workspace:Raycast(rga.WorldCFrame.Position, camera.CFrame.LookVector*length, params);
		
		
		if raycast then
			
			hooking.Value = true;
			
			local thing = raycast.Instance;
			
			local isPoint = thing:HasTag("HookPoint");
			
			if thing.Parent:FindFirstChild("Humanoid") then
				isPoint = true;
				thing = thing.Parent:WaitForChild("HumanoidRootPart");
				GlobalDamage:Inflict(thing.Parent.Humanoid, 1);
			end
			
			hookObject.Value = thing;
			
			local point = Instance.new("Attachment");
			point.Parent  = thing:FindFirstChild("center") or thing;
			
			print(isPoint);
			
			local toCF;
			if isPoint then toCF = thing.CFrame.Position else toCF = raycast.Position end;
			toCF = CFrame.new(toCF);
			
			local shootdist = raycast.Distance;
			local shootspeed = 800;
			local pullspeed = 1500;
			
			
			local shoottime = shootdist/shootspeed;
			
			local trail = storedparticle.HookBeam:Clone();
			trail.Parent = arm;
			
			point.WorldCFrame = rga.WorldCFrame;
			
			trail.Attachment0 = rga;
			trail.Attachment1 = point;
			
			local shoottween = ts:Create(point, TweenInfo.new(shoottime, Enum.EasingStyle.Linear), {
				WorldCFrame = toCF
			});
			
			Sounds.ThrowStart:Play();
			Sounds.ThrowLoop:Play();
			
			
			shoottween.Completed:Connect(function()
				readytostop = true;
				
				if not isPoint then
					endclient:Fire();
				else
					Sounds.ThrowLoop:Stop();
					Sounds.PointGrab:Play();
					Sounds.Pull:Play();
					
					local hasbeentouched = false;
					
					for i, v in ipairs(alreadytouched) do
						if v == thing then
							hasbeentouched = true;
						end
					end
					
					if not hasbeentouched then
						table.insert(alreadytouched, thing);
						
						thing.Touched:Connect(function(p: BasePart)
							if hooking.Value and hookObject.Value == thing and p.Parent == character then
								if hrp.Velocity.Y <= 0 then
									hrp.Velocity += Vector3.new(0, 25);
								end
								endclient:Fire();
							end
						end);
					end
					
					local lv;
					if isPoint then lv = CFrame.lookAt(camera.CFrame.Position, toCF.Position) else lv = camera.CFrame end
					
					local bv = Instance.new("BodyVelocity")
					bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge);
					bv.Velocity = lv.LookVector * 100;
					bv.Parent = hrp;
					bv.Name = "HookshotVelocity";
				end
			end)
			
			shoottween:Play();
			
			endclient.Event:Connect(function()
				local pulldist = (rga.WorldCFrame.Position - point.CFrame.Position).Magnitude;
				
				local pulltime = pulldist/pullspeed;
				
				local pulltween = ts:Create(point, TweenInfo.new(pulltime, Enum.EasingStyle.Linear), {
					WorldCFrame = rga.WorldCFrame
				});
				
				shoottween:Pause();
				
				Sounds.ThrowLoop:Stop();
				
				if not Sounds.Pull.IsPlaying then
					Sounds.Pull:Play();
				end
				
				for _, c in pairs(hrp:GetChildren()) do
					if c and c.Name == "HookshotVelocity" then
						c:Destroy();
					end
				end
				
				pulltween.Completed:Connect(function()
					hooking.Value = false;
					point:Destroy();
					Sounds.Pull:Stop();
				end)
				
				pulltween:Play();
				Sounds.Clink:Play();
			end);

			if thing:HasTag("HookPoint") then
				local emitter = thing.center.Emitter;
				emitter:Emit(1);
			end
			
			print(trail);
		end
		
	end
end



local function End(Input)
	if not emotesMenuOpen.Value and hooking.Value and not thirdPerson.Value and not typing.Value and spawned.Value then
		task.delay(0.01, function()
			endclient:Fire();
			cooldown = true;

			task.delay(cd, function()
				cooldown = false;
			end);
		end)
	end
end


cas:BindAction("Hookshot", function(name, state, Input)
	if state == Enum.UserInputState.Begin then
		Began(Input);
	elseif state == Enum.UserInputState.End then
		End(Input);
	end
end, true, Enum.KeyCode.R);


mmg:Replicate("Hookshot");