repeat task.wait() until script;
repeat task.wait() until script.Parent;

local firer = game.ReplicatedStorage.GameEvents.HtscMod:WaitForChild("Firer");
local rfcm = game.ReplicatedStorage.GameEvents.HtscMod:WaitForChild("RunFireClientModules");

local Revared = require(workspace.Modules.Revared);
local global = Revared:GetModule("GlobalSide");

local cs = game:GetService("CollectionService");

local ts = game:GetService("TweenService");


local cd = game.ReplicatedStorage.GameEvents.HtscMod:WaitForChild("ClientDamage")
local delayed = {};


local Exploder = require(workspace.Modules.Exploder);
local Flatter = require(workspace.Modules.Flatter);
local Fire = require(workspace.Modules.Fire);



firer.OnServerEvent:Connect(function(player, hrp, ammotype, customconfig, vel, cf)
	local id = player.UserId
	
	-- local hitcf = cf;
	-- local hit = cf.Position;
	
	local part = ammotype:Clone();
	part.Parent = workspace:WaitForChild("Projectiles");

	part.Anchored = true;

	cs:AddTag(part, id);
	
	
	local behavior = part.BulletConfig:FindFirstChild("behavior") or { Value = "boom" };

	local rotAdd = (part:FindFirstChild("BulletConfig") and part.BulletConfig:FindFirstChild("rotation")) and part.BulletConfig:FindFirstChild("rotation") or { Value = Vector3.new() };

	local sounds = (part:FindFirstChild("BulletConfig") and part.BulletConfig:FindFirstChild("playsound")) and part.BulletConfig:FindFirstChild("playsound"):GetChildren() or {};

	local velMult = part.BulletConfig:FindFirstChild("velocity") or { Value = 400 };

	local setDamage = part.BulletConfig:FindFirstChild("damage") or { Value = 10 };
	
	local knockback = part.BulletConfig:FindFirstChild("knockback") or { Value = false };
	local kbmult = part.BulletConfig:FindFirstChild("kbmult") or { Value = 3 };
	
	local fireProb = part.BulletConfig:FindFirstChild("fireProb") or { Value = 0 };
	local fireTime = part.BulletConfig:FindFirstChild("fireTime") or { Value = 5 };
	local fireTick = part.BulletConfig:FindFirstChild("fireTick") or { Value = 1 };
	local fireDamage = part.BulletConfig:FindFirstChild("fireDamage") or { Value = 1 };
	
	local hitscanTime = part.BulletConfig:FindFirstChild("hitscanTime") or { Value = 0 };
	
	local bulletHole = part.BulletConfig:FindFirstChild("bulletHole") or { Value = "rbxassetid://11543553259" };


	local configs = {
		ParryConfig = part:FindFirstChild("ParryConfig"),
		BulletConfig = part:FindFirstChild("BulletConfig"),
		CustomConfig = customconfig,
		Headshot = false
	}


	if customconfig then
		if customconfig.behavior then behavior = customconfig.behavior end
		if customconfig.rotAdd then rotAdd = customconfig.rotAdd end
		if customconfig.velMult then velMult = customconfig.velMult end
		if customconfig.playsound then sounds = customconfig.playsound end
		if customconfig.setDamage then setDamage = customconfig.setDamage end
		
		if customconfig.knockback then knockback = customconfig.knockback end
		if customconfig.kbmult then kbmult = customconfig.kbmult end
		
		if customconfig.fireProb then fireProb = customconfig.fireProb end
		if customconfig.fireTime then fireTime = customconfig.fireTime end
		if customconfig.fireTick then fireTick = customconfig.fireTick end
		if customconfig.fireDamage then fireDamage = customconfig.fireDamage end
		
		if customconfig.hitscanTime then hitscanTime = customconfig.hitscanTime end
		
		if customconfig.bulletHole then bulletHole = customconfig.bulletHole end
	end
	

	local soundTbl = {};

	for _, s in pairs(sounds) do

		local sound = s.Value:Clone();
		table.insert(soundTbl, sound);
		sound.Parent = part;
		sound:Play();
	end


	part.CFrame = cf;

	local x, y, z = cf.Rotation:ToOrientation();

	part.Orientation = Vector3.new(math.deg(x), math.deg(y), math.deg(z)) + rotAdd.Value;
	
	
	local mult = 4500
	
	
	local origin = hrp.Position
	
	local character = player.Character or player.CharacterAdded:Wait();
	
	local params = RaycastParams.new()
	params.IgnoreWater = true;
	params.FilterDescendantsInstances = { character };
	params.FilterType = Enum.RaycastFilterType.Exclude;
	
	local direction = cf.LookVector * mult
	local result1 = workspace:Raycast(cf.Position, direction, params);
	
	
	if result1 then
		
		local hit = result1.Position;
		local hitcf = CFrame.new(hit) * cf.Rotation;
		
		
		local direction = (hit - origin).Unit
		local result = workspace:Raycast(origin, direction*mult, params)
		
		
		local intersection = result and result.Position or origin + direction*mult
		local distance = (origin - intersection).Magnitude
		
		
		if ammotype:FindFirstChild("BulletConfig") and ammotype.BulletConfig:FindFirstChild("Modules") then
			for _, mod in pairs(ammotype.BulletConfig.Modules.Shot.Server:GetChildren()) do
				require(mod)(player, ammotype, part, customconfig, direction, intersection, distance);
			end
		end
		
		
		firer:FireClient(player, player, ammotype, customconfig, direction, intersection, distance);
		
		
		if result then
			
			
			
			local instHit = CFrame.lookAt(hit, result.Instance.Position);

			--[[local hitfix = CFrame.lookAt(hit, result1.Instance.Position) --* -distance/2;
			hitfix += hit;]]
			
			--[[local vis = Instance.new("Part", workspace);
			vis.Anchored = true;
			vis.Transparency = 1;
			
			vis.CanCollide = false;
			vis.CanTouch = false;
			vis.CanQuery = false;
			
			vis.CFrame = cf;
			
			local beam = Instance.new("Beam", vis);
			local beamstart = Instance.new("Attachment", vis);
			local beamend = Instance.new("Attachment", vis)
			
			beamstart.WorldCFrame = CFrame.new(hit);
			beamend.WorldCFrame = instHit;
			
			beam.FaceCamera = true;
			beam.Width0 = 2;
			beam.Width1 = 2;
			
			beam.Attachment0 = beamstart;
			beam.Attachment1 = beamend;]]
			
			
			
			local victim = result.Instance
			
			if victim.Name == "Head" then
				configs.Headshot = true;
			end
			
			local humanoid = victim.Parent:FindFirstChild("Humanoid") or victim.Parent.Parent:FindFirstChild("Humanoid")
			
			-- part.CFrame = hitfix;
			
			local mod = nil;
			
			
			ts:Create(part, TweenInfo.new( hitscanTime.Value--[[ * ((result.Distance/100)+1)]] ), {
				CFrame = hitcf
			}):Play();
			
			
			if behavior.Value == "boom" then
				mod = Exploder.new(player, part, "bullet", configs);
				
			elseif behavior.Value == "pierce" then
				mod = Flatter.new(player, part, "bullet", configs);
				
			elseif behavior.Value == "flat" then
				mod = Flatter.new(player, part, "bullet", configs);
			end
			
			
			
			if mod.HitObject then
				mod.HitObject:Connect(function()
					part:Destroy();
					
					local bulletHole = game.ReplicatedStorage:WaitForChild("Particles").BulletHole:Clone();
					bulletHole.Parent = workspace.BulletHoles;
					
					bulletHole.DecalB.Color3 = victim.Color;
					bulletHole.DecalF.Color3 = victim.Color;
					
					-- bulletHole.Attachment.particles.Color = ColorSequence.new(victim.Color);

					bulletHole.CFrame = CFrame.lookAt(result.Position, result.Position + result.Normal);
					
					task.delay(0.1, function()
						bulletHole.Attachment.particles:Emit(bulletHole.Attachment.particles.Rate);
					end)
					
					
					task.delay(3, function()
						bulletHole:Destroy();
					end)
				end)
			end
			
			if mod.HitHuman then
				mod.HitHuman:Connect(function()
					part:Destroy();

					local hiteffect = game.ReplicatedStorage:WaitForChild("Particles").HitEffects:Clone();
					hiteffect.Parent = workspace.HitEffects;

					hiteffect.CFrame = CFrame.lookAt(result.Position, result.Position + result.Normal);

					task.delay(0.1, function()
						hiteffect.Attachment.CircleEmitter:Emit(hiteffect.Attachment.CircleEmitter.Rate);
						hiteffect.Attachment.SparkEmitter:Emit(hiteffect.Attachment.SparkEmitter.Rate);
					end)

					
					task.delay(1, function()
						hiteffect:Destroy();
					end)
				end)
			end
			
			mod.Primed:Connect(function()
				print('primed ('..behavior.Value..')');
			end)
			
			mod:Prime();
		end
	end
end)