return (function(Dict)

	function Dict:__tonumber()
		if not Dict.__loaded then return; end
		return self.Length;
	end

end)