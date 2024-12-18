--[[

TouchResult is what's returned from the TouchGenius events if the RawResults param is not true
- SideTouched is a NormalId
- State is a UserInputState


]]


local Revared = _G.Revared;


local TouchResult = {};
TouchResult.__index = TouchResult;



function TouchResult.new(touchGenius, hit, state)
	local part = touchGenius.Part;
	
	
	local partSurfaces = {
		[Enum.NormalId.Back] = part.CFrame * CFrame.new(0, 0, part.Size.Z);
		[Enum.NormalId.Front] = part.CFrame * CFrame.new(0, 0, -part.Size.Z);
		[Enum.NormalId.Top] = part.CFrame * CFrame.new(0, part.Size.Y, 0);
		[Enum.NormalId.Bottom] = part.CFrame * CFrame.new(0, -part.Size.Y, 0);
		[Enum.NormalId.Right] = part.CFrame * CFrame.new(part.Size.X, 0, 0);
		[Enum.NormalId.Left] = part.CFrame * CFrame.new(-part.Size.X, 0, 0);
	}
	
	local hitSurfaces = {
		[Enum.NormalId.Back] = hit.CFrame * CFrame.new(0, 0, hit.Size.Z);
		[Enum.NormalId.Front] = hit.CFrame * CFrame.new(0, 0, -hit.Size.Z);
		[Enum.NormalId.Top] = hit.CFrame * CFrame.new(0, hit.Size.Y, 0);
		[Enum.NormalId.Bottom] = hit.CFrame * CFrame.new(0, -hit.Size.Y, 0);
		[Enum.NormalId.Right] = hit.CFrame * CFrame.new(hit.Size.X, 0, 0);
		[Enum.NormalId.Left] = hit.CFrame * CFrame.new(-hit.Size.X, 0, 0);
	}
	
	local partSurface = Enum.NormalId.Front;
	local hitSurface = Enum.NormalId.Front;
	
	
	for side, cframe in pairs(partSurfaces) do
		partSurface = ((hit.Position - cframe.p).Magnitude > (hit.Position - partSurfaces[partSurface].p).Magnitude and partSurface or side)
	end
	
	
	for side, cframe in pairs(hitSurfaces) do
		hitSurface = ((part.Position - cframe.p).Magnitude > (part.Position - hitSurfaces[hitSurface].p).Magnitude and hitSurface or side)
	end
	
	
	
	local distance = (part.Position - hit.Position).Magnitude
	local player = nil;
	local human = nil;
	local character = nil;
	
	local g = game;
	
	if touchGenius.TouchParams.PlayerCheck or touchGenius.TouchParams.HumanCheck then
		pcall(function()
			for _, d in pairs(Revared:GetDirectoryOf(hit)) do
				g = g:FindFirstChild(d);

				if touchGenius.TouchParams.HumanCheck then
					if g and g:FindFirstChild("Humanoid") then
						character = g
						human = g:FindFirstChild("Humanoid");
					end
				end

				if touchGenius.TouchParams.PlayerCheck then
					if g and game.Players:GetPlayerFromCharacter(g) then
						player = game.Players:GetPlayerFromCharacter(g)
					end
				end
			end
		end)
	end
	
	
	local self = setmetatable({
		Instance = hit,
		Distance = distance,
		
		Position = hit.Position,
		Rotation = hit.Rotation,
		CFrame = hit.CFrame,
		
		Player = player,
		Character = character,
		Humanoid = human,
		
		SideTouched = partSurface,
		HitSideTouched = hitSurface,
		Normal = Vector3.new(),
		Material = hit.Material,
		
		TouchGenius = touchGenius,
		
		TouchState = state
		
	}, TouchResult);
	
	
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = { hit, part };
	params.FilterType = Enum.RaycastFilterType.Include;


	local direction = (hit.Position - part.Position).Unit;
	local result = workspace:Raycast(part.Position, direction*10, params)
	self.Raycast = result;


	if result then
		self.Distance = result.Distance;
		self.Normal = result.Normal;
	end
	
	
	return self;
end




return TouchResult;