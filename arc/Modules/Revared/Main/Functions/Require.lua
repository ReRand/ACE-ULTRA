return (function(Revared)

        
	function Revared:Require(rawModule)
        local module = require(rawModule);
        
        if module["Init"] then
            module:Init(Revared);
        end

        return module;
	end

        
end);
