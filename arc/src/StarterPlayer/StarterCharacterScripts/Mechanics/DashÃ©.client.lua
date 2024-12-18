-- repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;
repeat task.wait() until player.spawned.Value;

local TweenService = game:GetService("TweenService");
local Values = require(workspace.Modules.Values);
local RunService = game:GetService("RunService");
local StarterPlayer = game:GetService("StarterPlayer");

local uis = game:GetService("UserInputService");
local cas = game:GetService("ContextActionService");
local character = player.Character or player.CharacterAdded:Wait();

local camera = workspace.CurrentCamera;

local mmg = require(script.Parent.Parent.Modules.MobileMockGui);


local humanoid = character:WaitForChild("Humanoid");
local hrp = character:WaitForChild("HumanoidRootPart");

local baseVel = nil;


local speedEmitter = nil;


local dashing = Values:Fetch("dashing");
local stamina = Values:Fetch("stamina");
local staminaHold = Values:Fetch("staminaHold");

local iframed = player:WaitForChild("iframed");

local baseForce = nil;
local baseP = nil;


local forward = false;
local backward = false;
local left = false;
local right = false;

local baseGrav = workspace.Gravity;

local iframeTime = 0.5


local Effect = require(script.Parent.Parent.Modules.Effect);


local Sounds = game.ReplicatedStorage.GameSounds.Dash:GetChildren();

local typing = Values:Fetch("typing");
local thirdPerson = Values:Fetch("thirdPerson");
local emotesMenuOpen = Values:Fetch("emotesMenuOpen");
local spawned = player.spawned

local function Began(Input)

	if stamina.Value >= 30 and not emotesMenuOpen.Value and not thirdPerson.Value and not typing.Value and spawned.Value and player:WaitForChild("dashEnabled").Value then

		local stoppers = { "slamming", "ragdoll" };
		local disablers = {
			slamming = "GroundSlaméHitbox"
		}


		for _, stopper in ipairs(stoppers) do
			local val = Values:Fetch(stopper);
			if (val.Value) then return; end
		end


		for valueName, hitboxName in pairs(disablers) do
			local val = Values:Fetch(valueName);
			if (val.Value and hrp:FindFirstChild(hitboxName)) then
				hrp:FindFirstChild(hitboxName):Destroy();
			end
		end

		dashing.Value = true;
		iframed.Value = true;
		stamina.Value -= 30;
		staminaHold.Value = true;
		
		-- local forcefield = Instance.new("ForceField", character);

		local head = character:WaitForChild("Head");

		workspace.Gravity = baseGrav;

		hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z);

		Sounds[math.random(1, #Sounds)]:Play();


		local bp = Instance.new("BodyPosition", hrp)


		baseForce = bp.MaxForce;
		baseP = bp.P;

		--Chase Stage 1 State
		bp.MaxForce = Vector3.new(100000,-1, 100000)
		bp.P = 10000000000

		--[[
		local baseOffset = Vector3.new(0, 0, -1);

		(TweenService:Create(humanoid, TweenInfo.new(1), {
			CameraOffset = Vector3.new(0, 2, -2)
		})):Play();
		]]


		local startTime = tick()


		local y = hrp.Position.Y+1.5;


		if not forward and not backward and not left and not right then
			forward = true;
		end


		local magnitude = left and -25 or 25;


		if left or right then
			-- print(magnitude);

			-- camera.CFrame *= CFrame.Angles(0, 0, 90) -- math.rad(magnitude));
		end


		for i=0, 10 do
			local currtime = tick()
			local elapsedtime = currtime - startTime

			local x = (left) and -0.7 or (right) and 0.7 or 0
			local z = (forward) and -0.7 or (backward) and 0.7 or 0


			local newPos = hrp.CFrame * CFrame.new(x, 0, z).Position;

			-- local mult = math.floor(hrp.Velocity.Magnitude/1000)+1 >= 1 and math.floor(hrp.Velocity.Magnitude/1000)+1 or 1;

			bp.Position = Vector3.new(newPos.X, 0, newPos.Z);
			bp.P = 999999999

			character:MoveTo(Vector3.new(hrp.Position.X, y, hrp.Position.Z));

			task.wait()
		end

		bp:Destroy()


		dashing.Value = false;
		
		
		local deac = true;
		
		
		local iframeEffect = Effect.new({
			Name = "IFrameEffect",
			Time = iframeTime,
			Icon = script.icon.Image,
			WriteOver = true
		});
		
		
		dashing.Changed:Connect(function()
			if dashing.Value then
				deac = false;
			end
		end)
		
		
		task.delay(iframeTime, function()
			if deac then
				iframed.Value = false;
				iframeEffect:Destroy()
				-- forcefield:Destroy();
			end
		end)
		

		task.wait(1);

		staminaHold.Value = false;
	elseif stamina.Value <= 0 and not typing.Value and not thirdPerson.Value then
		local label = player.PlayerGui.CoolGui.Left.Frame.dash

		local t1 = TweenService:Create(label, TweenInfo.new(0.2), {
			TextColor3 = Color3.fromRGB(255)
		});

		local t2 = TweenService:Create(label, TweenInfo.new(0.2), {
			TextColor3 = Color3.fromRGB(25, 184, 179)
		});

		t1.Completed:Connect(function()
			t2:Play();
		end)

		t1:Play();
	end
end


iframed.Changed:Connect(function()
	if iframed.Value then
		
		local label = player.PlayerGui.CoolGui.Left.Frame.health;

		local t2 = TweenService:Create(label, TweenInfo.new(0.5), {
			TextStrokeTransparency = 1
		});

		local t1 = TweenService:Create(label, TweenInfo.new(0.5), {
			TextStrokeColor3 = Color3.fromRGB(255, 225, 0),
			TextStrokeTransparency = 0
		});

		t1.Completed:Connect(function()
			t2:Play();
		end)

		t1:Play();
	else
		
	end
end)


cas:BindAction("Dash", function(name, state, Input)
	if state == Enum.UserInputState.Begin then
		Began(Input);
	end
end, true, Enum.KeyCode.LeftShift, Enum.KeyCode.ButtonX);


mmg:Replicate("Dash");



uis.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.Thumbstick1 then
		if Input.Delta.X >= 0.1 then
			right = true;
		elseif Input.Delta.X <= 0.1 then
			left = true;
		elseif Input.Delta.Y >= 0.1 then
			forward = true;
		elseif Input.Delta.Y <= 0.1 then
			backward = true;
		end
	end

	if Input.KeyCode == Enum.KeyCode.W then
		forward = true;

	elseif Input.KeyCode == Enum.KeyCode.A then
		left = true;

	elseif Input.KeyCode == Enum.KeyCode.S then
		backward = true;

	elseif Input.KeyCode == Enum.KeyCode.D then
		right = true;
	end
end)

uis.InputEnded:Connect(function(Input)

	if Input.KeyCode == Enum.KeyCode.Thumbstick1 then
		if Input.Delta.X >= 0.1 then
			right = false;
		elseif Input.Delta.X <= 0.1 then
			left = false;
		elseif Input.Delta.Y >= 0.1 then
			forward = false;
		elseif Input.Delta.Y <= 0.1 then
			backward = false;
		end
	end

	if Input.KeyCode == Enum.KeyCode.W then
		forward = false;

	elseif Input.KeyCode == Enum.KeyCode.A then
		left = false;

	elseif Input.KeyCode == Enum.KeyCode.S then
		backward = false;

	elseif Input.KeyCode == Enum.KeyCode.D then
		right = false;
	end

end)