return (function(Trigger)

        
    function Trigger:Devisualize()
    	local sides = { "Front", "Back", "Right", "Left", "Top", "Bottom" };
    
    	for _, side in ipairs(sides) do
    		local name = "TriggerTexture"..side;
    		
    		if (self.Part:FindFirstChild(name)) then
    			self.Part:FindFirstChild(name):Destroy();
    		end
    	end
    end

        
end)
