return (function(Dict)

    function Dict:FirstKey(offset)
      if not offset then offset = 0; end
      return self.__dictdata[1+offset].Key;
    end
    
  end)
