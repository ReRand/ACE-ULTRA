function GetDirectoryOf(x)
	local dir = {};

	while x ~= game do
		local name = x.Name:gsub('[\"]', '\\%0');
		table.insert(dir, 1, name);
		x = x.Parent;
	end

	return dir;
end


game.ReplicatedStorage.GameEvents.UpdateValue.OnServerEvent:Connect(function(player, dir, name, class, value)
	local v = game;
	
	-- print(string.match(name, "crosshair") and name ~= "crosshairHold" and player:WaitForChild("crosshairHold").Value, name)

	if string.match(name, "crosshair") and name ~= "crosshairHold" and player:WaitForChild("crosshairHold").Value then
		return;
	end

	for _, d in pairs(dir) do
		v = v:WaitForChild(d);
	end
	
	if value ~= v.Value then
		-- print("updated "..name.." on server");
	end

	v.Value = value;
end)


game.Players.PlayerAdded:Connect(function(player)
	
	local added = {};
	
	local function HasBeenAdded(v)
		for i, v1 in ipairs(added) do
			if v1 == v.Name then
				return true, i;
			end
		end
		return false;
	end
	
	player.ChildAdded:Connect(function(v)
		if string.match(v.ClassName, "Value") and not HasBeenAdded(v.Name) then
			
			-- print(v.Name)
			table.insert(added, v.Name);
			
			if v:FindFirstChild("ignore") and v.ignore.Value == true then return; end
			
			v.Changed:Connect(function()
				game.ReplicatedStorage.GameEvents.UpdateValue:FireAllClients(GetDirectoryOf(v), v.Name, v.ClassName, v.Value );
			end)

			game.ReplicatedStorage.GameEvents.ValueAdded:FireAllClients(GetDirectoryOf(v), v.Name, v.ClassName, v.Value);
		end
	end);
	
	for _, v in pairs(player:GetChildren()) do
		if string.match(v.ClassName, "Value") and not HasBeenAdded(v.Name) then

			-- print(v.Name)
			table.insert(added, v.Name);
			
			if v:FindFirstChild("ignore") and v.ignore.Value == true then return; end

			v.Changed:Connect(function()
				game.ReplicatedStorage.GameEvents.UpdateValue:FireAllClients(GetDirectoryOf(v), v.Name, v.ClassName, v.Value );
			end)

			game.ReplicatedStorage.GameEvents.ValueAdded:FireAllClients(GetDirectoryOf(v), v.Name, v.ClassName, v.Value);
		end
	end
end)