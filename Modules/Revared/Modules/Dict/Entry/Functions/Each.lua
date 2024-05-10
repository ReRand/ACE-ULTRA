return (function(Entry, Dict)

    function Entry:For()
        if self.Type == Dict.Types.Uni then 
          return self.Value, self.Index;
        else
          return self.Key, self.Value, self.Index;
      end
    end
    
end)
