return (function(Dict)

    function Dict:Pop(offset)
      return self:LastEntry(offset):Destroy()
    end
    
  end)
