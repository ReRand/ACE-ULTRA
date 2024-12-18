local Revared = _G.Revared;
local Signal = Revared:GetModule("Signal");

function tableid(o)
    return tostring(o):sub(type(o):len() + 3)
end

return (function(Entry, Dict)

    function Entry.new(dict, key, value, type)
        Entry.__index = Entry;
            
    	local self = setmetatable( {
            Key = key,
            Index = nil,
            Value = value,
            Type = type,
            Id = nil,
            
            Changed = Signal.new(),
            Destroyed = Signal.new(),
    
            Parent = dict
        }, Entry );

            
        self.Id = tableid(self);

            
		require(Entry.__.index)(self);
	end
        
end)