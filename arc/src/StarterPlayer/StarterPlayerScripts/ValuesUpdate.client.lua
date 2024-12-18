local player = game.Players.LocalPlayer;


function GetDirectoryOf(x)
	local dir = {};

	while x ~= game do
		local name = x.Name:gsub('[\"]', '\\%0');
		table.insert(dir, 1, name);
		x = x.Parent;
	end

	return dir;
end


--[[for _, v in pairs(workspace.GlobalValues:GetDescendants()) do
	if string.match(v.ClassName, "Value") then
		v.Changed:Connect(function()
			game.ReplicatedStorage.GameEvents.UpdateValue:FireServer( GetDirectoryOf(v), v.Name, v.ClassName, v.Value );
		end)
	end
end]]


game.ReplicatedStorage.GameEvents.UpdateValue.OnClientEvent:Connect(function(dir, name, class, value)
	local v = game;
	
	for _, d in pairs(dir) do
		v = v:WaitForChild(d);
	end
	
	if value ~= v.Value then
		-- print("updated "..name.." on client");
	end
	
	v.Value = value;
end)



player.ChildAdded:Connect(function(v)
	if string.match(v.ClassName, "Value") then
		
		if v:FindFirstChild("ignore") and v.ignore.Value == true then return; end
		
		v.Changed:Connect(function()
			game.ReplicatedStorage.GameEvents.UpdateValue:FireServer( GetDirectoryOf(v), v.Name, v.ClassName, v.Value );
		end)
	end
end)


game.ReplicatedStorage.GameEvents.ValueAdded.OnClientEvent:Connect(function(dir)
	local v = game;

	for _, d in pairs(dir) do
		v = v:WaitForChild(d);
	end
	
	if v:FindFirstChild("ignore") and v.ignore.Value == true then return; end
	
	v.Changed:Connect(function()
		game.ReplicatedStorage.GameEvents.UpdateValue:FireServer( GetDirectoryOf(v), v.Name, v.ClassName, v.Value );
	end)
end)