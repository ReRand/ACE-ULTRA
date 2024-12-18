local ts = game:GetService("TweenService");


local function init(d)
	if d:IsA("Model") then

		local human: Humanoid = d:FindFirstChild("Humanoid");


		if human then
			
			human.Died:Connect(function()
				--[[local character = d;
				character.Archivable = true;

				local clone = character:Clone();
				clone.Parent = workspace.HumanBodies;
				
				for _, p in character:GetChildren() do
					if p.Name ~= "DummyData" then
						p:Destroy();
					end
				end]]
			end)
		end
	end
end;


workspace.DescendantAdded:Connect(init);


for _, d in pairs(workspace:GetDescendants()) do
	init(d);
end