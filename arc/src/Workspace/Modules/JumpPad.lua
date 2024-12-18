local JumpPad = {}
JumpPad.__index = JumpPad;


local baseSound = game.ReplicatedStorage.GameSounds:WaitForChild("Jumppad");
local ts = game:GetService("TweenService");


local RBXScriptSignal = require(workspace.Modules.Signal);


function JumpPad:Activate()
	self.Active = true;
end


function JumpPad:Deactivate()
	self.Active = false;
end


function JumpPad.new(padModel, configs)
	if not configs then configs = {}; end;
	
	local Strength = configs.Strength and { Value = configs.Strength } or padModel:FindFirstChild("strength");
	local Time = configs.Time and { Value = configs.Time } or padModel:FindFirstChild("time");
	local Main = configs.Main or padModel.parts.main;
	local Particles = configs.Particles or padModel.parts.particles;
	
	if not configs.Sound then configs.Sound = baseSound end;
	
	
	local self = setmetatable({
		Model = padModel,
		Main = Main,
		Strength = Strength,
		Time = Time,
		Particles = Particles,
		
		Sound = configs.Sound,
		Configs = configs,
		
		Bounced = RBXScriptSignal.new(),
		BouncedObject = RBXScriptSignal.new(),
		BouncedPlayer = RBXScriptSignal.new(),
		BouncedHuman = RBXScriptSignal.new(),
		
		Active = false
		
	}, JumpPad);
	
	
	self.Main.Touched:connect(function(hit)
		if not self.Active then return end;
		
		local isHumanoid = false;
		local isPlayer = false;
		
		
		if hit.Parent:IsA("Model") and hit.Parent:FindFirstChild("HumanoidRootPart") then
			hit = hit.Parent:WaitForChild("HumanoidRootPart")
			isHumanoid = true;
			
			if game.Players:GetPlayerFromCharacter(hit.Parent) then
				isPlayer = true;
			end
		end


		if hit:GetAttribute("JumpPadCooldown") then return end

		hit:SetAttribute("JumpPadCooldown", true)

		task.delay(self.Time.Value, function()
			hit:SetAttribute("JumpPadCooldown", nil)
		end)



		--[[local intw = ts:Create(self.Main, TweenInfo.new(0.15, Enum.EasingStyle.Bounce), {
			Size = Vector3.new(10, 3, 10)
		});

		local outtw = ts:Create(self.Main, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {
			Size = Vector3.new(10, 1, 10)
		});


		intw.Completed:Connect(function()
			outtw:Play();
		end)


		intw:Play();]]
		
		
		self.Sound:Play();


		local decay = 0
		local bodyvelocity = Instance.new("BodyVelocity")
		
		bodyvelocity.Name = "JumpPadVelocity"
		bodyvelocity.Parent = hit
		bodyvelocity.MaxForce = Vector3.new(0,math.huge,0)
		bodyvelocity.P = math.huge
		bodyvelocity.Velocity = self.Main.CFrame.UpVector * self.Strength.Value
		
		
		if isPlayer then
			self.BouncedPlayer:Fire(game.Players:GetPlayerFromCharacter(hit.Parent), hit.Parent:WaitForChild("Humanoid"), hit.Parent);
			self.BouncedHuman:Fire(hit.Parent:WaitForChild("Humanoid"), hit.Parent);	
		elseif isHumanoid then
			self.BouncedHuman:Fire(hit.Parent:WaitForChild("Humanoid"), hit.Parent);
		else
			self.BouncedObject:Fire(hit);
		end
		
		self.Bounced:Fire(hit);


		task.delay(0.1, function()
			bodyvelocity:Destroy()
		end);
	end);
	
	
	return self;
end

return JumpPad
