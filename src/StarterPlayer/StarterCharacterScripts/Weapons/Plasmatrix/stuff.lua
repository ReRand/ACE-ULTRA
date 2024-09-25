local Values = require(workspace.Modules.Values);
local player = game.Players.LocalPlayer;
local loaded = player.loaded;

repeat task.wait() until loaded.Value

local Plasmatrix = {};

local id = script.Parent.id.Value;


local character = player.Character or player.CharacterAdded:Wait();


local wm = require(script.Parent.Parent.Parent.Modules.WeaponModule);
local pm = require(script.Parent.Parent.Parent.Modules.ProjectileModule);
local hsm = require(script.Parent.Parent.Parent.Modules.HitscanModule);



local model = wm:GetWeaponModelFromId(id);


local TweenService = game:GetService("TweenService");


local bullet = game.ReplicatedStorage.AmmoTypes.Plasma;

local fireCooldown = false;

local sounds = game.ReplicatedStorage.GameSounds.Plasmatrix;
local fireAnim = game.ReplicatedStorage.GunAnimations.Plasmatrix.Fire;
-- local fire1 = sounds.Fire1;
-- local fire2 = sounds.Fire2;


function Plasmatrix:Fire()
	if not fireCooldown then
		fireCooldown = true;
		
		
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
		
		
		hsm:Init(bullet, { WeaponId = id })
		
		
		task.delay(0.13, function()
			fireCooldown = false;
		end)
	end
end


local SwitchTo = script.SwitchTo;


SwitchTo.Event:Connect(function()
	game.ReplicatedStorage.GameSounds.Equip:Play();
end)



return Plasmatrix;