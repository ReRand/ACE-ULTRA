local client = script.Parent.Parent.Events:WaitForChild("Client");
local swaiting = false;


return (function(RemoteValue)
	function RemoteValue:FetchLocalFromServer(player, value, ValuesFolder)
		if swaiting then return end;

		client:FireClient(player, player, self.Inst, ValuesFolder)

		local value;
		swaiting = true;

		client.OnServerEvent:Connect(function(pl, v)
			if pl == player then
				value = v;
			end
		end)

		return value;
	end
end)