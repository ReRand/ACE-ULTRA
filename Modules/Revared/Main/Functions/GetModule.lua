return (function(Revared)

	function Revared:GetModule(moduleName: string)
		return Revared:Require( Revared.Modules[moduleName] );
	end

end)
