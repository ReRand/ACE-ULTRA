return (function(Dict)

    function Dict:ForEachEntry(f)
        for i, entry in ipairs(self.__dictdata) do
            f(entry);
        end
    end
    
end)
