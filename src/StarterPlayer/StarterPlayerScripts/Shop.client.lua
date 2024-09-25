local TweenService = game:GetService('TweenService');

repeat task.wait() until game:IsLoaded();

local Trigger = require(workspace.Modules.Trigger);
local part = workspace.Triggers.Shop:WaitForChild("ShopTrigger");


local trigger = Trigger.new(part);


local camera = workspace.CurrentCamera;
local shopCamera = workspace.Triggers.Shop:WaitForChild("ShopCamera");
local origin = nil;


local info = TweenInfo.new(1);
local inTween = TweenService:Create(camera, info, { CFrame = shopCamera.CFrame });


trigger.Entered:Connect(function(player)
	origin = camera.CFrame;
	camera.CameraType = Enum.CameraType.Scriptable
	inTween:Play()
end);


trigger.Exited:Connect(function(player)
	camera.CameraType = Enum.CameraType.Custom
end)


trigger:Activate();