local rs = game:GetService("RunService");

return (function(RemoteValue)
	return function(table, key)
		
		if key == "LocalValue" then
			if rs:IsServer() then
				local value = nil;
				
				value = table:FetchLocalFromServer(table.LocalPlayer, value, table.ValuesFolder);

				return value;

			elseif rs:IsClient() then
				for i0, v0 in pairs( table.ValuesFolder:GetChildren() ) do
					if v0:IsA("Folder") then
						for i1, v1 in pairs( v0:GetChildren() ) do
							if --[[v1.UniqueId == table.UniqueId or]] v1.Name == table.Name then 
								return v1.Value;
							end
						end
						
					elseif --[[v0.UniqueId == table.UniqueId or]] v0.Name == table.Name and v0:GetAttribute("Value") then 
						return v0.Value
					end
				end
			end



		elseif key == "ServerValue" then
			if rs:IsServer() then
				for i0, v0 in pairs( table.ValuesFolder:GetChildren() ) do
					if v0:IsA("Folder") then
						for i1, v1 in pairs( v0:GetChildren() ) do
							if --[[v1.UniqueId == table.UniqueId or]] v1.Name == table.Name then 
								return v1.Value;
							end
						end
						
					elseif --[[v0.UniqueId == table.UniqueId or]] v0.Name == table.Name and v0:GetAttribute("Value") then 
						return v0.Value
					end
				end

			elseif rs:IsClient() then
				local value = nil;
				
				value = table:FetchServerFromLocal(table.LocalPlayer, value, table.ValuesFolder);
				
				return value;
			end


		elseif rawget(RemoteValue, key) then
			return RemoteValue[key];

		else
			return nil;
		end    
	end
end)