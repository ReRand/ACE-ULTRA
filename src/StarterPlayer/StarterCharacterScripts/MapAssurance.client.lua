local player = game.Players.LocalPlayer;


for _, p in pairs(workspace:WaitForChild("GameRoundMap"):GetDescendants()) do
	pcall(function()
		p.Anchored = true;
	end)
end



for _, p in pairs(workspace:WaitForChild("CoolGui"):GetChildren()) do
	pcall(function()
		p.Anchored = true;
	end)
end


for _, p in pairs(workspace:WaitForChild("CoolTitleGui"):GetChildren()) do
	pcall(function()
		p.Anchored = true;
	end)
end


for _, p in pairs(workspace:WaitForChild("CoolTouchGui"):GetChildren()) do
	pcall(function()
		p.Anchored = true;
	end)
end


workspace:WaitForChild("Baseplate").Anchored = true;


local mapV = workspace.GlobalValues.Game.map;

repeat task.wait() until mapV.Value;

local map = mapV.Value;

for _, p in pairs(map:GetDescendants()) do
	pcall(function()
		p.Anchored = true;
	end)
end