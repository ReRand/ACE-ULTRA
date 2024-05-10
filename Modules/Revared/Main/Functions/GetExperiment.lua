return (function(Revared)

	function Revared:GetExperiment(experimentName: string)
		return Revared:Require( Revared.Experiments[experimentName] );
	end

end)
