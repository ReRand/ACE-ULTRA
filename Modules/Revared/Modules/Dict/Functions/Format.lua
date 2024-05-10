return (function(Dict)

    
function Dict:Format(i, ki, v)
      if not v then
          v = ki;
          ki = i;
        end

            
        local entry = nil;
        local vi = 0;
          
          -- indexed uni
          if type(ki) == "number" and type(v) ~= "table" then
              entry = Dict.Entry.new(self, i, v, Dict.Types.Uni);


          -- indexed pair
          elseif type(ki) == "number" and type(v) == "table" then
              for _, __ in pairs(v) do vi = vi + 1 end

              if vi == 1 then
                  for pk, pv in pairs(v) do
                      entry = Dict.Entry.new(self, pk, pv, Dict.Types.Pair);
                  end
              end
          

          -- unindexed pair 
          elseif type(ki) ~= "number" and type(v) ~= "table" then
              entry  = Dict.Entry.new(self, ki, v, Dict.Types.Pair);
          end

      
      return entry;
    end
      
end)
