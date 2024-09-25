

return (function(CWeld)

	local CWeldConfig = {};
	CWeldConfig.__index = CWeldConfig;


	function CWeldConfig.new(configTable)
		
		if not configTable then configTable = {} end;
		
		if not configTable.D then configTable.D = 10 end
		if not configTable.X then configTable.X = 0 end
		if not configTable.Y then configTable.Y = 0 end
		
		if not configTable.DPosOffset then configTable.DPosOffset = 0 end
		if not configTable.XPosOffset then configTable.XPosOffset = 0 end
		if not configTable.YPosOffset then configTable.YPosOffset = 0 end
		
		if not configTable.XRotOffset then configTable.XRotOffset = 0 end
		if not configTable.YRotOffset then configTable.YRotOffset = 0 end
		if not configTable.ZRotOffset then configTable.ZRotOffset = 0 end
		
		if not configTable.Rotation then configTable.Rotation = Vector3.new() end
		if not configTable.Delay then configTable.Delay = 0 end
		if not configTable.LerpStep then configTable.LerpStep = 1/1 end
		
		
		local self = setmetatable(configTable, CWeldConfig);

		self.ConfigTable = configTable;

		return self;
	end


	return CWeldConfig;

end)
