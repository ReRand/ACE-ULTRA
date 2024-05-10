return (function(Trigger)

        
    function Trigger:Visualize(transparency)
    	if (not transparency) then transparency = 0.5 end
    	
    	local sides = { "Front", "Back", "Right", "Left", "Top", "Bottom" };
    	self.Textures = {};
    
    	for _, side in ipairs(sides) do
    		local texture = Instance.new("Texture", self.Part);
            texture.Texture = "http://www.roblox.com/asset/?id=16742889088"
    		
    		if (self.Settings) then
    			if (self.Settings.TextureTransparency) then
    				transparency = self.Settings.TextureTransparency;
    			end
    			
    			if (self.Settings.Texture) then
    				texture.Texture = self.Settings.Texture
    			end
    		end
    		
    		texture.Name = "TriggerTexture"..side;
    		texture.Transparency = transparency;
    		texture.Face = Enum.NormalId[side];
    		self.Textures[side] = texture;
    	end
    end

        
end)
