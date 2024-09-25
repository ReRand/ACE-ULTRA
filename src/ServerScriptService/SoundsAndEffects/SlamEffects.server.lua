repeat task.wait() until script;
repeat task.wait() until script.Parent;

local effects = game.ReplicatedStorage.GameEvents.SlideSlam:WaitForChild("SlamEffects")
local ts = game:GetService("TweenService");


effects.OnServerEvent:Connect(function(player, character, pos, peakVel)
	local shockwave = game.ReplicatedStorage:WaitForChild("Particles").shockwave;


	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = { character }
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude


	local ray = workspace:Raycast(pos, Vector3.new(0, -100, 0), raycastParams);

	if ray then
		local sw = shockwave:Clone();
		
		sw.Parent = workspace;
		sw.Position = ray.Position;
		sw.Size = Vector3.new(0, 0, 0);
		
		peakVel = math.abs(peakVel);
		
		local s = Vector3.new(peakVel/15, 1+peakVel/1000, peakVel/15);
		local t = peakVel/(500);
		
		
		local tween1 = ts:Create(sw, TweenInfo.new(t, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
			Size = s,
		});
		
		
		for _, texture in pairs(sw:GetChildren()) do
			if texture:IsA("Decal") or texture:IsA("Texture") then

				local t = peakVel/(750);
				
				texture.Transparency = 0.5

				local textureTween = ts:Create(texture, TweenInfo.new(t, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
					Transparency = 1
				});

				textureTween.Completed:Connect(function()
					sw:Destroy();
				end)

				textureTween:Play();
			end
		end
	
	
		tween1:Play();
	end
end)