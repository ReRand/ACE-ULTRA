local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("spawned").Value;

local character = player.Character or player.CharacterAdded:Wait();
local human = character:WaitForChild("Humanoid");


local starter = game.StarterPlayer;


human.HealthDisplayDistance = starter.HealthDisplayDistance;

human.MaxSlopeAngle = starter.CharacterMaxSlopeAngle;
human.WalkSpeed = starter.CharacterWalkSpeed;

human.AutoJumpEnabled = starter.AutoJumpEnabled;
human.UseJumpPower = starter.CharacterUseJumpPower;

if starter.CharacterUseJumpPower then
	human.JumpPower = starter.CharacterJumpPower;
else
	human.JumpHeight = starter.CharacterJumpHeight;
end