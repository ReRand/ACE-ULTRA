return (function(Entry)

    
    function Entry:Delete()
      local dict = self.Parent;

      table.remove(dict.__dictdata, self.Index);

      return self;
    end

  
  end)
