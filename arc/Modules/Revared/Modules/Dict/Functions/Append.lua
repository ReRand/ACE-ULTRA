return (function(Dict)

    function Dict:Append(index, key, value)
        local entry = self:Format(index, key, value);

        table.insert(self.__dictdata, index, entry);

        return entry
    end
    
end)
