local Values = require(workspace.Modules.Values);
local player = game.Players.LocalPlayer;
local loaded = player.loaded;

local Bomb = {};

local id = script.Parent.id.Value;

local character = player.Character or player.CharacterAdded:Wait();

local hrp = character:WaitForChild("HumanoidRootPart");
local humanoid = character:WaitForChild("Humanoid");


local Values = require(workspace.Modules.Values);
local stamina = Values:Fetch("stamina");


local weaponId = player:WaitForChild("weaponId");


local wm = require(script.Parent.Parent.Parent.Modules.WeaponModule);
local pm = require(script.Parent.Parent.Parent.Modules.ProjectileModule);
local model = wm:GetWeaponModelFromId(id);


local wvm = wm.WeaponVisModule;


local ts = game:GetService("TweenService");

local fireCooldown = false;

local sounds = game.ReplicatedStorage.GameSounds.Bomb;


local GlobalDamage = require(workspace.Modules.GlobalDamage);
local GlobalHealing = require(workspace.Modules.GlobalHealing);

local cooldown = false;

local lighting = game:GetService("Lighting");
local tweenTime = 0.1;

local camera = workspace.CurrentCamera

local Animator = humanoid:WaitForChild("Animator");

local slashAnim = game.ReplicatedStorage.PlayerAnimations.Sword.SlashMain;
local SlashAnim = Animator:LoadAnimation(slashAnim);
SlashAnim.Looped = false;


local uis = game:GetService("UserInputService");

local bullet = game.ReplicatedStorage.AmmoTypes.Bomb;
local lit = script.Parent.lit;
local throwing = script.Parent.throwing;


local light = game.ReplicatedStorage.GameEvents.LightBomb
local unlight = game.ReplicatedStorage.GameEvents.UnlightBomb


local ct = 5;
local fuseTime = 6;


uis.InputEnded:Connect(function(Input)
	if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and lit.Value and weaponId.Value == script.Parent.id.Value then
		local model = wm:GetWeaponModelFromId(id);
		
		lit.Value = false;
		throwing.Value = true;
		
		local config = {
			Radius = { Value = bullet.BulletConfig.radius.Value },
			FuseTime = { Value = bullet.BulletConfig.fusetime.Value }
		};
		
		
		pm:Init(bullet, config);
		
		wvm:Disappear(model);
		unlight:FireServer(model);

		cooldown = true;
		task.wait(ct);
		
		if weaponId.Value == script.Parent.id.Value then
			wvm:Appear(model);
			unlight:FireServer(model);
			game.ReplicatedStorage.GameSounds.Equip:Play();	
		end
		
		throwing.Value = false;
		cooldown = false;
		
	elseif (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and lit.Value then
		
		local model = wm:GetWeaponModelFromId(id);
		
		unlight:FireServer(model);
		
		lit.Value = false;
		throwing.Value = false;
	end
end)


humanoid.Died:Connect(function()
	if lit.Value then
		
		local model = wm:GetWeaponModelFromId(id);
		
		unlight:FireServer(model);
		
		lit.Value = false;
		throwing.Value = false;
	end
end)


weaponId.Changed:Connect(function()
	
	local model = wm:GetWeaponModelFromId(id);
	
	if lit.Value and weaponId.Value ~= script.Parent.id.Value then
		
		unlight:FireServer(model);
		lit.Value = false;
		throwing.Value = false;
	end
end)


function upperFirst(str)
	return (str:gsub("^%l", string.upper))
end


function Bomb:Fire()
	if not cooldown and not throwing.Value then
		
		local model = wm:GetWeaponModelFromId(id);
		
		light:FireServer(model);
		lit.Value = true;
		
		local primed = true;
		
		lit.Changed:Connect(function()
			primed = false;
		end)
		
		local config = {};
		
		for _, c in pairs(bullet.BulletConfig:GetChildren()) do
			if string.match(c.ClassName, "Value") then
				config[upperFirst(c.Name)] = { Value = c.Value }
			else
				config[upperFirst(c.Name)] = c;
			end
		end
		
		task.delay(fuseTime, function()
			if primed then
				-- config.Radius.Value *= 1.5;
				pm:Explode(hrp, config, true);
			end
		end)
		
		
		while primed do
			task.wait(1)
			bullet.BulletConfig.radius.Value *= 1.2;
			bullet.BulletConfig.fusetime.Value -= 1;
		end
		
		
		bullet.BulletConfig.radius.Value = bullet.BulletConfig.defaultRadius.Value;
		bullet.BulletConfig.fusetime.Value = fuseTime;
	end
end


local SwitchTo = script.SwitchTo;


SwitchTo.Event:Connect(function()
	if cooldown then
		wvm:Disappear(model);
		unlight:FireServer(model);
	else
		game.ReplicatedStorage.GameSounds.Equip:Play();
	end
end)



return Bomb;