repeat task.wait() until game:IsLoaded();

local RunService = game:GetService("RunService");
local cs = game:GetService("CollectionService");
local rep = game:GetService("ReplicatedStorage");

local player = game.Players.LocalPlayer;
local character = player.Character or player.CharacterAdded:Wait();

local id = script.Parent.Name;
local tag = "Trigger?id="..tostring(id);

local events = rep:WaitForChild("TriggerEvents");

local inEvent = events[id].InEvent;
local outEvent = events[id].OutEvent;

local referInEvent = events[id].ReferInEvent;
local referOutEvent = events[id].ReferOutEvent;


local touchBoolean = false;


function Handle(partSects, id, triggerSettings)

	local TouchPart = nil;


	local function getHitbox()
		for _, part in pairs(character:GetChildren()) do
			if cs:HasTag(part, id) then
				return part;
			end
		end

		return nil;
	end


	if (not getHitbox()) then
		TouchPart = Instance.new("Part", character);
		TouchPart.Name = "PlayerTriggerHitbox";
		TouchPart.Anchored = true;
		TouchPart.CanCollide = false;
		TouchPart.Size = Vector3.new(1, 1, 1);
		TouchPart.Transparency = 1;

		cs:AddTag(TouchPart, tag);


		local offset = Instance.new("Vector3Value", TouchPart);
		offset.Name = "Offset";


		local TouchConnection = TouchPart.Touched:Connect(function() end);


		if (triggerSettings) then
			if (triggerSettings.Hitbox) then
				for name, setting in ipairs(triggerSettings.Hitbox) do
					TouchPart[name] = setting;
				end
			end

			if (triggerSettings.Offset) then
				offset.Value = triggerSettings.Offset;
			end

			if (triggerSettings.Size) then
				TouchPart.Size = triggerSettings.Size;
			end
		end
	else
		TouchPart = getHitbox();
	end


	RunService.RenderStepped:Connect(function()
		local triggerPart = game;


		for _, child in ipairs(partSects) do
			triggerPart = triggerPart[child];
		end


		local function GetParts()
			local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

			if HumanoidRootPart then
				TouchPart.CFrame = HumanoidRootPart.CFrame + TouchPart.Offset.Value;
				return TouchPart:GetTouchingParts();
			end
		end



		local function IsTouching(part)
			for _, touchedPart in ipairs(GetParts()) do
				if cs:HasTag(touchedPart, tag) then return true end
			end

			return false;
		end


		if (IsTouching(triggerPart) and not touchBoolean and triggerPart.TriggerEnabled.Value) then

			touchBoolean = true;
			outEvent:FireServer(1);
			referOutEvent:Fire(1);

		elseif (not IsTouching(triggerPart)) then

			if (touchBoolean) then outEvent:FireServer(2) end
			touchBoolean = false;
		end
	end);
end


inEvent.OnClientEvent:Connect(Handle);
referInEvent.Event:Connect(Handle);
