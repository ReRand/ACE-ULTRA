repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer

repeat task.wait() until player.spawned.Value

local char = player.Character or player.CharacterAdded:Wait();

local RunService = game:GetService("RunService")

local Values = require(workspace.Modules.Values)
local punching = Values:Fetch("punching");

local humanoid = char:WaitForChild("Humanoid");

humanoid.CameraOffset = Vector3.new(0, 0, -1)
local head = char:WaitForChild("Head");


local function IsBlacklist(vfx)
	local blacklist = { "ParticleEmitter", "PointLight", "SpotLight", "SurfaceLight", "Trail" };
	
	for i, blItem in ipairs(blacklist) do
		if vfx:IsA(blItem) then return true, blItem; end
	end
		
	return false;
end


for i, v in pairs(char:GetChildren()) do
	if (v:IsA("BasePart") and v.Name ~= "Head" and v.Name ~= "Torso" and v.Name ~= "Left Leg" and v.Name ~= "Right Leg" and v.Name ~= "Left Arm" and v.Name ~= "Right Arm") then

		if v:IsA("Accessory") then
			v = v.Handle;
		end

		v:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
			v.LocalTransparencyModifier = v.Transparency;
		end)

		v.LocalTransparencyModifier = v.Transparency
	
	elseif v:IsA("Accessory") or v.Parent:IsA("Accessory") then
		if v:IsA("Accessory") then
			v = v.Handle;
		end
		
		for _, vfx in pairs(v:GetDescendants()) do
			if IsBlacklist(vfx) then
				
				v:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
					if v.Transparency == 1 then
						vfx.Enabled = false;
					else
						vfx.Enabled = true;
					end
				end)
				
				v.LocalTransparencyModifier = v.Transparency
			end
		end
	end
end


RunService.RenderStepped:Connect(function(step)
	local ray = Ray.new(head.Position, ((head.CFrame + head.CFrame.LookVector * 2) - head.Position).Position.Unit)
	local ignoreList = char:GetChildren()

	local hit, pos = game.Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)

	if hit then
		humanoid.CameraOffset = Vector3.new(0, 0, -(head.Position - pos).magnitude)
	end
end)