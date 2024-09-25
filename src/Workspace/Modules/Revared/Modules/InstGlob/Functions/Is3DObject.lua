return (function(InstGlob)
	
	function InstGlob:Is3DObject(inst: Instance)
		return InstGlob:HasProperty("CFrame", inst)
	end
	
end)