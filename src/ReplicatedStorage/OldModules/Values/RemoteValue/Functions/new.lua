local RBXScriptSignal = require(workspace.Modules:FindFirstChild("Signal"));
local rs = game:GetService("RunService");


function tableid(o)
	return tostring(o):sub(type(o):len() + 3)
end


local function init(tbl)
	tbl.UniqueRemoteValueId = tableid(tbl);
	
	for i0, v0 in pairs( tbl.ValuesFolder:GetChildren() ) do

		if v0:IsA("Folder") then
			for i1, v1 in pairs( v0:GetChildren() ) do
				if v1.Name == tbl.Name then 
					tbl.ClassName = v1.ClassName;
					tbl.Inst = v1;
				end
			end

		elseif v0.Name == tbl.Name and v0:GetAttribute("Value") then 
			tbl.ClassName = v0.ClassName;
			tbl.Inst = v0;
		end
	end
end


return (function(RemoteValue)
	
	
	local ind = require(script.Parent.Parent.__.index)(RemoteValue);
	local newind = require(script.Parent.Parent.__.newindex)(RemoteValue)


	function RemoteValue.new(player, value, ValuesFolder)
		RemoteValue.__index = RemoteValue;

		local self = setmetatable( {
			
			-- variables
			Name = value,
			ClassName = nil,
			UniqueRemoteValueId = nil,
			LocalPlayer = player,
			ValuesFolder = ValuesFolder,
			Inst = nil,
			
			
			-- stuff
			LocalValue = nil,
			ServerValue = nil,
			
			
			-- events
			OnLocalChanged = RBXScriptSignal.new(),
			OnServerChanged = RBXScriptSignal.new(),
			Changed = RBXScriptSignal.new()
			
			
		}, RemoteValue );

		
		init(self);


		RemoteValue.__index = ind;
		-- RemoteValue.__newindex = newind;

		

		return self;
	end

end)