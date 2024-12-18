local ammo = game.ReplicatedStorage:WaitForChild("AmmoTypes");
local ref = workspace:WaitForChild("RefreshingParryables");


local Revared = require(workspace.Modules.Revared);
local InstGlob = Revared:GetModule("InstGlob")



while true do
	
	for _, a in pairs(ref:GetChildren()) do
		if pcall(function() return a.CFrame end) then
			a:Destroy();
		end
	end
	
	
	for _, a in pairs(ammo:GetChildren()) do
		if pcall(function() return a.CFrame end) then
			local thing = a:Clone();
			
			thing.Parent = workspace:WaitForChild("RefreshingParryables");
			thing.Position -= Vector3.new(0, 0, 90);
			
			for _, att in pairs(thing:GetDescendants()) do
				if att:IsA("Weld") then
					att.Part1 = thing:FindFirstChild(att.Part1.Name);
				end
			end
		end
	end
	
	task.wait(60);
end