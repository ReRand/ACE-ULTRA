local function split(str)
	local list = {};
	
	str:gsub(".", function(char) 
		table.insert(list, char) 
	end)
	
	return list;
end

return (function(Revared)


	function Revared:GenerateId(length, characters)
		if not length then length = 10 end;
		local id = {};

		if not characters then
			characters = "1234567890";
		end
		
		characters = split(characters);

		for i=1, length do
			id[i] = characters[math.random(1, #characters)];
		end

		return tostring(table.concat(id));
	end


end)
