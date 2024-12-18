repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;

repeat task.wait() until player.spawned.Value;

local character = player.Character or player.CharacterAdded:Wait();
local hrp = character:WaitForChild("HumanoidRootPart");
local head = character:WaitForChild("Head");
local humanoid = character:WaitForChild("Humanoid");

local baseLanding = hrp:WaitForChild("Landing");
baseLanding.SoundId = "";

local baseRunning = hrp:WaitForChild("Running");

local baseJumping = hrp:WaitForChild("Jumping");
baseJumping.SoundId = "";

repeat task.wait() until script;
repeat task.wait() until script.Parent;

local landing = game.ReplicatedStorage.GameSounds:WaitForChild("Landing")
local falling = game.ReplicatedStorage.GameSounds:WaitForChild("Falling")
local jumping = game.ReplicatedStorage.GameSounds:WaitForChild("Jumping")

local footsteps = game.ReplicatedStorage.GameSounds:WaitForChild("Footsteps"):GetChildren();

local Values = require(workspace.Modules.Values);
local slamming = Values:Fetch("slamming");
local sliding = Values:Fetch("sliding");
local dashing = Values:Fetch("dashing");

local rs = game:GetService("RunService");
local ts = game:GetService("TweenService");

local OutFall = ts:Create(falling, TweenInfo.new(0.2), { Volume = 0 });


humanoid.Running:Connect(function(speed)
	if speed > 0 and not sliding.Value and not dashing.Value then
		
	end
end)


humanoid.StateChanged:Connect(function(oldState, newState)
	if newState == Enum.HumanoidStateType.Jumping then
		jumping:Play();
	
	
	elseif not slamming.Value and oldState == Enum.HumanoidStateType.Freefall and newState == Enum.HumanoidStateType.Landed then
		
		local baseVol = landing.Volume;
		
		landing.Volume = ((math.abs(hrp.Velocity.Y)/100)/2)/2
		
		landing:Play();
		falling:Stop();
		
		landing.Ended:Connect(function()
			landing.Volume = baseVol;
		end)
	end
end)



rs.RenderStepped:Connect(function()
	if humanoid:GetState() == Enum.HumanoidStateType.Freefall and hrp.Velocity.Y < -10 and not slamming.Value then

		local baseVol = falling.Volume;
		
		local InFall = ts:Create(falling, TweenInfo.new(0.2), { Volume = (math.abs(hrp.Velocity.Y)/100)/2 });

		if not falling.IsPlaying then
			falling:Play();
			InFall:Play();
		end

		falling.Ended:Connect(function()
			falling.Volume = baseVol;
		end)
		
		while humanoid:GetState() == Enum.HumanoidStateType.Freefall and hrp.Velocity.Y < -10 and not slamming.Value do
			(ts:Create(falling, TweenInfo.new(0.2), { Volume = falling.Volume+0.01 })):Play()
			task.wait(0.1)
		end
		
	elseif humanoid:GetState() == Enum.HumanoidStateType.Freefall and hrp.Velocity.Y < -10 and slamming.Value then
		local baseVol = falling.Volume;

		local InFall = ts:Create(falling, TweenInfo.new(0.2), { Volume = (math.abs(hrp.Velocity.Y)/100)/2/2/2 });

		if not falling.IsPlaying then
			falling:Play();
			InFall:Play();
		end

		falling.Ended:Connect(function()
			falling.Volume = baseVol;
		end)
		
		while humanoid:GetState() == Enum.HumanoidStateType.Freefall and hrp.Velocity.Y < -10 and not slamming.Value do
			(ts:Create(falling, TweenInfo.new(0.2), { Volume = falling.Volume+0.01 })):Play()
			task.wait(0.1)
		end
	else
		OutFall:Play();

		OutFall.Completed:Connect(function()
			falling:Stop();
		end)
	end
end)