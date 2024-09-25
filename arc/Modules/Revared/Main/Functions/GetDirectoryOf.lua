return (function(Revared)

    
	function Revared:GetDirectoryOf(x)
		local dir = {};

	    while x ~= game do
	        local name = x.Name:gsub('[\"]', '\\%0');
	        table.insert(dir, 1, name);
	        x = x.Parent;
	    end
	
	    return dir;
	end

    
end)
