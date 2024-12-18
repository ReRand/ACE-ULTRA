local Signal = require(workspace.Modules.Signal);


return (function(CWeld)
	
	local CWeldConfig = {};
	CWeldConfig.__index = CWeldConfig;
	
	
	function CWeldConfig:__newindex(k, v)
		self.Changed:Fire(k, rawget(self, k), v);
		rawset(self, k, v);
	end


	function CWeldConfig.new(configTable)
		
		if not configTable then configTable = {} end;
		
		
		local defaults = {
			AutoSize = true,
			D = 10,
			X = 0,
			Y = 0,
			DPosOffset = 0,
			XPosOffset = 0,
			YPosOffset = 0,
			XRotOffset = 0,
			YRotOffset = 0,
			ZRotOffset = 0,
			Rotation = Vector3.new(),
			LerpStep = 1/1.1,
			Debug = false
		}
		
		
		for k, v in defaults do
			if not configTable[k] then configTable[k] = v end
		end
		
		configTable.Changed = Signal.new();
		configTable.ConfigTable = configTable;
		
		local self = setmetatable(configTable, CWeldConfig);

		return self;
	end


	return CWeldConfig;

end)
