return (function(Dict)

	function Dict.__newindex(table, ki, value)
		
		-- if not Dict.__loaded then return; end
		
		-- first loop gets priority checking for key matches
		for i, entry in ipairs(table.__dictdata) do
			if entry.Key == ki then
				entry.Value = value;
			end
		end

		-- second loop checks for index matches
		for i, entry in ipairs(table.__dictdata) do
			if entry.Index == ki then
				entry.Value = value;
			end
		end

		-- if it can't find either it just sets in the table itself
		if rawget(table, ki) then
			table[ki] = value;
		else
			if type(ki) == "number" then
				table:Set(ki, value);
			else
				print(ki, value)
				table:Push(ki, value);
			end
		end
	end;
  
end)