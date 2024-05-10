return (function(Dict)

    function Dict:ForType(tbl)
        local uni = nil;
      local pair = nil;
      
        for t, f in pairs(tbl) do
          if (type(t) == "string" and string.lower(t) == "uni") or (type(t) == "number" and t == Dict.Types.Uni) then
            uni = f;
      elseif (type(t) == "string" and string.lower(t) == "pair") or (type(t) == "number" and t == Dict.Types.Pair) then
            pair = f;
      end
    end
      
        for i, entry in ipairs(self.__dictdata) do
            if entry.Type == Dict.Types.Uni and uni then
                uni(entry.Value, i);
            elseif entry.Type == Dict.Types.Pair and pair then
                pair(entry.Key, entry.Value, i);
            end
        end
    end
    
end)
