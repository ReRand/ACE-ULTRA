local server = script.Parent.Parent.Events:WaitForChild("Server");
local swaiting = false;


return (function(RemoteValue)
	function RemoteValue:FetchServerFromLocal(player, value, ValuesFolder)
		if swaiting then return end;

		server:FireServer(player, self.Inst, ValuesFolder)

		local value;
		swaiting = true;

		server.OnClientEvent:Connect(function(pl, v)
			if pl == player then
				value = v;
			end
		end)
		
		server.OnClientEvent:Wait();

		return value;
	end
end)