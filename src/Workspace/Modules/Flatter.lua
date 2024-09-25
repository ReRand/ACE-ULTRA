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



local Flatter = {}
Flatter.__index = Flatter;
if not _G.Flatters then _G.Flatters = {} end


local Revared = require(workspace.Modules.Revared);
local global = Revared:GetModule("GlobalSide");
local RBXScriptSignal = Revared:GetModule("Signal");

local Fire = require(workspace.Modules.Fire);

local Values = require(workspace.Modules.Values);
local stamina = Values:Fetch("stamina");


local ts = game:GetService("TweenService");


local cd = game.ReplicatedStorage.GameEvents.Flatter:WaitForChild("ClientDamage");


local delayed = {};


function Flatter.get(part)
	for _,v in pairs(_G.Flatters) do
		if v.Part == part then
			return v;
		end
	end
end


function Flatter.new(player: Player, part, context, configs)
	
	local character = player.Character or player.CharacterAdded:Wait();
	if not configs then configs = {} end;
	
	
	local bulletConfig = configs.BulletConfig;
	local parryConfig = configs.ParryConfig;
	local customConfig = configs.CustomConfig;
	local headshot = configs.Headshot;
	
	
	local self = setmetatable({
		Part = part,
		
		Player = player,
		Character = character,
		Root = character:WaitForChild("HumanoidRootPart"),
		
		Context = context,
		BulletConfig = bulletConfig,
		ParryConfig = parryConfig,
		CustomConfig = customConfig,
		Headshot = headshot,
		
		Hit = {},
		Cooldown = {},
		
		Primed = RBXScriptSignal.new(),
		
		HitPlayer = RBXScriptSignal.new(),
		HitHeadshot = RBXScriptSignal.new(),
		HitMidair = RBXScriptSignal.new(),
		HitHuman = RBXScriptSignal.new(),
		HitObject = RBXScriptSignal.new(),
		
		VoidedHit = RBXScriptSignal.new(),
		Destroying = RBXScriptSignal.new(),
		
	}, Flatter);
	
	return self;
end



function Flatter:IsCustomized(prop)
	if not self.CustomConfig then return false, self[prop] end;
	for p, c in pairs(self.CustomConfig) do
		if p == prop then
			return true, c;
		end
	end
	return false, self[prop];
end



function Flatter:Prime()
	local hitbox = self.Part:FindFirstChild("Hitbox") or self.Part;
	hitbox.Touched:Connect(function() end);
	
	self.Multihit = { Value = false }

	self.Knockback = { Value = false }
	self.Kbmult = { Value = 3 }

	self.CdTime = { Value = 0.1 };

	self.SetDamage = { Value = 5 };
	self.FallingMult = { Value = 1 };
	
	self.FireProb = { Value = 0 };
	self.FireDamage = { Value = 1 };
	self.FireTick = { Value = 1 };
	self.FireTime = { Value = 5 };
	
	self.HeadshotMult = { Value = 2 };


	if self.Context == "parry" then
		self.Multihit = self.ParryConfig:FindFirstChild("multihit") or self.Multihit;

		self.Knockback = self.ParryConfig:FindFirstChild("knockback") or self.Knockback
		self.Kbmult = self.ParryConfig:FindFirstChild("kbmult") or self.Kbmult

		self.CdTime = self.ParryConfig:FindFirstChild("cooldown") or self.CdTime;

		self.SetDamage = self.ParryConfig:FindFirstChild("damage") or self.SetDamage;
		self.FallingMult = self.ParryConfig:FindFirstChild("fallingMult") or self.FallingMult;
		
		self.FireProb = self.ParryConfig:FindFirstChild("fireprob") or self.FireProb;
		self.FireDamage = self.ParryConfig:FindFirstChild("firedamage") or self.FireDamage;
		self.FireTick = self.ParryConfig:FindFirstChild("firetick") or self.FireTick;
		self.FireTime = self.ParryConfig:FindFirstChild("firetime") or self.FireTime;
		
		self.HeadshotMult = self.ParryConfig:FindFirstChild("headshotMult") or self.HeadshotMult;

	else

		self.Multihit = self.BulletConfig:FindFirstChild("multihit") or self.Multihit

		self.Knockback = self.BulletConfig:FindFirstChild("knockback") or self.Knockback
		self.Kbmult = self.BulletConfig:FindFirstChild("kbmult") or self.Kbmult

		self.CdTime = self.BulletConfig:FindFirstChild("cooldown") or self.CdTime;

		self.SetDamage = self.BulletConfig:FindFirstChild("damage") or self.SetDamage;
		self.FallingMult = self.BulletConfig:FindFirstChild("fallingMult") or self.FallingMult;
		
		self.FireProb = self.BulletConfig:FindFirstChild("fireprob") or self.FireProb;
		self.FireDamage = self.BulletConfig:FindFirstChild("firedamage") or self.FireDamage;
		self.FireTick = self.BulletConfig:FindFirstChild("firetick") or self.FireTick;
		self.FireTime = self.BulletConfig:FindFirstChild("firetime") or self.FireTime;
		
		self.HeadshotMult = self.BulletConfig:FindFirstChild("headshotMult") or self.HeadshotMult;
	end


	if self.CustomConfig then
		self.Multihit = ({ self:IsCustomized("Multihit") })[2];

		self.Knockback = ({ self:IsCustomized("Knockback") })[2];
		self.Kbmult = ({ self:IsCustomized("Kbmult") })[2];

		self.CdTime = ({ self:IsCustomized("CdTime") })[2];

		self.SetDamage = ({ self:IsCustomized("SetDamage") })[2];
		self.FallingMult = ({ self:IsCustomized("FallingMult") })[2];
		
		self.FireProb = ({ self:IsCustomized("FireProb") })[2];
		self.FireDamage = ({ self:IsCustomized("FireDamage") })[2];
		self.FireTick = ({ self:IsCustomized("FireTick") })[2];
		self.FireTime = ({ self:IsCustomized("FireTime") })[2];
		
		self.HeadshotMult = ({ self:IsCustomized("HeadshotMult") })[2];
	end


	self.Primed:Fire();
	self.HasPrimed = true;
	
	
	self.Hittable = true;

	coroutine.wrap(function()
		while self.Hittable do 

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
								if p == bp and not voidHit then voidHit = true; end
							end
						end
					end
				end


				for i, p in ipairs(hitbox:GetTouchingParts()) do
					
					local eChar = p.Parent;
					
					local isHuman = false
					if eChar and eChar:FindFirstChild("Humanoid") then isHuman = true; end;
					
					local checker = isHuman and eChar or p;
					
					
					if not voidHit and self.Hittable and not self:OnCooldown(checker) then

						if self.Part.Parent and self.Part.Parent:FindFirstChild("Humanoid") then
							local eHuman = self.Part.Parent:FindFirstChild("Humanoid");
							eHuman.Health = 0;
						end


						local character = p.Parent;


						if character and character:FindFirstChild("Humanoid") then
							local eHuman = character:WaitForChild("Humanoid");

							local ePlayer = game.Players:GetPlayerFromCharacter(character);


							local iframed = self:IsIFramed(ePlayer);

							if not iframed then

								local i = #self.Cooldown+1;
								self.Cooldown[i] = p;

								eHuman.Died:Connect(function()
									if self:OnCooldown(checker) then
										local _, i = self:OnCooldown(checker);
										table.remove(self.Cooldown, i);	
									end

									if self:HasHit(checker) then
										local _, i = self:HasHit(checker);
										table.remove(self.Hit, i);
									end


									if self:OnDelay(checker) then
										local _, i = self:OnDelay(checker);
										table.remove(delayed, i);
									end
								end)


								self.Hit[#self.Hit+1] = checker;
								
								local damage = self.SetDamage.Value;
								local ace = false;
								
								
								if self.Knockback.Value then
									p.AssemblyLinearVelocity += CFrame.lookAt(self.Part.Position, p.Position).LookVector*(self.Kbmult.Value)
									p.AssemblyLinearVelocity *= Vector3.new(1, 1.1, 1);	
								end
								
								
								if eHuman:GetState() == Enum.HumanoidStateType.Freefall then
									self.Midair = true;
									
									if self.Knockback.Value then
										p.AssemblyLinearVelocity *= Vector3.new(1, 1.3, 1);
									end
								end
								

								local fire = Fire.new(self.Player);


								if self.Headshot then
									ace = "ace";
									damage *= self.HeadshotMult.Value;
								end
								
								
								if self.Midair then
									ace = "ace";
									damage *= self.FallingMult.Value;
								end


								cd:FireClient(self.Player, eHuman, damage, ace, self.Knockback.Value, p, p.AssemblyLinearVelocity);


								fire:ChanceIgnitePlayer(eHuman, self.FireProb.Value, self.FireTime.Value, self.FireTick.Value, self.FireDamage.Value);


								if self.Headshot then
									self.HitHeadshot:Fire(eHuman, damage, ace, self.Knockback.Value, p, p.AssemblyLinearVelocity);
								end

								self.HitHuman:Fire(eHuman, damage, ace, self.Knockback.Value, p, p.AssemblyLinearVelocity);

								if ePlayer then
									self.HitPlayer:Fire(ePlayer, eHuman, damage, ace, self.Knockback.Value, p, p.AssemblyLinearVelocity);
								end
							end

							return;

						elseif not character or not character:FindFirstChild("Humanoid") then
							self.HitObject:Fire(checker);
						end


					elseif not voidHit and self.Hittable and self:OnCooldown(checker) and not self:OnDelay(checker) then
						local eHuman = p.Parent:FindFirstChild("Humanoid");

						delayed[#delayed+1] = checker;

						task.delay(self.CdTime.Value, function()
							local _, i = self:OnCooldown(checker);
							table.remove(self.Cooldown, i)
							table.remove(delayed, i);
						end);


					elseif voidHit then
						self.VoidedHit:Fire();
					end
				end
			end

			task.wait();
		end
	end)()
end



function Flatter:HasHit(part)
	if self.Multihit.Value then return false end
	for i, p in ipairs(self.Hit) do
		if p == part then return true, i; end
	end

	return false;
end



function Flatter:OnCooldown(part)
	if not self.Multihit.Value then return false end;
	for i, p in ipairs(self.Cooldown) do
		if p == part then return true, i; end
	end

	return false;
end



function Flatter:OnDelay(part)
	if not self.Multihit.Value then return false end;
	for i, p in ipairs(delayed) do
		if p == part then return true, i; end
	end

	return false;
end



function Flatter:IsIFramed(ePlayer)
	if ePlayer then

		--[[local ifrmEvent = game.ReplicatedStorage.GameEvents.Flatter:WaitForChild("IFramed")

		ifrmEvent:FireClient(ePlayer);

		local resPlayer, resIFramed = ifrmEvent.OnServerEvent:Wait();

		if resPlayer == ePlayer then
			return resIFramed;
		end]]
		
		return ePlayer.iframed.value;
	end

	return false;
end



return Flatter