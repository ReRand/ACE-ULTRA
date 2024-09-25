repeat task.wait() until script;
repeat task.wait() until script.Parent;

local firer = game.ReplicatedStorage.GameEvents.ProjMod:WaitForChild("Firer");
local expler = game.ReplicatedStorage.GameEvents.ProjMod:WaitForChild("Exploder");
local rfcm = game.ReplicatedStorage.GameEvents.ProjMod:WaitForChild("RunFireClientModules");

local Revared = require(workspace.Modules.Revared);
local global = Revared:GetModule("GlobalSide");

local cs = game:GetService("CollectionService");

local ts = game:GetService("TweenService");


local cd = game.ReplicatedStorage.GameEvents.ProjMod:WaitForChild("ClientDamage")
local delayed = {};


local Exploder = require(workspace.Modules.Exploder);


expler.OnServerEvent:Connect(function(player, part, config, replace)
	
	local config = part:FindFirstChild("BulletConfig");

	if not config then
		config = Instance.new("Configuration", part);
		config.Name = "BulletConfig";
	end

	for _, c in pairs(config:GetChildren()) do
		if replace and config:FindFirstChild(c.Name) then
			c:Clone().Parent = part;
		elseif not replace then
			c:Clone().Parent = part;
		end
	end
	
	local expl = Exploder.new(player, part, "bullet", {
		ParryConfig = part:FindFirstChild("ParryConfig"),
		BulletConfig = part:FindFirstChild("BulletConfig")
	});
	
	expl.Primed:Connect(function()
		expl:Explode();
	end)

	expl:Prime();
end)


firer.OnServerEvent:Connect(function(player, hrp, ammotype, vel, cf, customconfig)
	
	local id = player.UserId
	
	local part = ammotype:Clone();
	part.Parent = workspace:WaitForChild("Projectiles");
	
	part.Anchored = false;
	
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


	local configs = {
		ParryConfig = part:FindFirstChild("ParryConfig"),
		BulletConfig = part:FindFirstChild("BulletConfig"),
		CustomConfig = customconfig,
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
	end
	
	
	part.AssemblyLinearVelocity = vel*velMult.Value;
	
	
	local soundTbl = {};
	
	for _, s in pairs(sounds) do
		
		local sound = s.Value:Clone();
		table.insert(soundTbl, sound);
		sound.Parent = part;
		sound:Play();
	end


	part.CFrame = cf + Vector3.new(0, 0.4, 0);

	local x, y, z = cf.Rotation:ToOrientation();

	part.Orientation = Vector3.new(math.deg(x), math.deg(y), math.deg(z)) + rotAdd.Value;

	if ammotype:FindFirstChild("BulletConfig") and ammotype.BulletConfig:FindFirstChild("Modules") then
		for _, mod in pairs(ammotype.BulletConfig.Modules.Shot.Server:GetChildren()) do
			require(mod)(player, ammotype, part, customconfig);
		end
	end
	
	
	firer:FireClient(player, ammotype, customconfig);


	if behavior.Value == "boom" then

		local hitbox = part:FindFirstChild("Hitbox") or part;
		hitbox.Touched:Connect(function() end);

		local expl = Exploder.new(player, part, "bullet", configs);

		expl:Prime();
		
		
		expl.Exploded:Connect(function()
			for _, s in pairs(soundTbl) do
				s:Stop();
			end
		end)


	elseif behavior.Value == "pierce" then
		local hitbox = part:FindFirstChild("Hitbox") or part;
		hitbox.Touched:Connect(function() end);

		while task.wait() do 
			if hitbox and #hitbox:GetTouchingParts() > 0 then

				for i, p in ipairs(hitbox:GetTouchingParts()) do

					local voidHit = false;

					for i, victim in ipairs(hitbox:GetTouchingParts()) do
						if p == hrp or p.Parent.Name == player.Name then voidHit = true;
						elseif p:FindFirstChild("voided") and p:FindFirstChild("voided").Value == true then voidHit = true;
						end

						if not voidHit then

							if part.Name == "HumanoidRootPart" then
								local eHuman = part.Parent:FindFirstChild("Humanoid");
								eHuman.Health = 0;
							end

							local voidHit = false;

							if victim == hrp or victim.Parent.Name == player.Name then voidHit = true;
							elseif victim:FindFirstChild("voided") and victim:FindFirstChild("voided").Value == true then voidHit = true;
							end

							local eHuman = victim.Parent:FindFirstChild("Humanoid");
							if eHuman then
								local config = part:FindFirstChild("BulletConfig");

								if config then
									local damage = config:FindFirstChild("damage") or { Value = 100 };
									cd:FireClient(player, eHuman, damage.Value);
								end
							else
								part:Destroy();
								break;
							end
						end
					end
				end
			end
		end
		
	elseif behavior.Value == "flat" then
		local hitbox = part:FindFirstChild("Hitbox") or part;
		hitbox.Touched:Connect(function() end);
		
		local projectile = part;

		while task.wait() do 
			
			if hitbox and #hitbox:GetTouchingParts() > 0 then

				for i, p in ipairs(hitbox:GetTouchingParts()) do

					local voidHit = false;

					for i, victim in ipairs(hitbox:GetTouchingParts()) do
						if p == hrp or p.Parent.Name == player.Name then voidHit = true;
						elseif p:FindFirstChild("voided") and p:FindFirstChild("voided").Value == true then voidHit = true;
						end

						if not voidHit then

							if part.Name == "HumanoidRootPart" then
								local eHuman = part.Parent:FindFirstChild("Humanoid");
								eHuman.Health = 0;
							end

							local voidHit = false;

							if victim == hrp or victim.Parent.Name == player.Name then voidHit = true;
							elseif victim:FindFirstChild("voided") and victim:FindFirstChild("voided").Value == true then voidHit = true;
							end

							local eHuman = victim.Parent:FindFirstChild("Humanoid");
							if eHuman then
								
								local config = part:FindFirstChild("BulletConfig");
								
								if config then
									local damage = config:FindFirstChild("damage") or { Value = 100 };
									cd:FireClient(player, eHuman, damage.Value);
									projectile:Destroy();
								end
								
							else
								part:Destroy();
								break;
							end
						end
					end
				end
			end
		end
	end
end)