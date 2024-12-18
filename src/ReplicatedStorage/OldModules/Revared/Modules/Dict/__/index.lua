return (function(Dict)

	function Dict.__index(table, ki)
		-- if not Dict.__loaded then return nil; end
		
		if ki == "Length" then
			local length = 0;
			for _, __ in pairs(table.__dictdata) do length = length + 1 end
			return length;


		elseif ki == "Keys" then
			local keys = {};

			for i, entry in ipairs(table.__dictdata) do
				keys[i] = entry.Key;
			end

			return keys;


		elseif ki == "Values" then
			local values = {};

			for i, entry in ipairs(table.__dictdata) do
				values[i] = entry.Value;
			end

			return values;


		elseif ki == "Entries" then
			return table:Clone().__dictdata;


		elseif ki == "StringEntries" then
			local re = {};

			for i, entry in ipairs(table.__dictdata) do
				re[i] = { [entry.Key] = entry.Value };
			end

			return re;


		else
			-- first loop gets priority checking for key matches
			for i, entry in ipairs(table.__dictdata) do
				if entry.Key == ki then
					return entry.Value;
				end
			end

			-- second loop checks for index matches
			for i, entry in ipairs(table.__dictdata) do
				if entry.Index == ki then
					return entry.Value;
				end
			end

			-- if it can't find either it just returns from the table itself or nil
			if rawget(table, ki) then
				return rawget(table, ki);
			else
				return nil;
			end
		end
	end;
	
end)