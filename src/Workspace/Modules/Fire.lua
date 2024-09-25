math.randomseed(os.time())
math.random(); math.random(); math.random()


local Revared = require(workspace.Modules.Revared);
local global = Revared:GetModule("GlobalSide");
local RBXScriptSignal = Revared:GetModule("Signal");

local Values = require(workspace.Modules.Values);
local stamina = Values:Fetch("stamina");


local ts = game:GetService("TweenService");

local cd = game.ReplicatedStorage.GameEvents.Fire:WaitForChild("ClientDamage");
local give = game.ReplicatedStorage.GameEvents.Fire:WaitForChild("GiveFireEffect");

local delayed = {};



local Fire = {}
Fire.__index = Fire;



function Fire.new(player, config)
	if not config then config = {} end;

	local self = setmetatable({
		Player = player,

		Cooldown = false,

		Ignited = RBXScriptSignal.new(),
		IgnitedPlayer = RBXScriptSignal.new(),
		VoidedHit = RBXScriptSignal.new(),
		Destroying = RBXScriptSignal.new(),
		PutOut = RBXScriptSignal.new(),
		PutOutPlayer = RBXScriptSignal.new(),

		HasIgnited = false,
		HasIgnitedPlayer = false,
		HasBeenPutOut = false,
		HasPlayerBeenPutOut = false

	}, Fire);

	return self;
end



function Fire:Prob(x)
	if x == 0 then return false end;
	
	local xfix, i = tostring(x):gsub("%.", "")

	local t = i > 0 and string.len(xfix)-i or 0;

	local a, b = tonumber(xfix), 10^(t);
	
	local r =  math.random(a, b);
	
	-- print(a, b, r, r == 10^(t));

	return r == 10^(t);
end



function Fire:ChanceIgnitePlayer(player, chance, ftime, ftick, damage)
	if self:Prob(chance) then
		self:IgnitePlayer(player, ftime, ftick, damage);
	end;
end



function Fire:IgnitePlayer(victim, ftime, ftick, damage)
	local character = nil;
	local humanoid = nil;
	local root = nil;
	
	
	if victim:IsA("Player") then
		character = victim.Character or victim.CharacterAdded:Wait();
		humanoid = character:WaitForChild("Humanoid");
		root = character:FindFirstChild("HumanoidRootPart");
		
	elseif victim:IsA("Humanoid") then
		character = victim.Parent;
		humanoid = victim;
		root = character:WaitForChild("HumanoidRootPart");
		victim = game.Players:FindFirstChild(character.Name);
		
	elseif victim:IsA("Model") then
		character = victim;
		humanoid = character:WaitForChild("Humanoid");
		root = character:WaitForChild("HumanoidRootPart");
		victim = game.Players:FindFirstChild(character.Name);
	end
	
	
	self.Victim = victim;
	self.VictimCharacter = character;
	self.VictimHuman = humanoid;
	self.VictimRoot = root;
	

	local function GetModel()
		local m = root:FindFirstChild("FireEffect") or game.ReplicatedStorage:WaitForChild("Particles").FireEffect:Clone();
		m.Parent = self.VictimRoot;
		m.Adornee.Value = self.VictimRoot;
		m.Transparency = 1;
			
		m.Anchored = false;
		local weld = m:FindFirstChild("RootWeld");
		
		if weld then
			weld.Part0 = self.VictimRoot;
		end
		
		return m;
	end


	local fireModel = GetModel();

	local sounds = game.ReplicatedStorage.GameSounds.Fire:GetChildren();


	self.Ignited:Fire(character, fireModel);
	self.IgnitedPlayer:Fire(character, fireModel);
	
	self.HasIgnited = true;
	self.HasIgnitedPlayer = true;

	local hittable = true;
	
	
	task.delay(ftime, function()
		self.Destroying:Fire(fireModel);
		self.PutOut:Fire(self.VictimCharacter, fireModel);
		self.PutOutPlayer:Fire(self.VictimCharacter, fireModel);
		
		self.HasBeenPutOut = true;
		self.HasPlayerBeenPutOut = true;
		
		hittable = false;
		
		fireModel:Destroy();
		
		if victim then
			victim:WaitForChild("lit").Value = false;
		end
	end)
	
	
	local lit = { Value = false };
	
	if victim then
		lit = victim:WaitForChild("lit");
		give:FireClient(self.Victim, ftime, lit.Value);
	end
	
	
	if victim then
		victim:WaitForChild("lit").Value = true;
	end


	coroutine.wrap(function()
		while hittable do
			if hittable then
				fireModel = GetModel();

			--[[local effect = fireModel:WaitForChild("Fire");

			if not self.VictimRoot then
				return;
			end
			
			print(self.VictimRoot.Velocity);

			local x = self.VictimRoot.Velocity.X == 0 and 1 or -self.VictimRoot.Velocity.X/2;
			local z = self.VictimRoot.Velocity.Z == 0 and 1 or -self.VictimRoot.Velocity.Z/2;

			effect.Acceleration = Vector3.new(x, 2, z);

			print(effect.Acceleration);]]
			end

			if hittable and not self.Cooldown then

				self.Cooldown = true;

				self.VictimHuman.Died:Connect(function()
					if self.Cooldown then
						self.Cooldown = false;
					end

					if self:OnDelay(self.VictimRoot) then
						local _, i = self:OnDelay(self.VictimCharacter);
						table.remove(delayed, i);
					end

					self.Destroying:Fire(fireModel);
					self.PutOut:Fire(self.VictimCharacter, fireModel);
					self.PutOutPlayer:Fire(self.VictimCharacter, fireModel);

					self.HasBeenPutOut = true;
					self.HasPlayerBeenPutOut = true;

					hittable = false;

					fireModel:Destroy();
				end)

				if damage < 0 then
					damage = 0;
				end

				-- print('tick');

				cd:FireClient(self.Player, self.VictimHuman, damage);

			elseif self.Cooldown and not self:OnDelay(self.VictimCharacter) then
				delayed[#delayed+1] = self.VictimCharacter;

				task.delay(ftick, function()
					self.Cooldown = false;

					local _, i = self:OnDelay(self.VictimCharacter);
					table.remove(delayed, i);
				end);
			end

			task.wait()
		end
	end)()
end



function Fire:OnDelay(eChar)
	for i, ec in ipairs(delayed) do
		if ec == eChar then return true, i; end
	end

	return false;
end


return Fire