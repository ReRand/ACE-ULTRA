local player = game.Players.LocalPlayer;

repeat task.wait() until game:IsLoaded();
repeat task.wait() until player.spawned.Value;

local character = player.Character or player.CharacterAdded:Wait();
local humanoid = character:WaitForChild("Humanoid");
local Values = require(workspace.Modules.Values);
local sliding = Values:Fetch("sliding");


repeat task.wait() until script;
repeat task.wait() until script.Parent;


local Sound = game.ReplicatedStorage.GameSounds.SlideSlam:WaitForChild("Slide")

Sound.TimePosition = 2;

sliding.Changed:Connect(function()
	while sliding.Value do
		if humanoid:GetState() == Enum.HumanoidStateType.Running and not Sound.IsPlaying then
			Sound:Play();
		elseif humanoid:GetState() ~= Enum.HumanoidStateType.Running and Sound.IsPlaying then
			Sound:Stop();
		end
		task.wait();
	end
end)