return (function(Dict)

    function Dict:Last(offset)
      if not offset then offset = 0; end
      return self.__dictdata[self.Length-offset].Value;
    end
    
  end)
