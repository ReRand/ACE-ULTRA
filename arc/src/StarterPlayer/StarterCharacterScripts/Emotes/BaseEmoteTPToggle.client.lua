local player = game.Players.LocalPlayer;

repeat task.wait() until player.spawned.Value

local character = player.Character or player.CharacterAdded:Wait();
local humanoid = character:WaitForChild("Humanoid");
local arm = character:WaitForChild("Left Arm");

local Values = require(workspace.Modules.Values);
local offset = Values:Fetch("armOffset");

local rs = game:GetService("RunService");

local thirdPerson = Values:Fetch("thirdPerson");
local debugThirdPerson = Values:Fetch("debugThirdPerson");

local toggle = true;

rs.RenderStepped:Connect(function()
	if debugThirdPerson.Value then return; end
	
	local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid);
	local emoting = Values:Fetch("emoting");
	emoting.Value = false;
	
	local anims = animator:GetPlayingAnimationTracks();
	
	if #anims <= 0 then
		player.CameraMode = Enum.CameraMode.LockFirstPerson
		player.CameraMinZoomDistance = game.StarterPlayer.CameraMinZoomDistance;
		
		player.PlayerGui:WaitForChild("CoolGui").Left.Enabled = true;
		player.PlayerGui:WaitForChild("CoolGui").Right.Enabled = true;
		player.PlayerGui:WaitForChild("CoolGui").Middle.Enabled = true;
		player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("crosshair").Visible = true;


		if not toggle then
			arm.Transparency = 1;
			toggle = true;
		end

		arm.LocalTransparencyModifier = arm.Transparency;

		thirdPerson.Value = false;
	end
	
	
	for i, v in ipairs(animator:GetPlayingAnimationTracks()) do
		if string.match(string.lower(v.Name), "dance") or string.match(string.lower(v.Name), "emote") then
			emoting.Value = true;
			
			player.CameraMode = Enum.CameraMode.Classic
			player.CameraMinZoomDistance = game.StarterPlayer.ZoomOutMax.Value;
			player.PlayerGui:WaitForChild("CoolGui").Left.Enabled = false;
			player.PlayerGui:WaitForChild("CoolGui").Right.Enabled = false;
			player.PlayerGui:WaitForChild("CoolGui").Middle.Enabled = false;
			player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("crosshair").Visible = false;

			arm.Transparency = 0;
			arm.LocalTransparencyModifier = arm.Transparency;

			thirdPerson.Value = true;
			toggle = false;
			
		elseif not emoting.Value and i == #anims then
			player.CameraMode = Enum.CameraMode.LockFirstPerson
			player.CameraMinZoomDistance = game.StarterPlayer.CameraMinZoomDistance;
			player.PlayerGui:WaitForChild("CoolGui").Left.Enabled = true;
			player.PlayerGui:WaitForChild("CoolGui").Right.Enabled = true;
			player.PlayerGui:WaitForChild("CoolGui").Middle.Enabled = true;
			player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("crosshair").Visible = true;

			if not toggle then
				arm.Transparency = 1;
				toggle = true;
			end

			arm.LocalTransparencyModifier = arm.Transparency;

			thirdPerson.Value = false;
		end
	end
end)