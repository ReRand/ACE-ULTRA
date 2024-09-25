return (function(Dict)

    function Dict:ForEachPair(f)
        for i, entry in ipairs(self.__dictdata) do
            if entry.Type == Dict.Types.Pair then
                f(entry.Value, i);
            end
        end
    end
    
end)
