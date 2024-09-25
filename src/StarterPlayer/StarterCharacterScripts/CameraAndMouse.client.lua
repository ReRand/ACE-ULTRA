local player = game.Players.LocalPlayer;

local camera = workspace.CurrentCamera;

camera.FieldOfView = 95;

repeat task.wait() until game:IsLoaded();
repeat task.wait() until player.spawned.Value;


--[[local RunService = game:GetService"RunService"
local UserInputService = game:GetService"UserInputService"

RunService:BindToRenderStep("MouseLock",Enum.RenderPriority.Last.Value+1,function()
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
end)]]


local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

mouse.Icon = "rbxassetid://14013223911"