local RBXScriptSignal = require(workspace.Modules.Signal);
local Revared = require(workspace.Modules.Revared);


local rs = game:GetService("RunService");
local ts = game:GetService("TweenService");


local KillFeed = {}


local KillItem = {};
KillItem.__index = KillItem;
KillFeed.KillItem = KillItem;



local add = game.ReplicatedStorage.GameEvents:WaitForChild("AddKillFeedItem");
local rem = game.ReplicatedStorage.GameEvents:WaitForChild("RemoveKillFeedItem");



function KillFeed.Messages()
	local ms = script.Messages:GetChildren();
	local fixed = {}
	
	for _, m in pairs(ms) do
		if string.match(m.ClassName, "Value") then
			table.insert(fixed, tonumber(m.Value), m.Name)
		end
	end
	
	return fixed;
end



function KillFeed.Types()
	local gui = game.StarterGui:WaitForChild("CoolGui"):WaitForChild("KillFeed");
	local list = gui:WaitForChild("feed");
	local base = gui:WaitForChild("Base");
	
	return {
		[1] = base:WaitForChild("WeaponKill"),
		[2] = base:WaitForChild("ReasonKill"),
		[3] = base:WaitForChild("AssistWeaponKill"),
		[4] = base:WaitForChild("AssistFinishKill"),
		[5] = base:WaitForChild("AssistFinishWeaponKill"),
		[6] = base:WaitForChild("SelfWeaponKill"),
		[7] = base:WaitForChild("SelfKill"),
	}
end



function KillFeed:GetMessage(id)
	return KillFeed.Messages()[tonumber(id)];
end



function KillItem.new(data)
	
	local gui = game.StarterGui:WaitForChild("CoolGui"):WaitForChild("KillFeed");
	local list = gui:WaitForChild("feed");
	local base = gui:WaitForChild("Base");
	
	
	local self = setmetatable({
		
		
		VictimPlayer = data.VictimPlayer,
		VictimHuman = data.VictimHuman,
		Victim = data.Victim,
		
		AttackerPlayer = data.AttackerPlayer,
		AttackerHuman = data.AttackerHuman,
		Attacker = data.Attacker,
		
		
		AssistPlayer = data.AssistPlayer,
		AssistHuman = data.AssistHuman,
		Assist = data.Assist,
		
		
		Type = 2,
		Reason = 1,
		Weapon = 0,
		
		--Entered = RBXScriptSignal.new(),
		--Left = RBXScriptSignal.new(),
		
	}, KillItem)
	
	
	local t = data.Type;
	local r = data.Reason;
	local w = data.Weapon;
	
	
	
	if t ~= nil and t > 0 then
		self.Type = t;
	end
	
	if r ~= nil and r > 0 then
		self.Reason = r;
	end
	
	if w ~= nil and w > 0 then
		self.Weapon = w;
	end
	
	add:FireAllClients(self);
	
	return self;
end


--[[
function KillItem:Destroy()
	self:Leave();
end



function KillItem:GetBaseTransparency(part)

	local pDir = Revared:GetDirectoryOf(part);

	local function Equals(a, b)
		for i, _ in pairs(a) do
			if a[i] ~= b[i] then
				return false;
			end
		end
		return true;
	end


	for _, e in pairs(self.GuiObject:GetDescendants()) do

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


function KillItem:Enter()

	local dec = self.GuiObject:GetDescendants();

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


function KillItem:Leave()

	local dec = self.GuiObject:GetDescendants()

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
			self.GuiObject:Destroy()
		end
	end
end
]]


return KillFeed