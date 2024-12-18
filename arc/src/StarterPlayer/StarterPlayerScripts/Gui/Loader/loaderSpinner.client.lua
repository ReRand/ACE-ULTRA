repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;

local TweenService = game:GetService('TweenService')
local skull = player.PlayerGui:WaitForChild("LoaderGui").skull

local info = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut) -- Quad

local tween = TweenService:Create(skull, info, { Rotation = 360 });

tween:Play()

local i = 1;

tween.Completed:Connect(function()
	if skull.ImageTransparency == 1 then
		return script:Destroy()
	end
	
	if i == 1 then
		i = 2;
		skull.Image = "rbxassetid://17591452401"
	elseif i == 2 then
		i = 1;
		skull.Image = "rbxassetid://17591451143"
	end
	
	skull.Rotation = 0
	tween:Play()
end)