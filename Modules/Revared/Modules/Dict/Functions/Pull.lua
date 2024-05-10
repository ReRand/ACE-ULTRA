return (function(Dict)

    function Dict:Pull(key, value)
        return self:Append(1, key, value);
    end
    
end)
