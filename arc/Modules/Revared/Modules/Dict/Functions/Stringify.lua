function stringify(o, indents, layer)
    if not layer then layer = 0; end
    
    local tab = ""
    
    for i = 1, layer do
      for i = 1, indents do 
        tab = tab.." ";
      end
    end
    
   if type(o) == 'table' then
      local s = '{\n'
      
      local i = 0;
      
      for k,v in pairs(o) do
          i = i + 1;
          
         if layer == 0 then
           s = tab..s..tab..stringify(v, indents, layer+1) .. ',\n'
          else
            if k == i then
              s = s ..tab .. tab .. stringify(v, indents, layer+1) .. ',\n';
            else
              s = s ..tab .. tab .. k ..': ' .. stringify(v, indents, layer+1) .. ',\n';
            end
          end
      end
      return tab.. s .. tab.. '}'
   else
      if type(o) == "string" then return '"'..o..'"';
      else return tostring(o); end
   end
end


return (function(Dict)

  function Dict:Stringify(indents, layer)
    return stringify(self.StringEntries, indents, layer);
  end
    
  end)
