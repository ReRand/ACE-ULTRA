local player = game.Players.LocalPlayer;

local parity = game.ReplicatedStorage.GameEvents:WaitForChild("ArmParity");

parity.OnClientEvent:Connect(function(pl, thirdPerson, rShoulder, rcf, lerpTime, baseRS)
	if not rShoulder or pl == player then return end
	
	if thirdPerson then
		rShoulder.C1 = rShoulder.C1:Lerp(baseRS, 1/1.5);
	else
		rShoulder.C1 = rShoulder.C1:Lerp(rcf, 1/1.5)
	end
end)


repeat task.wait() until player.spawned.Value

local character = player.Character or player.CharacterAdded:Wait();
local humanoid = character:WaitForChild("Humanoid");

local Values = require(workspace.Modules.Values);
local offset = Values:Fetch("armOffset");


local torso = character:WaitForChild("Torso");


local camera = workspace.CurrentCamera;
local mouse = game.Players.LocalPlayer:GetMouse();


local rs = game:GetService("RunService");


local animationBlacklist = {
	"Animation1", "Animation2", "JumpAnim", "FallAnim", "WalkAnim"
}


local rShoulder = torso:WaitForChild("Right Shoulder");
local lShoulder = torso:WaitForChild("Left Shoulder");

local thirdPerson = Values:Fetch("thirdPerson");

local baseRS = rShoulder.C1;
local baseLS = lShoulder.C1;

local delayed = false;


rs.RenderStepped:Connect(function()
	local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid);
	for i, v in ipairs(animator:GetPlayingAnimationTracks()) do
		for i, blacklisted in ipairs(animationBlacklist) do
			if v.Name == blacklisted then
				v:Stop();
			end
		end
	end
	
	local y = camera.CFrame.LookVector.Y;
	local z = y > 0 and y/1.2 or 0.1;
	
	local usedY = y > 0 and 1.3+y or 1.3;
	
	local rcf = CFrame.Angles( math.deg((30*(-y/1800)) + 190 ), 1.7, math.deg(10) ) + Vector3.new(-0.3, usedY, z+offset.Value);
	local lcf = CFrame.Angles( math.deg((25*(-y/1800)) ), -1.5, math.deg(25) ) + Vector3.new(0.4, 1.3, z+offset.Value);
	
	
	local lerpTime = 1/7
	
	if not thirdPerson.Value then
		rShoulder.C1 = rShoulder.C1:Lerp(rcf, lerpTime)
		lShoulder.C1 = lShoulder.C1:Lerp(lcf, lerpTime)
	else
		lShoulder.C1 = baseLS;
		rShoulder.C1 = baseRS;
	end
	
	if not delayed then
		parity:FireServer(thirdPerson.Value, rShoulder, rcf, lerpTime, baseRS);
		
		task.delay(0.1, function()
			delayed = false;
		end)
		
		delayed = true;
	end
end)