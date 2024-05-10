return (function(Trigger)

        
    function Trigger:Deactivate()
	    self.Enabled.Value = false;
		self.Deactivated:Fire();
    end

        
end)
