return (function(Dict)

    function Dict:Clone()
        return Dict.new(table.unpack(self.__args));
    end
    
end)
