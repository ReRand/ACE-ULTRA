return (function(InstGlob)
	
	function InstGlob:GetProperty(property: string, inst: Instance)
		local names = {};
		for _, c in pairs(inst:GetChildren()) do
			table.insert(names, c.Name);
		end

		
	end
	
end)