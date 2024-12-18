--[[
there are a lot of different configurations for the parry behavior and I'll try to list them below

behavior<String>: the behavior of the parry
- boom: explodes upon impact
- pierce: goes through enemies killing instantly
- slide: part gets launched in the direction of the camera
- guardbreak: used when parrying shields, has no flinging kinda just breaks it


parryable<Bool>: if the part is parryable, default false

radius<Number>||<Int>: explosion radius if parry behavior is on boom, default 30

rotation<Number>||<Int>: rotation added onto the y axis of the part upon parrying, default 0

velocity<Number>||<Int>: velocity multiplier for the part when parried, default 300

persist<Bool>: if the explosion should continue damaging even while fading out, default false

multihit<Bool>: if the explosion should hit continously until destroyed, default false

indiv<Number>||<Int>: the amount of time it takes for the first phase of the explosion (fading in) to finish, default 35

outdiv<Number>||<Int>: the amount of time it takes for the second phase of the explosion (fading out) to finish, default 10

damage<Number>||<Int>: the amount of damage put out, automatically calculated using radius by boom but defaults to 100 for pierce and defaults to 25 for guardbreak

healing<Number>||<Int>: the amount of healing gotten from parrying, default 15

transparency<Number>||<Int>: the transparency of the explosion

cooldown<Number>||<Int>: the cooldown for multihit, default 1

bigmult<Number>||<Int>: multiplier for the size of the explosion's outer wave

shockwave<Bool>: if there should be a shockwave, default true

color<Color3>: the color of the explosion

boostable<Bool>: if the projectile can be parried by the shooter of it

knockback<Bool>: if there should be any knockback upon exploding

kbmult<Number>||<Int>: multiplier for the knockback applied on enemies when exploded

fusetime<Number>||<Int>: time it takes for it to explode automatically if given, default nil

fireprob<Bool>: probability if the explosion should give the fire effect to victims, default 0.7

]]


--[[ FIRE PROB EQUATION

local x = 0.7

local xfix, i = tostring(x):gsub("%.", "")

local t = string.len(xfix)-i;

print(t);

local a, b = tonumber(xfix), 10^(t);

print(a, b);

print(math.random(a, b));

]]



local Exploder = {}
Exploder.__index = Exploder;
if not _G.Exploders then _G.Exploders = {} end


local Revared = require(workspace.Modules.Revared);
local global = Revared:GetModule("GlobalSide");
local RBXScriptSignal = Revared:GetModule("Signal");

local Fire = require(workspace.Modules.Fire);

local Values = require(workspace.Modules.Values);
local stamina = Values:Fetch("stamina");


local ts = game:GetService("TweenService");


local cd = game.ReplicatedStorage.GameEvents.Exploder:WaitForChild("ClientDamage");


local delayed = {};


function Exploder.get(part)
	for _,v in pairs(_G.Exploders) do
		if v.Part == part then
			return v;
		end
	end
end


function Exploder.new(player: Player, part, context, configs)
	
	local character = player.Character or player.CharacterAdded:Wait();
	if not configs then configs = {} end;
	
	
	local bulletConfig = configs.BulletConfig;
	local parryConfig = configs.ParryConfig;
	local customConfig = configs.CustomConfig;
	
	
	local self = setmetatable({
		Part = part,
		
		Player = player,
		Character = character,
		Root = character:WaitForChild("HumanoidRootPart"),
		
		Context = context,
		BulletConfig = bulletConfig,
		ParryConfig = parryConfig,
		CustomConfig = customConfig,
		
		Hit = {},
		Cooldown = {},
		
		Exploded = RBXScriptSignal.new(),
		Primed = RBXScriptSignal.new(),
		VoidedHit = RBXScriptSignal.new(),
		Destroying = RBXScriptSignal.new(),
		FadingIn = RBXScriptSignal.new(),
		FadingOut = RBXScriptSignal.new(),
		
		HitPlayer = RBXScriptSignal.new(),
		HitMidair = RBXScriptSignal.new(),
		HitHuman = RBXScriptSignal.new(),
		HitObject = RBXScriptSignal.new(),
		
		HasExploded = false,
		HasPrimed = false
		
	}, Exploder);
	
	return self;
end



function Exploder:IsCustomized(prop)
	if not self.CustomConfig then return false, self[prop] end;
	for p, c in pairs(self.CustomConfig) do
		if p == prop then
			return true, c;
		end
	end
	return false, self[prop];
end



function Exploder:Prime()
	local hitbox = self.Part:FindFirstChild("Hitbox") or self.Part;
	hitbox.Touched:Connect(function() end);
	
	self.Multihit = { Value = false }
	
	self.FuseTime = { Value = nil };

	self.Knockback = { Value = true }
	self.Kbmult = { Value = 3 }

	self.CdTime = { Value = 1 };

	self.VelMult = { Value = 300 };

	self.SetDamage = nil;
	self.FallingMult = { Value = 1 };
	
	
	if self.Context == "parry" then
		self.Multihit = self.ParryConfig:FindFirstChild("multihit") or self.Multihit;
		
		self.FuseTime = self.ParryConfig:FindFirstChild("fusetime") or self.FuseTime;

		self.Knockback = self.ParryConfig:FindFirstChild("knockback") or self.Knockback
		self.Kbmult = self.ParryConfig:FindFirstChild("kbmult") or self.Kbmult


		self.CdTime = self.ParryConfig:FindFirstChild("cooldown") or self.CdTime;

		self.VelMult = self.ParryConfig:FindFirstChild("velocity") or self.VelMult;

		self.SetDamage = self.ParryConfig:FindFirstChild("damage");
		self.FallingMult = self.ParryConfig:FindFirstChild("fallingMult") or self.FallingMult;
		
	else
	
		self.Multihit = self.BulletConfig:FindFirstChild("multihit") or self.Multihit
		
		self.FuseTime = self.BulletConfig:FindFirstChild("fusetime") or self.FuseTime;

		self.Knockback = self.BulletConfig:FindFirstChild("knockback") or self.Knockback
		self.Kbmult = self.BulletConfig:FindFirstChild("kbmult") or self.Kbmult


		self.CdTime = self.BulletConfig:FindFirstChild("cooldown") or self.CdTime;

		self.VelMult = self.BulletConfig:FindFirstChild("velocity") or self.VelMult;

		self.SetDamage = self.BulletConfig:FindFirstChild("damage");
		self.FallingMult = self.BulletConfig:FindFirstChild("fallingMult") or self.FallingMult;
	end
	
	
	if self.CustomConfig then
		self.Multihit = ({ self:IsCustomized("Multihit") })[2];
		
		self.FuseTime = ({ self:IsCustomized("FuseTime") })[2];
		
		self.Knockback = ({ self:IsCustomized("Knockback") })[2];
		self.Kbmult = ({ self:IsCustomized("Kbmult") })[2];
		
		
		self.CdTime = ({ self:IsCustomized("CdTime") })[2];
		
		self.VelMult = ({ self:IsCustomized("VelMult") })[2];
		
		self.SetDamage = ({ self:IsCustomized("SetDamage") })[2];
		self.FallingMult = ({ self:IsCustomized("FallingMult") })[2];
	end
	
	
	self.Primed:Fire();
	self.HasPrimed = true;
	
	if self.FuseTime.Value then
		print("should explode in "..self.FuseTime.Value.." seconds");
		
		task.delay(self.FuseTime.Value, function()
			if not self.HasExploded then
				print("hasn't exploded yet so it should explode")
				self:Explode()
			end
		end)
	end
	
	
	coroutine.wrap(function()
		while task.wait() do 
			if #hitbox:GetTouchingParts() > 0 then

				local voidHit = false;
				-- local voided = self.Root:FindFirstChild("voided");

				--[[self.Voided = Instance.new("BoolValue", self.Root);
				self.Voided.Name = "voided";
				self.Voided.Value = true;]]

				
				if self.Context == "parry" then
					for i, p in ipairs(hitbox:GetTouchingParts()) do
						if p == self.Root or p.Parent.Name == self.Player.Name then voidHit = true;
						elseif p.Parent.Parent.Name == "ExplodeEffect" then voidHit = true;
						elseif p:FindFirstChild("voided") and p:FindFirstChild("voided").Value == true then voidHit = true;
						elseif string.find(string.lower(p.Name), "hitbox") then voidHit = true;
						
						else
							voidHit = false
						end

						if self.Part.Parent:FindFirstChild("Humanoid") then
							local ePlayer = game.Players:GetPlayerFromCharacter(self.Part.Parent);
							if ePlayer and self.Player.UserId == ePlayer.UserId then voidHit = true; end

							for _, bp in pairs(self.Part.Parent:GetChildren()) do
								if p == bp and not voidHit then voidHit = true;
								end
							end
						end
					end
				else
					for i, p in ipairs(hitbox:GetTouchingParts()) do
						
						if p == self.Root or p.Parent.Name == self.Player.Name then voidHit = true;
						elseif p.Parent.Parent.Name == "ExplodeEffect" then voidHit = true;
						elseif p:FindFirstChild("voided") and p:FindFirstChild("voided").Value == true then voidHit = true;

						else
							voidHit = false
						end

						if self.Part.Parent:FindFirstChild("Humanoid") then
							local ePlayer = game.Players:GetPlayerFromCharacter(self.Part.Parent);
							if ePlayer and self.Player.UserId == ePlayer.UserId then voidHit = true; end

							for _, bp in pairs(self.Part.Parent:GetChildren()) do
								if p == bp and not voidHit then voidHit = true;
								end
							end
						end
					end
				end

				if not voidHit and not self.HasExploded then
					
					self:Explode()
					return;
					
				else
					self.VoidedHit:Fire();
				end
			end
		end
	end)()
end



function Exploder:Explode()
	self.Radius = { Value = 30 };
	self.Color = nil;
	self.Transparency = nil;

	self.Shockwave = { Value = true };
	self.Wavemult = { Value = 4 };
	
	self.FireProb = { Value = 1 };
	self.FireDamage = { Value = 1 };
	self.FireTick = { Value = 1 };
	self.FireTime = { Value = 5 };


	if self.Context == "parry" then
		self.Radius = self.ParryConfig:FindFirstChild("radius") or self.Radius;
		self.Color = self.ParryConfig:FindFirstChild("color");
		self.Transparency = self.ParryConfig:FindFirstChild("transparency");

		self.Shockwave = self.ParryConfig:FindFirstChild("shockwave") or self.Shockwave;
		self.Wavemult = self.ParryConfig:FindFirstChild("wavemult") or self.Wavemult;
		
		self.FireProb = self.ParryConfig:FindFirstChild("fireprob") or self.FireProb;
		self.FireDamage = self.ParryConfig:FindFirstChild("firedamage") or self.FireDamage;
		self.FireTick = self.ParryConfig:FindFirstChild("firetick") or self.FireTick;
		self.FireTime = self.ParryConfig:FindFirstChild("firetime") or self.FireTime;
	else
		self.Radius = self.BulletConfig:FindFirstChild("radius") or self.Radius;
		self.Color = self.BulletConfig:FindFirstChild("color");
		self.Transparency = self.BulletConfig:FindFirstChild("transparency");

		self.Shockwave = self.BulletConfig:FindFirstChild("shockwave") or self.Shockwave;
		self.Wavemult = self.BulletConfig:FindFirstChild("wavemult") or self.Wavemult;
		
		self.FireProb = self.BulletConfig:FindFirstChild("fireprob") or self.FireProb;
		self.FireDamage = self.BulletConfig:FindFirstChild("firedamage") or self.FireDamage;
		self.FireTick = self.BulletConfig:FindFirstChild("firetick") or self.FireTick;
		self.FireTime = self.BulletConfig:FindFirstChild("firetime") or self.FireTime;
	end
	
	if self.CustomConfig then
		self.Radius = ({ self:IsCustomized("Radius") })[2];
		self.Color = ({ self:IsCustomized("Color") })[2];
		self.Transparency = ({ self:IsCustomized("Transparency") })[2];
		
		self.Shockwave = ({ self:IsCustomized("Shockwave") })[2];
		self.Wavemult = ({ self:IsCustomized("Wavemult") })[2];
		
		self.FireProb = ({ self:IsCustomized("FireProb") })[2];
		self.FireDamage = ({ self:IsCustomized("FireDamage") })[2];
		self.FireTick = ({ self:IsCustomized("FireTick") })[2];
		self.FireTime = ({ self:IsCustomized("FireTime") })[2];
	end


	local function GetModel()
		for _, model in pairs(workspace.Explosions:GetChildren()) do
			if model.Name == "ExplodeEffect" and model:WaitForChild("Adornee").Value == self.Part then
				return model;
			end
		end

		return game.ReplicatedStorage:WaitForChild("Particles").ExplodeEffect:Clone();
	end


	local explModel = GetModel();

	if not self.Shockwave.Value then
		explModel.Parts.shockwave:Destroy();
	end

	explModel.Parent = workspace.Explosions;
	explModel.Adornee.Value = self.Part;

	local sounds = game.ReplicatedStorage.GameSounds.Exploder:GetChildren();

	local sound = sounds[math.random(1, #sounds)];

	local baseVolume = sound.Volume;
	local baseSpeed = sound.PlaybackSpeed;

	sound.Volume = self.Radius.Value/75
	sound.PlaybackSpeed = 25 / self.Radius.Value;
	sound.RollOffMinDistance = self.Radius.Value;

	local s = sound:Clone();
	s.Parent = explModel.Parts.big;

	s.Ended:Connect(function()
		sound.Volume = baseVolume;
		s:Destroy();
	end)

	s:Play();


	local boomMsg = game.ReplicatedStorage.GameEvents.Exploder:WaitForChild("BoomMessage");
	boomMsg:FireAllClients(self.Part, self.Radius.Value);


	local lights = {};
	self.Hittable = true;


	for _, light in pairs(explModel.Parts.big:GetChildren()) do
		if light:IsA("PointLight") or light:IsA("SurfaceLight") then
			lights[#lights+1] = light;

			if self.Color then
				print(self.Color.Value);
				
				light.Color = self.Color.Value;
			end

			light.Range = 0
			light.Brightness = 0
		end
	end

	for _, light in pairs(explModel.Parts.small:GetChildren()) do
		if light:IsA("PointLight") or light:IsA("SurfaceLight") then
			lights[#lights+1] = light;

			if self.Color then
				light.Color = self.Color.Value;
			end

			light.Range = 0
			light.Brightness = 0
		end
	end

	for _, light in pairs(lights) do
		(ts:Create(light, TweenInfo.new(self.Radius.Value/50, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Range = self.Radius.Value/5,
			Brightness = self.Radius.Value/10
		})):Play()
	end

	for _, union in pairs(explModel.Parts:GetChildren()) do
		union.Size = Vector3.new(0, 0, 0)
		union.Position = self.Part.Position;



		self.Indiv = { Value = 35 };
		self.Outdiv = { Value = 10 };
		self.Persist = { Value = false };
		self.Bigmult = { Value = 1.5 };


		if self.Context == "parry" then
			self.Indiv = self.ParryConfig:FindFirstChild("indiv") or self.Indiv;
			self.Outdiv = self.ParryConfig:FindFirstChild("outdiv") or self.Outdiv;
			self.Persist = self.ParryConfig:FindFirstChild("persist") or self.Persist;
			self.Bigmult = self.ParryConfig:FindFirstChild("bigmult") or self.Bigmult;
		else
			self.Indiv = self.BulletConfig:FindFirstChild("indiv") or self.Indiv;
			self.Outdiv = self.BulletConfig:FindFirstChild("outdiv") or self.Outdiv;
			self.Persist = self.BulletConfig:FindFirstChild("persist") or self.Persist;
			self.Bigmult = self.BulletConfig:FindFirstChild("bigmult") or self.Bigmult;
		end
		
		if self.CustomConfig then
			self.Indiv = ({ self:IsCustomized("Indiv") })[2];
			self.Outdiv = ({ self:IsCustomized("Outdiv") })[2];
			self.Persist = ({ self:IsCustomized("Persist") })[2];
			self.Bigmult = ({ self:IsCustomized("Bigmult") })[2];
		end



		local s = Vector3.new(self.Radius.Value, self.Radius.Value, self.Radius.Value);
		local t = self.Radius.Value/self.Indiv.Value;
		local r = Vector3.new(math.random(0, 360), math.random(0, 360), math.random(0, 360))



		if union.Name == "big" then

			s = Vector3.new(self.Radius.Value*self.Bigmult.Value, self.Radius.Value*self.Bigmult.Value, self.Radius.Value*self.Bigmult.Value);
			t = self.Radius.Value/(self.Indiv.Value*0.7142857143);

		elseif union.Name == "shockwave" then
			s = Vector3.new(0.7*(self.Radius.Value*self.Wavemult.Value), union.Size.Y*(self.Radius.Value/50), 0.7*(self.Radius.Value*self.Wavemult.Value));
			t = self.Radius.Value/(self.Indiv.Value/2);
			r = Vector3.new(0, 0, 0)
		end



		local tween1 = ts:Create(union, TweenInfo.new(t, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = s,
			Rotation = r,
		});



		for _, texture in pairs(union:GetChildren()) do
			if texture:IsA("Decal") or texture:IsA("Texture") then
				if self.Color then
					texture.Color3 = self.Color.Value;
				end

				if self.Transparency then
					texture.Transparency = self.Transparency.Value;
				end

				local t = self.Radius.Value/(self.Outdiv.Value*1.5);

				local textureTween = ts:Create(texture, TweenInfo.new(t, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Transparency = 1
				});

				textureTween.Completed:Connect(function()
					self.Destroying:Fire(explModel);
					union:Destroy();
					explModel:Destroy();
					-- self.Voided:Destroy();
				end)

				textureTween:Play();
			end
		end



		tween1.Completed:Connect(function()

			local r = Vector3.new(math.random(0, 360), math.random(0, 360), math.random(0, 360));

			local t = self.Radius.Value/(self.Outdiv.Value);
			local lt = self.Radius.Value/(self.Outdiv.Value*5);

			if union.Name == "shockwave" then
				r = Vector3.new(0, 0, 0)
				t = self.Radius.Value/(self.Outdiv.Value/2);
			end

			local tween2 = ts:Create(union, TweenInfo.new(t, Enum.EasingStyle.Cubic), {
				Size = Vector3.new(0, 0, 0),
				Rotation = r,
			});

			for _, light in pairs(lights) do
				(ts:Create(light, TweenInfo.new(lt, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Range = 0,
					Brightness = 0
				})):Play()
			end

			tween2.Completed:Connect(function()
				self.Destroying:Fire(explModel);
				explModel:Destroy();
				-- self.Voided:Destroy();
			end)

			tween2:Play();
			self.FadingOut:Fire(explModel);

			if not self.Persist.Value then
				self.Hittable = false;
			end
		end)
		
		
		tween1:Play();
		self.FadingIn:Fire(explModel);
	end

	if self.Part.Parent:FindFirstChild("Humanoid") then
		local eHuman = self.Part.Parent:FindFirstChild("Humanoid");
		eHuman.Health = 0;
	end


	self.Exploded:Fire(self.Part, explModel);
	self.HasExploded = true;
	self.Part:Destroy();


	local hb = explModel.Parts.hitbox;
	hb.Touched:Connect(function() end);

	local wrapped = coroutine.wrap(function()
		while self.Hittable do

			for _, part in pairs(hb:GetTouchingParts()) do
				if part.Parent and part.Parent:FindFirstChild("Humanoid") and self.Hittable and not self:OnCooldown(part.Parent) then

					local eHuman = part.Parent:FindFirstChild("Humanoid");
					local eChar = part.Parent;
					local voidHit = false;

					local ePlayer = game.Players:GetPlayerFromCharacter(eChar);

					local distance = (part.Position - hb.Position).magnitude

					--if (part == self.Root or part.Parent.Name == self.Player.Name) and distance <= 1 then voidHit = true;
					-- elseif part:FindFirstChild("voided") and part:FindFirstChild("voided").Value == true then voidHit = true;
					--end


					if eHuman and not voidHit and not self:HasHit(eChar) and not self:OnCooldown(eChar) then
						local iframed = self:IsIFramed(ePlayer);

						if not iframed then

							local i = #self.Cooldown+1;
							self.Cooldown[i] = part;

							eHuman.Died:Connect(function()
								if self:OnCooldown(eChar) then
									local _, i = self:OnCooldown(eChar);
									table.remove(self.Cooldown, i);	
								end

								if self:HasHit(eChar) then
									local _, i = self:HasHit(eChar);
									table.remove(self.Hit, i);
								end


								if self:OnDelay(eChar) then
									local _, i = self:OnDelay(eChar);
									table.remove(delayed, i);
								end
							end)


							local damage = self.SetDamage and self.SetDamage.Value or self.Radius.Value-(math.abs(distance));

							self.Hit[#self.Hit+1] = eChar;

							if self.Knockback.Value then
								if self.Context == "bullet" then
									part.AssemblyLinearVelocity += CFrame.lookAt(hb.Position, part.Position).LookVector*(self.Radius.Value*self.Kbmult.Value)*1.5
								else
									part.AssemblyLinearVelocity += CFrame.lookAt(hb.Position, part.Position).LookVector*(self.Radius.Value*self.Kbmult.Value)
								end
								
								if ePlayer and ePlayer.UserId == self.Player.UserId then
									part.AssemblyLinearVelocity *= Vector3.new(1, 1.35, 1);
								else
									part.AssemblyLinearVelocity *= Vector3.new(1, 1.2, 1);
								end
								
								if eHuman:GetState() == Enum.HumanoidStateType.Freefall then
									part.AssemblyLinearVelocity *= Vector3.new(1, 1.5, 1);
									damage *= self.FallingMult.Value;
								end
							end

							local fire = Fire.new(self.Player);

							cd:FireClient(self.Player, eHuman, damage, self.Knockback.Value, part, part.AssemblyLinearVelocity);

							fire:ChanceIgnitePlayer(eHuman, self.FireProb.Value, self.FireTime.Value, self.FireTick.Value, self.FireDamage.Value);
						end
					end

				elseif part.Parent and part.Parent:FindFirstChild("Humanoid") and self:OnCooldown(part.Parent) and not self:OnDelay(part.Parent) then
					local eChar = part.Parent;
					local eHuman = eChar:FindFirstChild("Humanoid");

					delayed[#delayed+1] = eChar;

					task.delay(self.CdTime.Value, function()
						local _, i = self:OnCooldown(eChar);
						table.remove(self.Cooldown, i)
						table.remove(delayed, i);
					end);

				end
			end

			if explModel:FindFirstChild("Parts") then
				for _, union in pairs(explModel:FindFirstChild("Parts"):GetChildren()) do
					for _, texture in pairs(union:GetChildren()) do
						if texture:IsA("Decal") or texture:IsA("Texture") then
							if texture.Transparency >= 0.98 then self.Hittable = false; end
						end
					end
				end
			end

			task.wait()
		end
	end)()
end



function Exploder:HasHit(eChar)
	if self.Multihit.Value then return false end
	for i, ec in ipairs(self.Hit) do
		if ec == eChar then return true, i; end
	end

	return false;
end



function Exploder:OnCooldown(eChar)
	if not self.Multihit.Value then return false end;
	for i, ec in ipairs(self.Cooldown) do
		if ec == eChar then return true, i; end
	end

	return false;
end



function Exploder:OnDelay(eChar)
	if not self.Multihit.Value then return false end;
	for i, ec in ipairs(delayed) do
		if ec == eChar then return true, i; end
	end

	return false;
end



function Exploder:IsIFramed(ePlayer)
	if ePlayer then

		--[[local ifrmEvent = game.ReplicatedStorage.GameEvents.Exploder:WaitForChild("IFramed")

		ifrmEvent:FireClient(ePlayer);

		local resPlayer, resIFramed = ifrmEvent.OnServerEvent:Wait();

		if resPlayer == ePlayer then
			return resIFramed;
		end]]
		
		return ePlayer.iframed.value;
	end

	return false;
end



return Exploder