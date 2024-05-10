return (function(Dict)

    function Dict:Shift(offset)
      return self:FirstEntry(offset):Destroy()
    end
    
  end)
