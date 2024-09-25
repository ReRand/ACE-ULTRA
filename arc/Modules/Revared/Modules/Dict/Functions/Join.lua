return (function()

    function Dict:Join(joiner)
    if not joiner then joiner = "," end
    local joined = "";
    
    
    self:ForType({
        Uni = function(v, i)
            joined = joined..v;
            if i ~= self.Length then
              joined = joined..joiner;
            end
        end,
        
        Pair = function(k, v, i)
            joined = joined..k;
            if i ~= self.Length then
              joined = joined..joiner;
            end
        end
          
    })
  
    return joined;
  end
    
  end)
