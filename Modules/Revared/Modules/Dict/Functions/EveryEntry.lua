return (function(Dict)

    function Dict:EveryEntry(f)
      if type(f) == "function" then
        for i, entry in ipairs(self.__dictdata) do
          if not f(entry) then
            return false
          end
        end
                
      else
        for i, entry in ipairs(self.__dictdata) do
          if entry ~= f then
            return false;
          end
        end
      end
      
      return true;
    end
    
  end)
