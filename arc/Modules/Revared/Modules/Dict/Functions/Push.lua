return (function(Dict)

    function Dict:Push(key, value)
        return self:Set(self.Length+1, key, value);
    end
    
end)
