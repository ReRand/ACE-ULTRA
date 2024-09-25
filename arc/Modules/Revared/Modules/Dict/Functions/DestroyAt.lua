return (function(Dict)

    function Dict:DestroyAt(index)
      local entry = self.__dictdata[index];
      entry:Destroy();
      return entry;
    end
    
  end)
