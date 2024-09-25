return (function(Dict)

    function Dict:SomeEntries(f)
      if type(f) == "function" then
        for i, entry in ipairs(self.__dictdata) do
          if f(entry) then
            return true
          end
        end
                
      else
        for i, entry in ipairs(self.__dictdata) do
          if entry == f then
            return true;
          end
        end
      end
      
      return false;
    end
    
  end)
