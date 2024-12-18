return (function(Entry)

	function Entry.__index(table, key)

		if key == "Index" then
			for i, entry in ipairs(table.Parent.__dictdata) do
				if entry.Id == table.Id then
					return i;
				end
			end

		elseif key == "Parts" then
			return { table.Index, table.Key, table.Value };

		elseif rawget(Entry, key) then
			return Entry[key];

		elseif rawget(table, key) then
			return table[key];

		else
			return nil;
		end   
	end;

end)