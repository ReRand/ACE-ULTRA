local Effect = {};
Effect.__index = Effect;


local player = game:GetService("Players").LocalPlayer;

local RBXScriptSignal = require(workspace.Modules.Signal);
local Revared = require(workspace.Modules.Revared);

local gui = player.PlayerGui:WaitForChild("CoolGui"):WaitForChild("Left"):WaitForChild("EffectsGui");
local list = gui:WaitForChild("Effectlist"):WaitForChild("Effects");
local base = gui:WaitForChild("BaseEffect");


local rs = game:GetService("RunService");
local ts = game:GetService("TweenService");
local oldElapsed = 0



function Effect.new(config)
	if not config then config = {}; end
	local effect = nil;
	
	local createNew = true
	
	local items = gui:WaitForChild("Effectlist"):WaitForChild("Effects"):WaitForChild("items");
	
	
	local self = setmetatable({
		Name = config.Name,
		InstNum = 1,
		Time = config.Time,

		TimerStep = RBXScriptSignal.new(),
		TimerDone = RBXScriptSignal.new(),
		Entered = RBXScriptSignal.new(),
		Left = RBXScriptSignal.new(),

	}, Effect);
	
	
	self.Name = config.Name..self.InstNum;


	if config.WriteOver then
		effect = items:FindFirstChild(self.Name);
		
		if not effect then
			effect = base:Clone();
			effect.Parent = items;
			
			self.Effect = effect;
			createNew = true;
		else
			createNew = false;
		end
		
	else
		effect = base:Clone();
		effect.Parent = items;
		
		self.Effect = effect;
		createNew = true;

		for _, e in pairs(items:GetChildren()) do
			if e:IsA("Frame") and e.Name == self.Name then
				self.InstNum += 1;
			end
		end
	end


	self.Effect = effect;
	self.Effect.Visible = true;


	if config.Icon then
		effect.Icon.Image = config.Icon;
	end

	self.Name = config.Name..self.InstNum;
	effect.Name = self.Name;
	
	
	self.Icon = effect.Icon;
	self.IconUrl = effect.Icon.Image;
	self.Destroying = effect.Destroying


	if config.Time then
		self.Effect:WaitForChild("Time").TextFrame.Label.Text = config.Time;
		self:Timer(config.Time);
	end

	
	if createNew then
		self:Enter();
	end


	return self
end



function Effect:Destroy()
	self:Leave();
end



function Effect:GetBaseTransparency(part)
	
	local pDir = Revared:GetDirectoryOf(part);
	
	local function Equals(a, b)
		for i, _ in pairs(a) do
			if a[i] ~= b[i] then
				return false;
			end
		end
		return true;
	end
	
	
	for _, e in pairs(self.Effect:GetDescendants()) do
		
		if e == part then
			local dir = Revared:GetDirectoryOf(e);
			
			if Equals(dir, pDir) then
				local t = base;
				
				for di, d in ipairs(pDir) do
					if d == self.Name then
						for di2, d in ipairs(pDir) do
							if di2 > di then
								t = t:FindFirstChild(d);
							end
						end
					end
				end
				
				return pcall(function()
					
					local op = nil;
					
					if string.match(t.ClassName, "Image") then
						op = {
							ImageTransparency = t.ImageTransparency,
							BackgroundTransparency = t.BackgroundTransparency
						}
					elseif string.match(t.ClassName, "Text") then
						op = {
							TextTransparency = t.TextTransparency,
							TextStrokeTransparency = t.TextStrokeTransparency,
							BackgroundTransparency = t.BackgroundTransparency
						}
					elseif t.ClassName == "Frame" then
						op = {
							BackgroundTransparency = t.BackgroundTransparency,
						}
					else
						op = {
							Transparency = t.Transparency,
						}
					end
					
					return op;
				end);
			end
		end
	end
end


function Effect:Enter()
	
	local dec = self.Effect:GetDescendants();
	
	for i, e in pairs(dec) do
		
		local success, err = pcall(function()
			
			if string.match(e.ClassName, "Image") then
				e.ImageTransparency = 1;
				e.BackgroundTransparency = 1;
				
				local success, t = self:GetBaseTransparency(e);
				
				if success then
					ts:Create(e, TweenInfo.new(0.1, Enum.EasingStyle.Quad), t):Play();
				end
				
			elseif string.match(e.ClassName, "Text") then
				e.TextTransparency = 1;
				e.BackgroundTransparency = 1;
				e.TextStrokeTransparency = 1;
				
				local success, t = self:GetBaseTransparency(e);

				if success then
					ts:Create(e, TweenInfo.new(0.1, Enum.EasingStyle.Quad), t):Play();
				end
				
			elseif e.ClassName == "Frame" then
				e.BackgroundTransparency = 1;

				local success, t = self:GetBaseTransparency(e);

				if success then
					ts:Create(e, TweenInfo.new(0.1, Enum.EasingStyle.Quad), t):Play();
				end
				
			else
				e.Transparency = 1;
				
				local success, t = self:GetBaseTransparency(e);

				if success then
					ts:Create(e, TweenInfo.new(0.1, Enum.EasingStyle.Quad), t):Play();
				end
			end
		end)
		
		if i == #dec then
			self.Entered:Fire()
		end
		
		-- print(success, err);
	end
end


function Effect:Leave()
	
	local dec = self.Effect:GetDescendants()
	
	for i, e in ipairs(dec) do
		
		local animTime = 0.3

		local success, err = pcall(function()

			if string.match(e.ClassName, "Image") then
				local success, t = self:GetBaseTransparency(e);

				if success then
					local tween = ts:Create(e, TweenInfo.new(animTime, Enum.EasingStyle.Quad), {
						ImageTransparency = 1,
						BackgroundTransparency = 1
					});
					
					tween.Completed:Connect(function()
						ts:Create(e, TweenInfo.new(0), t):Play();
					end)
					
					tween:Play();
				end

			elseif string.match(e.ClassName, "Text") then
				local success, t = self:GetBaseTransparency(e);

				if success then
					local tween = ts:Create(e, TweenInfo.new(animTime, Enum.EasingStyle.Quad), {
						TextTransparency = 1,
						TextStrokeTransparency = 1,
						BackgroundTransparency = 1
					});

					tween.Completed:Connect(function()
						ts:Create(e, TweenInfo.new(0), t):Play();
					end)

					tween:Play();
				end
				
			elseif e.ClassName == "Frame" then
				local success, t = self:GetBaseTransparency(e);

				if success then
					local tween = ts:Create(e, TweenInfo.new(animTime, Enum.EasingStyle.Quad), {
						BackgroundTransparency = 1
					});

					tween.Completed:Connect(function()
						ts:Create(e, TweenInfo.new(0), t):Play();
					end)

					tween:Play();
				end
			
			else
				local success, t = self:GetBaseTransparency(e);

				if success then
					local tween = ts:Create(e, TweenInfo.new(animTime, Enum.EasingStyle.Quad), {
						Transparency = 1
					});

					tween.Completed:Connect(function()
						ts:Create(e, TweenInfo.new(0), t):Play();
					end)
					
					tween:Play();
				end
			end
		end)
		
		if i == #dec then
			self.Left:Fire()
			task.wait(animTime-0.01);
			self.Effect:Destroy()
		end
	end
end



function Effect:FormatTime(currentTime)
	local hours = math.floor(currentTime / 3600)
	local minutes = math.floor((currentTime - (hours * 3600))/60)
	local seconds = math.floor((currentTime - (hours * 3600) - (minutes * 60)))
	local milliseconds = math.floor(10 * (currentTime - math.floor(currentTime)))
	
	local t = nil;
	
	if minutes > 0 then
		local format = "%02d:%02d.%01d"
		t = format:format(minutes, seconds, milliseconds)
	else
		local format = "%02d.%01d"
		t = format:format(seconds, milliseconds)
	end

	return t
end



function Effect:Timer(currentTime)
	
	self.Effect:WaitForChild("Time").TextFrame.Label.Text = self:FormatTime(currentTime)
	
	rs.Stepped:Connect(function(newElapsed, step)
		
		if not self.Effect:FindFirstChild("Time") then return; end;
		
		oldElapsed = math.floor(newElapsed)
		currentTime -= step

		self.TimerStep:Fire(currentTime, newElapsed, oldElapsed);

		if currentTime <= 0 then
			return self.TimerDone:Fire();
		end

		self.Effect:WaitForChild("Time").TextFrame.Label.Text = self:FormatTime(currentTime)
	end)
end



return Effect