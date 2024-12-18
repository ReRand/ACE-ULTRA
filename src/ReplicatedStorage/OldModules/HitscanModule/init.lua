local HitscanModule = {}
local player = game.Players.LocalPlayer;
local character = player.Character or player.CharacterAdded:Wait();

local hrp = character:WaitForChild("HumanoidRootPart");

local firer = game.ReplicatedStorage.GameEvents.HtscMod:WaitForChild("Firer")

local camera = workspace.CurrentCamera;
local CameraShaker = require(workspace.Modules.CameraShaker);


local function ShakeCamera(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end

local renderPriority = Enum.RenderPriority.Camera.Value + 1

local cs = CameraShaker.new(renderPriority, ShakeCamera)
cs:Start();


firer.OnClientEvent:Connect(function(pl, ammotype, customconfig)
	if pl == player then
		if ammotype:FindFirstChild("BulletConfig") and ammotype.BulletConfig:FindFirstChild("Modules") then
			for _, mod in pairs(ammotype.BulletConfig.Modules.Shot.Client:GetChildren()) do
				require(mod)(player, ammotype, customconfig);
			end
		end
	end
end)


function HitscanModule:Init(ammotype, customConfig)
	local cf = camera.CFrame;
	
	firer:FireServer(hrp, ammotype, customConfig, camera.CFrame.LookVector, cf)
end


return HitscanModule