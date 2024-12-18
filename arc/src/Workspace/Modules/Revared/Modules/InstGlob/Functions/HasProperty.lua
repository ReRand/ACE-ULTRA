return (function(InstGlob)

	function InstGlob:HasProperty(property: string, inst: Instance)
		return pcall(function() return inst[property] end)
	end

end)