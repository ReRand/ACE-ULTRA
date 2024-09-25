local camera = workspace.CurrentCamera;
local CameraShaker = require(workspace.Modules.CameraShaker);


local function ShakeCamera(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end


local renderPriority = Enum.RenderPriority.Camera.Value + 1
local camShake = CameraShaker.new(renderPriority, ShakeCamera)


camShake:Start()


--[[while wait() do
	camShake:Shake(CameraShaker.Presets.BadTrip)
end]]