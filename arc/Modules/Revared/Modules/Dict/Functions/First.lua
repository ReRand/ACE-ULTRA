return (function(Dict)

    function Dict:First(offset)
      if not offset then offset = 0; end
      return self.__dictdata[1+offset].Value;
    end
    
  end)
