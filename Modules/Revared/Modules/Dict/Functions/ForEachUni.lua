return (function(Dict)

    function Dict:ForEachUni(f)
        for i, entry in ipairs(self.__dictdata) do
            if entry.Type == Dict.Types.Uni then
                f(entry.Value, i);
            end
        end
    end
    
end)
