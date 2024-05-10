return (function(Dict)
    function Dict:Destroy(keyOrIndex)
      local entry = nil;
      
      if self.__dictdata[keyOrIndex] then
          entry = self.__dictdata[keyOrIndex];
        else
          for i, e in ipairs(self.__dictdata) do
            if e.Key == keyOrIndex then
              entry = e;
            end
          end
      end
      
      entry:Destroy();
      return entry;
  end
end)
