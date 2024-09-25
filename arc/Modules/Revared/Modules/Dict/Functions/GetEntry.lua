return (function(Dict)

    function Dict:GetEntry(keyOrIndex)
      if self.__dictdata[keyOrIndex] then
        return self.__dictdata[keyOrIndex];
      else
        for i, entry in ipairs(self.__dictdata) do
          if entry.Key == keyOrIndex then
            return entry;
          end
        end
    end
        end
    
  end)
