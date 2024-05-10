return (function(Dict)

    function Dict:ForEach(f)
        for i, entry in ipairs(self.__dictdata) do
            if entry.Type == Dict.Types.Uni then
                f(entry.Value, i);
            else
                f(entry.Key, entry.Value, i);
            end
        end
    end
    
end)
