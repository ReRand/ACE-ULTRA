return (function(Dict)

    function Dict:Set(i, ki, v)
  
        local entry = self:Format(i, ki, v);

        self.__dictdata[i] = entry;

        return entry;
    end
    
end)
