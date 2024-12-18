local client = script.Parent.Events.Client;
repeat task.wait() until game:IsLoaded();


client.OnClientEvent:Connect(function(player, value, ValuesFolder)
	--[[for i0, v0 in pairs( ValuesFolder:GetChildren() ) do
		if v0:IsA("Folder") then
			for i1, v1 in pairs( v0:GetChildren() ) do
				if v1.Name == value then 
					fl:FireServer(v1.Value);
				end
			end
		elseif v0.Name == value and v0:GetAttribute("Value") then 
			fl:FireServer(v0.Value);
		end
	end]]
	
	client:FireServer(value.Value);
end)