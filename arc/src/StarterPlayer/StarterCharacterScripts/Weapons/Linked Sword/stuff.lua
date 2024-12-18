local Values = require(workspace.Modules.Values);
local player = game.Players.LocalPlayer;
local loaded = player.loaded;

local LinkedSword = {};

local id = script.Parent.id.Value;

local character = player.Character or player.CharacterAdded:Wait();

local hrp = character:WaitForChild("HumanoidRootPart");
local humanoid = character:WaitForChild("Humanoid");


local Values = require(workspace.Modules.Values);
local stamina = Values:Fetch("stamina");


local wm = require(script.Parent.Parent.Parent.Modules.WeaponModule);
local pm = require(script.Parent.Parent.Parent.Modules.ProjectileModule);
local model = wm:GetWeaponModelFromId(id);


local TweenService = game:GetService("TweenService");

local fireCooldown = false;

local sounds = game.ReplicatedStorage.GameSounds.LinkedSword;


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


function LinkedSword:Fire()
	if not cooldown then
		print("fire")
		
		local ddisplay = hrp:WaitForChild("DeflectDisplay");
		local deflect = ddisplay:WaitForChild("DeflectEmitter");
		
		local damaged = {};

		model = wm:GetWeaponModelFromId(id);

		sounds.SwordSlash:Play();
		SlashAnim:AdjustSpeed(0.5);
		SlashAnim:Play()
		
		local swingHb = Instance.new("Part", hrp)
		swingHb.Archivable = true;
		swingHb.Name = "SwingéHitbox";
		swingHb.Size = Vector3.new(5, 4, 5)
		swingHb.CanCollide = false;
		swingHb.Massless = true;
		swingHb.Transparency = 0.5
		swingHb.Color = Color3.fromRGB(217, 0, 0)
		swingHb.Material = 'Neon'

		local weld = Instance.new("Weld", swingHb)
		weld.Name = "TheWeldingness";
		weld.Part0 = hrp;
		weld.Part1 = swingHb;
		weld.C1 = CFrame.new(-0.000244140625, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1)


		local deflectHb = swingHb:Clone();
		deflectHb.Parent = hrp;
		deflectHb.Name = "DeflectHitbox"
		deflectHb.Size = Vector3.new(8, 15, 10);
		deflectHb.TheWeldingness.C1 = CFrame.new(-0.000244140625, -1, 3, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		
		
		swingHb.Touched:Connect(function(v)
			local eChar = v.Parent

			if eChar ~= character and eChar:FindFirstChild("Humanoid") and not damaged[eChar.Name] then
				local eHuman = eChar.Humanoid;

				damaged[eChar.Name] = true;

				GlobalDamage:Inflict(eHuman, 10);

				swingHb:Destroy();
				swingHb:Destroy();

				cooldown = true;

				wait(0.1);

				sounds.SwordImpact:Play();
			end
		end)


		deflectHb.Touched:Connect(function() end)


		for i, part in ipairs(deflectHb:GetTouchingParts()) do
			
			if part:FindFirstChild("ParryConfig") and part.ParryConfig:FindFirstChild("parryable") and part.ParryConfig:FindFirstChild("parryable").Value then

				local parryLabelAnimIn = TweenService:Create(deflect.ImageLabel, TweenInfo.new(tweenTime), {
					Rotation = math.random(10, 360),
					ImageTransparency = 0.5
				});
				local parryAnimIn = TweenService:Create(deflect, TweenInfo.new(tweenTime), {
					Size = UDim2.new(10, 0, 10, 0)
				});
				local parryLabelAnimOut = TweenService:Create(deflect.ImageLabel, TweenInfo.new(tweenTime), {
					Rotation = 0,
					ImageTransparency = 1
				});
				local parryAnimOut = TweenService:Create(deflect, TweenInfo.new(tweenTime), {
					Size = UDim2.new(0, 0, 0, 0)
				});

				-- PunchAnim:AdjustSpeed(2);

				task.wait(0.1)

				-- lighting.DeflectEffect.Enabled = true;

				-- PunchAnim:AdjustSpeed(0);

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
				local behavior = part:WaitForChild("ParryConfig"):FindFirstChild("behavior") or { Value = "boom" };
				local radius = part:WaitForChild("ParryConfig"):FindFirstChild("radius") or { Value = 30 };
				local healing = part:WaitForChild("ParryConfig"):FindFirstChild("healing") or { Value = 0 };

				parryAnimIn.Completed:Connect(function()

					task.wait(0.01);

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
					-- lighting.DeflectEffect.Enabled = false;

					if behavior.Value == "guardbreak" then
						-- Guardbreak:Play()
					elseif behavior.Value == "pierce" then
						-- Pierce:Play();
					else

						sounds.SwordLunge:Play();
					end


					SlashAnim:AdjustSpeed(0.6);

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
					
					pm:Deflect(part);

					-- DeflectAnim:Play();
				end)

				deflect.Enabled = true;

				sounds.SwordDeflect:Play();
				cooldown = true;

				parryLabelAnimIn:Play();
				parryAnimIn:Play();

				wait(0.7)

				script.Parent.swinging.Value = false;
				deflect.Enabled = false;
				SlashAnim:AdjustSpeed(0.5);
				damaged = {};

				swingHb:Destroy();
				deflectHb:Destroy();

				wait(0.5);

				cooldown = false;

				return;
			end
		end

		cooldown = true
		
		wait(0.3)

		script.Parent.swinging.Value = false;
		damaged = {};

		swingHb:Destroy();
		deflectHb:Destroy();

		wait(0.5);

		cooldown = false;
	end
end


local SwitchTo = script.SwitchTo;


SwitchTo.Event:Connect(function()
	sounds.Unsheath:Play();
	game.ReplicatedStorage.GameSounds.Equip:Play();
end)



return LinkedSword;