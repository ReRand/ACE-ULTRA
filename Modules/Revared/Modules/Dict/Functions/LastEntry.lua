return (function(Dict)

    function Dict:LastEntry(offset)
      if not offset then offset = 0; end
      return self.__dictdata[self.Length-offset];
    end
    
  end)
