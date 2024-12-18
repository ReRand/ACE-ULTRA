local CWeld = {}
CWeld.__index = CWeld;

local CWeldConfig = require(script.CWeldConfig)(CWeld);
CWeld.CWeldConfig = CWeldConfig;

local Revared = _G.Revared;
local RBXScriptSignal = Revared:GetModule("Signal");

local Spring = require(script.Spring);

local rs = game:GetService("RunService");


function CWeld.__index(tbl, key)
	if rawget(tbl, key) then
		return rawget(tbl, key);
		
	elseif rawget(CWeld, key) then
		return rawget(CWeld, key);
		
	elseif key == "Vector3" or key == "Position" then
		return Vector3.new(tbl.Config.X + tbl.Config.Y, tbl.Config.D)
		
	elseif key == "CFrame" then
		local pos = Vector3.new(tbl.Config.X + tbl.Config.Y, tbl.Config.D)
		return CFrame.new(pos, tbl.Rotation);
		
	elseif key == "Offset" then
		return Vector3.new(tbl.Config.XPosOffset + tbl.Config.YPosOffset, tbl.Config.DPosOffset)
	
	elseif key == "OffsetRotation" then
		return Vector3.new(tbl.Config.XRotOffset + tbl.Config.YRotOffset, tbl.Config.ZRotOffset)
	
	elseif key == "OffsetCFrame" then
		return CFrame.new(Vector3.new(tbl.Config.XPosOffset + tbl.Config.YPosOffset, tbl.Config.DPosOffset), Vector3.new(tbl.Config.XRotOffset + tbl.Config.YRotOffset, tbl.Config.ZRotOffset))
	end
end


function CWeld.__newindex(tbl, key, value)
	if rawget(tbl, key) then
		rawset(tbl, key, value);
		
	elseif rawget(CWeld, key) then
		rawset(CWeld, key, value);
		
		
	elseif key == "Vector3" or key == "Position" then
		
		if typeof(value) == "CFrame" then
			value = value.Position;
		end
		
		tbl.Config.X = value.X;
		tbl.Config.Y = value.Y;
		tbl.Config.D = pcall(function() return value.D end) and value.D or value.Z;
		
		
	elseif key == "CFrame" then
		local rx, ry, rz = value:ToOrientation()
		local rot = Vector3.new(math.deg(rx), math.deg(ry), math.deg(rz));
		local pos = value.Position;

		tbl.Config.X = pos.X;
		tbl.Config.Y = pos.Y;
		tbl.Config.D = pcall(function() return pos.D end) and pos.D or pos.Z;

		tbl.Config.Rotation = Vector3.new(rot.X, rot.Y, rot.Z);
		
		
	elseif key == "Offset" then
		if typeof(value) == "CFrame" then
			value = value.Position;
		end

		tbl.Config.XPosOffset = value.X;
		tbl.Config.YPosOffset = value.Y;
		tbl.Config.DPosOffset = pcall(function() return value.D end) and value.D or value.Z;
	
	
	elseif key == "OffsetRotation" then
		if typeof(value) == "CFrame" then
			local rx, ry, rz = value:ToOrientation()
			local value = Vector3.new(math.deg(rx), math.deg(ry), math.deg(rz));
		end

		tbl.Config.XRotOffset = value.X;
		tbl.Config.YRotOffset = value.Y;
		tbl.Config.ZRotOffset = value.Z;
	
	
	elseif key == "OffsetCFrame" then
		local rx, ry, rz = value:ToOrientation()
		local rot = Vector3.new(math.deg(rx), math.deg(ry), math.deg(rz));
		local pos = value.Position;

		tbl.Config.XPosOffset = pos.X;
		tbl.Config.YPosOffset = pos.Y;
		tbl.Config.DPosOffset = pcall(function() return pos.D end) and pos.D or pos.Z;
		
		tbl.Config.XRotOffset = rot.X;
		tbl.Config.YRotOffset = rot.Y;
		tbl.Config.ZRotOffset = rot.Z;
	end
end


function CWeld.new(part: Instance, camera, config)
	if not config then
		config = CWeldConfig.new();
	end
	
	if not camera then
		camera = workspace.CurrentCamera;
	end
	
	
	local self = setmetatable({
		Part = part,
		Camera = camera,
		
		Config = config,
		
		Active = false,
		Locked = false,
		Enabled = false
		
	}, CWeld);
	
	
	rs.RenderStepped:Connect(function()
		if self.Active then

			local cVect = Vector3.new(self.Config.X + self.Config.XPosOffset, self.Config.Y + self.Config.YPosOffset, self.Config.D + self.Config.DPosOffset)

			local xRatio = self.Camera.ViewportSize.X/self.Camera.ViewportSize.Y
			local yRatio = self.Camera.ViewportSize.Y/self.Camera.ViewportSize.X

			local cOffset = Vector3.new(
				cVect.X * xRatio,
				cVect.Y * yRatio,
				-cVect.Z
			);

			local cRot = CFrame.Angles(math.rad(self.Config.Rotation.X + self.Config.XRotOffset), math.rad(self.Config.Rotation.Y + self.Config.YRotOffset), math.rad(self.Config.Rotation.Z + self.Config.ZRotOffset));


			local cf = self.Camera.CFrame * CFrame.new(cOffset) * cRot

			-- self.Part.CFrame = math.clamp(lerp(self.tilt, self.Part.CFrame.X * self.tiltZ, 0.1), -0.25, 0.1);

			-- local spring = Spring.new(self.Part.Mass, 1, 0.1, 0, self.Part.Velocity.Magnitude, cf )


			--[[local trx, try, trz = cf:ToOrientation()
			local targetRot = Vector3.new(math.deg(trx), math.deg(try), math.deg(trz));
			
			
			local orx, ory, orz = self.Part.CFrame:ToOrientation()
			local rot = Spring.new(Vector3.new(math.deg(orx), math.deg(ory), math.deg(orz)));
			
			
			local pos = Spring.new(self.Part.CFrame.Position);
			
			
			pos.Target = cf.Position;
			rot.Target = targetRot;
			
			self.Part.Position = pos.Position;
			self.Part.Rotation = rot.Position;]]

			--return;

			self.Part.CFrame = self.Part.CFrame:Lerp(cf, self.Config.LerpStep)

			-- task.wait(self.Config.Delay)
		end
	end)
	
	
	return self;
end


local function lerp(a: number, b: number, t: number)
	return a + (b - a) * t;
end


function CWeld:Activate()
	self.Active = true;
	self.Locked = true;
	self.Enabled = true;
end


function CWeld:Deactivate()
	self.Active = false;
end


function CWeld:Enable()
	local origin = self.Config.LerpStep;
	
	self.Config.LerpStep = 1/1;
	
	self:Activate();
	
	coroutine.wrap(function()
		repeat task.wait() until self.Active;

		print(origin);

		self.Config.LerpStep = origin;
	end)()
end


function CWeld:Disable()
	local origin = self.Config.LerpStep;
	
	self.Config.LerpStep = 1/1;
	self:Deactivate();

	self.Part:PivotTo(CFrame.new(0, 0, 0));
	
	coroutine.wrap(function()
		repeat task.wait() until not self.Active;
		
		print(origin);

		self.Config.LerpStep = origin;
	end)()
end


return CWeld