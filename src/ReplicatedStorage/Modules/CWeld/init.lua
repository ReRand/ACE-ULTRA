--[[


	==< CWeld Module >==
		By shysolocup
		
		
			==< CWeld >==
				• if needed you are able to change the camera and config of the CWeld without issue
			
			
				CWeld.new(part: Instance, camera: Camera, config: CWeldConfig)
					• part is the instance you want to attach to the camera
					• camera is the camera you want to attach the part to
					• config is optional and if not given a config will be created automatically
				
				
				CWeld:Activate()
					• activates the CWeld locking it to the camera
					• if the CWeld is banished it will relock it but it will lerp its way there
					• if you don't want it to lerp use CWeld:Unbanish();
				
				
				CWeld:Deactivate()
					• deactivates the CWeld unlocking it from the camera but keeping it in place
				
				
				CWeld:Banish()
					• unlocks and instantly banishes the CWeld to 0, 0, 0
					• used primarily if you want to store the CWeld for later and then enable it
				
				
				CWeld:Snap()
					• instantly teleports the CWeld from banishment or wherever back to the camera
					• used for quick returns
					
					
				CWeld.GetActive()
					• lists all currently active CWelds	
					
					
				CWeld.GetDeactive()
					• lists all currently deactive CWelds
					
					
				CWeld.GetBanished()
					• lists all currently banished CWelds
					
					
				CWeld.GetUnbanished()
					• lists all currently unbanished CWelds
					
					
				CWeld.ActivateBulk(list: table)
					• activates all CWelds in the list
					• if list is not given it activates all CWelds
					
				
				CWeld.DeactivateBulk(list: table)
					• deactivates all CWelds in the list
					• if list is not given it deactivates all CWelds
					
					
				CWeld.UnbanishBulk(list: table)
					• unbanishes all CWelds in the list
					• if list is not given it unbanishes all CWelds
					
					
				CWeld.BanishBulk(list: table)
					• banishes all CWelds in the list
					• if list is not given it banishes all CWelds
					
					
				CWeld.ChangeCamera(camera: Camera)
					• changes the CWeld's camera
					• although you can just change the camera manually using CWeld.Camera I'd advise using this
					• this is also for the most part untested so if you find any bugs with it tell me pls
					
					
				CWeld:RefreshVP(x, y)
					• refreshes the camera's viewport with optional x and y values if you want to manually change them
					
				
				CWeld:RefreshMaths()
					• refreshes math stuff for the config
					• usually is only ran when something in the CWeld or CWeldConfig is changed
					• can be run manually with no problem if you need it to update for whatever reason
					
					
					
					
			==< CWeldConfig >==
				• options for the CWeld that better let you customize how it works
				
				
				options:
					AutoSize (def true): if it should autosize to the camera's viewport size,
					D (def 10): distance from the camera,
					X (def 0): position on the x axis,
					Y (def 0): position on the y axis,
					DPosOffset (def 0): separate position offset value for distance if you need to offset it,
					XPosOffset = (def 0): separate position offset value for x if you need to offset it,
					YPosOffset = (def 0): separate position offset value for y if you need to offset it,
					XRotOffset = (def 0): separate rotation offset value for x if you need to offset it,
					YRotOffset = (def 0): separate rotation value for y if you need to offset it,
					ZRotOffset = (def 0): separate rotation offset value for z if you need to offset it,
					Rotation = (def (0, 0, 0)): rotation as a vector3
					LerpStep = (def 1/1.1): how much it should lerp movement,
					Debug = (def false): if it should print out when something happens
				
			
				CWeldConfig.new(configTable)
					• if no configTable is given it will create a CWeldConfig with the default configs
					
					
				CWeld.Changed
					• signal that fires if something in the config is altered
					


]]



--< Setup >--

local CWeld = {}
CWeld.__index = CWeld;

if not _G.CWelds then
	_G.CWelds = {};
end



--< Imports >--

local CWeldConfig = require(script.CWeldConfig)(CWeld);
CWeld.CWeldConfig = CWeldConfig;


local Signal = require(workspace.Modules.Signal);
local rs = game:GetService("RunService");




function CWeld.new(part: Instance, camera: Camera, config: CWeldConfig)
	if not config then
		config = CWeldConfig.new();
	end
	
	
	if not camera then
		camera = workspace.CurrentCamera;
	end
	
	
	local self = setmetatable({
		
		Part = part,
		
		Config = config,
		
		Active = false,
		Banished = false
		
	}, CWeld);
	
	
	self.Id = tostring(self):gsub("table: ", "");
	_G.CWelds[self.Id] = self;
	
	
	self:ChangeCamera(camera);
	
	
	self:RefreshVP();
	
	
	self.Config.Changed:Connect(function(name, old, new)
		if ({ 
			
			-- base stuff
			"D", "X", "Y", 
			"Rotation", 
			
			-- pos offsets
			"DPosOffset", 
			"XPosOffset", 
			"YPosOffset", 
			
			-- rot offsets
			"XRotOffset",
			"YRotOffset",
			"ZRotOffset"
			
			
		})[name] then
			self:RefreshMaths();
		end
	end)
	
	
	return self;
end


function CWeld:Activate()
	self.Active = true;	
	self.Banished = false;
	
	
	self:RefreshVP();
	self:RefreshMaths();
	
	
	rs:BindToRenderStep("CWeld."..self.Id, Enum.RenderPriority.Camera.Value, function()
		if self.Active then
			
			local cf = self.Camera.CFrame * CFrame.new(self.cOffset) * self.cRot;
			local cflerp = self.Part.CFrame:Lerp(cf, self.Config.LerpStep)
			
			self.Part.CFrame = cflerp;
			
		else
			rs:UnbindFromRenderStep("CWeld."..self.Id);
		end
	end)
	
	if self.Config.Debug then
		print('activated cweld.'..self.Id);
	end
end



function CWeld:Deactivate()
	self.Active = false;
	rs:UnbindFromRenderStep("CWeld."..self.Id);
	
	if self.Config.Debug then
		print('deactivated cweld.'..self.Id);
	end
end



local function lerp(a: number, b: number, t: number)
	return a + (b - a) * t;
end



function CWeld:Snap()
	local origin = self.Config.LerpStep;
	self.Banished = false;

	self.Config.LerpStep = 1/1;

	self:Activate();

	coroutine.wrap(function()
		repeat task.wait() until self.Active;

		self.Config.LerpStep = origin;
	end)()
	
	if self.Config.Debug then
		print('unbanished and activated cweld.'..self.Id);
	end
end



function CWeld:Banish()
	local origin = self.Config.LerpStep;
	self.Banished = true;

	self.Config.LerpStep = 1/1;
	self:Deactivate();

	self.Part:PivotTo(CFrame.new(0, 0, 0));

	coroutine.wrap(function()
		repeat task.wait() until not self.Active;

		self.Config.LerpStep = origin;
	end)()
	
	if self.Config.Debug then
		print('banished and deactivated cweld.'..self.Id);
	end	
end



function CWeld:RefreshVP(x, y)
	if self.Config.Debug then
		print('refreshed viewport size for cweld.'..self.Id);
	end
	self.VpSize = { X = x or self.Camera.ViewportSize.X, Y = y or self.Camera.ViewportSize.Y };
end



function CWeld:RefreshMaths()
	if self.Config.Debug then
		print('refreshed math for cweld.'..self.Id);
	end


	rawset(self, "cVect", Vector3.new(self.Config.X + self.Config.XPosOffset, self.Config.Y + self.Config.YPosOffset, self.Config.D + self.Config.DPosOffset))


	rawset(self, "xRatio", self.VpSize.X/self.VpSize.Y);
	rawset(self, "yRatio", self.VpSize.Y/self.VpSize.X);


	rawset(self, "cOffset", Vector3.new(
		self.cVect.X * self.xRatio,
		self.cVect.Y * self.yRatio,
		-self.cVect.Z
		));


	rawset(self, "cRot", CFrame.Angles(math.rad(self.Config.Rotation.X + self.Config.XRotOffset), math.rad(self.Config.Rotation.Y + self.Config.YRotOffset), math.rad(self.Config.Rotation.Z + self.Config.ZRotOffset)));


	rawset(self, "bases", {
		cRot = self.cRot,
		cOffset = self.cOffset
	});
end



function CWeld:ChangeCamera(camera: Camera)
	if self.Config.Debug then
		print('changed camera for cweld.'..self.Id);
	end

	rawset(self, "Camera", camera);

	self.VpSize = self:RefreshVP();

	self.Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		if not self.Camera or self.Camera == camera then
			self:RefreshVP();
		end
	end)
end



function CWeld:__index(k)
	if rawget(self, k) then
		return rawget(self, k);

	elseif rawget(CWeld, k) then
		return rawget(CWeld, k);

	elseif k == "Vector3" or k == "Position" then
		return Vector3.new(self.Config.X + self.Config.Y, self.Config.D)

	elseif k == "CFrame" then
		local pos = Vector3.new(self.Config.X + self.Config.Y, self.Config.D)
		return CFrame.new(pos, self.Rotation);

	elseif k == "Offset" then
		return Vector3.new(self.Config.XPosOffset + self.Config.YPosOffset, self.Config.DPosOffset)

	elseif k == "OffsetRotation" then
		return Vector3.new(self.Config.XRotOffset + self.Config.YRotOffset, self.Config.ZRotOffset)

	elseif k == "OffsetCFrame" then
		return CFrame.new(Vector3.new(self.Config.XPosOffset + self.Config.YPosOffset, self.Config.DPosOffset), Vector3.new(self.Config.XRotOffset + self.Config.YRotOffset, self.Config.ZRotOffset))
	end
end



function CWeld:__newindex(k, v)
	if rawget(self, k) then
		rawset(self, k, v);

	elseif rawget(CWeld, k) then
		rawset(CWeld, k, v);


	elseif k == "Vector3" or k == "Position" then

		if typeof(v) == "CFrame" then
			v = v.Position;
		end

		self.Config.X = v.X;
		self.Config.Y = v.Y;
		self.Config.D = pcall(function() return v.D end) and v.D or v.Z;


	elseif k == "CFrame" then
		local rx, ry, rz = v:ToOrientation()
		local rot = Vector3.new(math.deg(rx), math.deg(ry), math.deg(rz));
		local pos = v.Position;

		self.Config.X = pos.X;
		self.Config.Y = pos.Y;
		self.Config.D = pcall(function() return pos.D end) and pos.D or pos.Z;

		self.Config.Rotation = Vector3.new(rot.X, rot.Y, rot.Z);


	elseif k == "Offset" then
		if typeof(v) == "CFrame" then
			v = v.Position;
		end

		self.Config.XPosOffset = v.X;
		self.Config.YPosOffset = v.Y;
		self.Config.DPosOffset = pcall(function() return v.D end) and v.D or v.Z;


	elseif k == "OffsetRotation" then
		if typeof(v) == "CFrame" then
			local rx, ry, rz = v:ToOrientation()
			local v = Vector3.new(math.deg(rx), math.deg(ry), math.deg(rz));
		end

		self.Config.XRotOffset = v.X;
		self.Config.YRotOffset = v.Y;
		self.Config.ZRotOffset = v.Z;


	elseif k == "OffsetCFrame" then
		local rx, ry, rz = v:ToOrientation()
		local rot = Vector3.new(math.deg(rx), math.deg(ry), math.deg(rz));
		local pos = v.Position;

		self.Config.XPosOffset = pos.X;
		self.Config.YPosOffset = pos.Y;
		self.Config.DPosOffset = pcall(function() return pos.D end) and pos.D or pos.Z;

		self.Config.XRotOffset = rot.X;
		self.Config.YRotOffset = rot.Y;
		self.Config.ZRotOffset = rot.Z;
	end


	if k == "Camera" then
		self:ChangeCamera(v);

	else
		rawset(self, k, v);

		if ({ "VpSize", "cVect", "xRatio", "yRatio", "cOffset", "cRot", "bases" })[k] then
			self:RefreshMaths();
		end
	end

end



function CWeld.DeactivateBulk(list)
	for _, cw in list or _G.CWelds do
		cw:Deactivate();
	end
end


function CWeld.ActivateBulk(list)
	for _, cw in list or _G.CWelds do
		cw:Activate();
	end
end



function CWeld.UnbanishBulk(list)
	for _, cw in list or _G.CWelds do
		cw:Unbanish();
	end
end


function CWeld.BanishBulk(list)
	for _, cw in list or _G.CWelds do
		cw:Banish();
	end
end


function CWeld.GetDeactive()
	local list = {};
	for _, cw in _G.CWelds do
		if not cw.Active then
			table.insert(list, cw);
		end
	end
	return list;
end


function CWeld.GetActive()
	local list = {};
	for _, cw in _G.CWelds do
		if cw.Active then
			table.insert(list, cw);
		end
	end
	return list;
end



function CWeld.GetUnbanished()
	local list = {};
	for _, cw in _G.CWelds do
		if not cw.Banished then
			table.insert(list, cw);
		end
	end
	return list;
end


function CWeld.GetBanished()
	local list = {};
	for _, cw in _G.CWelds do
		if cw.Banished then
			table.insert(list, cw);
		end
	end
	return list;
end



return CWeld