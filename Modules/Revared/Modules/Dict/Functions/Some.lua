return (function(Dict)

    function Dict:Some(f)

       local uni = nil;
      local pair = nil;

      if type(f) == "table" then
        for t, f in pairs(f) do
          if (type(t) == "string" and string.lower(t) == "uni") or (type(t) == "number" and t == Dict.Types.Uni) then
            uni = f;
          elseif (type(t) == "string" and string.lower(t) == "pair") or (type(t) == "number" and t == Dict.Types.Pair) then
            pair = f;
          end
        end
        
        for i, entry in ipairs(self.__dictdata) do
            if entry.Type == Dict.Types.Uni and uni then
                if uni(entry.Value, i) then
                  return true;
                end
            elseif entry.Type == Dict.Types.Pair and pair then
              if pair(entry.Key, entry.Value, i) then
                  return true;
                end
            end
        end
      elseif type(f) == "function" then
        for i, entry in ipairs(self.__dictdata) do
          if entry.Type == Dict.Types.Uni and f(entry.Value, i) then
            return true;
          elseif entry.Type == Dict.Types.Pair and f(entry.Key, entry.Value, i) then
            return true;
          end
        end
      else
        for i, entry in ipairs(self.__dictdata) do
          if entry.Value == f then
            return true;
          end
        end
      end
      
      return false;
    end
    
  end)
