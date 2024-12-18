local Values = {
	RemoteValue = require(script.RemoteValue);
}
local ValuesFolder = script.ValuesFolder.Value;



function Values:Fetch(value: string)
	for i0, v0 in pairs( ValuesFolder:GetChildren() ) do
		if v0:IsA("Folder") then
			for i1, v1 in pairs( v0:GetChildren() ) do
				if v1.Name == value then 
					return v1;
				end
			end
		elseif v0.Name == value and v0:GetAttribute("Value") then 
			return v0;
		end
	end
end


function Values:FetchRemote(value: string, player)
	if typeof(player) == "string" then player = game.Players:GetPlayerByUserId(player); end
	return Values.RemoteValue.new(player, value, ValuesFolder);
end


function Values:FetchFrom(value: string, dir)
	for i0, v0 in pairs( dir:GetChildren() ) do
		if v0:IsA("Folder") then
			for i1, v1 in pairs( v0:GetChildren() ) do
				if v1.Name == value then 
					return v1;
				end
			end
		elseif v0.Name == value and v0:GetAttribute("Value") then 
			return v0;
		end
	end
end


function Values:Set(value: string, set)
	Values:Fetch(value).Value = set
end


function Values:Get(value: string)
	return Values:Fetch(value).Value;
end


function Values:SetAt(value: string, set, dir)
	Values:FetchFrom(value, dir).Value = set
end


function Values:GetFrom(value: string, dir)
	return Values:FetchFrom(value, dir).Value;
end


function Values:FetchRel(relative: string, value: string)
	return ValuesFolder[relative][value];
end


function Values:GetRel(relative: string, value: string)
	return Values:FetchRel(relative, value).Value;
end


function Values:SetRel(relative: string, value: string, set)
	Values:FetchGet(relative, value).Value = set
end


return Values
