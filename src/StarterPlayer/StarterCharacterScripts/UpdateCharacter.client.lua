local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild('spawned').Value;

local camera = workspace.CurrentCamera;

local character = player.Character or player.CharacterAdded:Wait();
local human = character:WaitForChild("Humanoid");

camera.CameraSubject = human;