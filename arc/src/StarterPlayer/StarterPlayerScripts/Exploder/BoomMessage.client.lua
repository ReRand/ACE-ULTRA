local player = game.Players.LocalPlayer;
repeat task.wait() until player:WaitForChild("spawned").Value;


local camera = workspace.CurrentCamera;


local CameraShaker = require(workspace.Modules.CameraShaker);


local function ShakeCamera(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end


local renderPriority = Enum.RenderPriority.Camera.Value + 1


local cs = CameraShaker.new(renderPriority, ShakeCamera)
cs:Start();



local boomMsg = game.ReplicatedStorage.GameEvents.Exploder:WaitForChild("BoomMessage")


boomMsg.OnClientEvent:Connect(function(part, radius)

	local mag = radius/125
	print(mag)

	cs:ShakeOnce(mag, radius/5, (0.1*radius)/1000, (radius/1000*(radius/10))/1.8 );
end)