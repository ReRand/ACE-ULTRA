function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end


return (function(Revared)
    
	function Revared:GetDirectoryOf(x)
		return x == game and {} or split(x:GetFullName(), ".")
	end

    
end)