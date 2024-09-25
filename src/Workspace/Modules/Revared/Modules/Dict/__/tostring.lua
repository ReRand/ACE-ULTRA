-- help from https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console

return (function(Dict)

  function Dict:__tostring()
		if not Dict.__loaded then return; end
      	return "Dict ("..tostring(self.Length)..") "--..self:Stringify(4);
    end
    
end)