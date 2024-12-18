local Values = require(workspace.Modules.Values);
local player = game.Players.LocalPlayer;
local loaded = player.loaded;

repeat task.wait() until loaded.Value

local Heartslag = {};

local id = script.Parent.id.Value;

local ammo = script.Parent.ammo;
local character = player.Character or player.CharacterAdded:Wait();


local wm = require(script.Parent.Parent.Parent.Modules.WeaponModule);
local pm = require(script.Parent.Parent.Parent.Modules.ProjectileModule);
local hsm = require(script.Parent.Parent.Parent.Modules.HitscanModule);
local model = wm:GetWeaponModelFromId(id);
local vpModel = wm:GetViewportWeaponModelFromId(id);
local label = model:WaitForChild("ammo").SurfaceGui.Frame.TextLabel;


local TweenService = game:GetService("TweenService");

local t1 = TweenService:Create(label, TweenInfo.new(0.1), {
	TextColor3 = Color3.fromRGB(255)
});

local t2 = TweenService:Create(label, TweenInfo.new(0.1), {
	TextColor3 = Color3.fromRGB(0)
});

t1.Completed:Connect(function()
	t2:Play();
end)


local bullet = game.ReplicatedStorage.AmmoTypes.MeatBullet
local fireAnim = game.ReplicatedStorage.GunAnimations.Heartslag.Fire;


local fireCooldown = false;

local sounds = game.ReplicatedStorage.GameSounds.Heartslag;
local fire1 = sounds.Fire1;
local fire2 = sounds.Fire2;


function Heartslag:Fire()
	if ammo.Value > 0 and not fireCooldown then
		-- print("fire")
		
		model = wm:GetWeaponModelFromId(id);
		
		if model then
			
			local animator = model:WaitForChild("AnimationController"):WaitForChild("Animator");
			local loadedFire = animator:LoadAnimation(fireAnim);
			loadedFire.Looped = false;


			loadedFire:Play();
			
			
			local attachment = character:WaitForChild("Torso"):WaitForChild("Right Shoulder");
			
			local t1 = TweenService:Create(attachment, TweenInfo.new(0.1), {
				C1 = attachment.C1 + Vector3.new(0, 0.5, -0.1)
			});

			local t2 = TweenService:Create(attachment, TweenInfo.new(0.1), {
				C1 = attachment.C1 - Vector3.new(0, 0.5, -0.1)
			});

			t1.Completed:Connect(function()
				t2:Play();
			end)
			
			t1:Play();
		end
		
		ammo.Value -= 1;
		fire1:Play();
		fire2:Play();
		
		
		hsm:Init(bullet, { WeaponId = id });
		
		
		fireCooldown = true;
		
		task.wait(0.1);
		
		fireCooldown = false;
		
	elseif ammo.Value <= 0 then
		model = wm:GetWeaponModelFromId(id);
		
		if model then
			label = model.ammo.SurfaceGui.Frame.TextLabel;
			
			local t1 = TweenService:Create(label, TweenInfo.new(0.1), {
				TextColor3 = Color3.fromRGB(255)
			});

			local t2 = TweenService:Create(label, TweenInfo.new(0.1), {
				TextColor3 = Color3.fromRGB(0)
			});

			t1.Completed:Connect(function()
				t2:Play();
			end)
			
			t1:Play();
		end
	end
end


local SwitchTo = script.SwitchTo;


SwitchTo.Event:Connect(function()
	
	game.ReplicatedStorage.GameSounds.Equip:Play();
	
	task.wait(0.1)
	
	model = wm:GetWeaponModelFromId(id);
	vpModel = wm:GetViewportWeaponModelFromId(id);
	
	model:WaitForChild("ammo"):WaitForChild("SurfaceGui").Enabled = false;
	
	label = vpModel:WaitForChild("ammo"):WaitForChild("SurfaceGui"):WaitForChild("Frame"):WaitForChild("TextLabel");
	label.Text = ammo.Value;
end)



return Heartslag;