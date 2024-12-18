--[[


TouchGenius is a better version of the basic touch events for 3d objects


- Touched and TouchEnded
Touched and TouchEnded works more reliably now but if you wish to use the old ones there's the DefaultTouched and DefaultTouchEnded events


- Player and Humanoid
there are a few different events for players and humanoids like PlayerTouched/PlayerTouchEnded and HumanTouched/HumanTouchEnded
checks for player and humanoid can also be toggled using TouchParams (TouchParams.PlayerCheck and TouchParams.HumanCheck)


- RawResults
RawResults is an option in TouchParams (TouchParams.RawResult) that decides if it should return a TouchResult or a normal Instance, by default it's false


- DefaulTouched and DefaultTouchEnded
DefaultTouched and DefaultTouchEnded still uses TouchResult but they work on the old roblox systems for the two



Example:

	local Revared = require(workspace.Modules.Revared)
	local TouchGenius = Revared:GetModule("TouchGenius");
	local part = script.Parent;
	
	
	local tg = TouchGenius.new(part);
	
	
	tg.Touched:Connect(function(res)
		print(res.Instance);
	end);
	
	
	tg.TouchEnded:Connect(function(res)
		print(res.Instance);
	end);


]]


local Revared = _G.Revared;
local RBXScriptSignal = Revared:GetModule("Signal");


local TouchResult = require(script.TouchResult);



local TouchGenius = {
	TouchResult = TouchResult,
	
	TouchFilterTypes = {
		Include = Enum.RaycastFilterType.Include,
		Exclude = Enum.RaycastFilterType.Exclude
	},
	
	TouchStates = {
		TouchBegin = Enum.UserInputState.Begin,
		TouchEnd = Enum.UserInputState.End,
		TouchMaintain = Enum.UserInputState.Change,
		None = Enum.UserInputState.None
	}
};

TouchGenius.__index = TouchGenius;



local TouchParams = require(script.TouchParams)(TouchGenius);
TouchGenius.TouchParams = TouchParams;



function TouchGenius.new(part: Instance, touchParams: TouchParams)
	if not touchParams then touchParams = TouchParams.new(); end
	
	
	local self = setmetatable({
		
		Part = part,
		TouchParams = touchParams,
		
		DefaultTouched = RBXScriptSignal.new(),
		DefaultTouchEnded = RBXScriptSignal.new(),
		DefaultPlayerTouched = RBXScriptSignal.new(),
		DefaultPlayerTouchEnded = RBXScriptSignal.new(),
		DefaultHumanTouched = RBXScriptSignal.new(),
		DefaultHumanTouchEnded = RBXScriptSignal.new(),
		DefaultObjectTouched = RBXScriptSignal.new(),
		DefaultObjectTouchEnded = RBXScriptSignal.new(),
		
		
		Touched = RBXScriptSignal.new(),
		TouchEnded = RBXScriptSignal.new(),
		PlayerTouched = RBXScriptSignal.new(),
		PlayerTouchEnded = RBXScriptSignal.new(),
		HumanTouched = RBXScriptSignal.new(),
		HumanTouchEnded = RBXScriptSignal.new(),
		ObjectTouched = RBXScriptSignal.new(),
		ObjectTouchEnded = RBXScriptSignal.new(),
		
		
		--[[TouchMaintained = RBXScriptSignal.new(),
		PlayerTouchMaintained = RBXScriptSignal.new(),
		HumanTouchMaintained = RBXScriptSignal.new(),
		ObjectTouchMaintained = RBXScriptSignal.new(),]]
		
		AsyncWaiting = {},
		
		SiftsInstances = {},
		Sifts = touchParams.Sifts
		
		
	}, TouchGenius);
	
	
	
	part.Touched:Connect(function(hit)
		coroutine.wrap(function()
			local origin = hit
			local player = nil;
			local human = nil;

			if self:IsFiltered(origin, self.TouchParams.TouchFilter, self.TouchParams.TouchFilterType) then return end;
			if #self.Sifts > 0 and not self:IsSifted(origin) then return end;

			if not self.TouchParams.RawResults then
				hit = self:CreateTouchResult(origin, TouchGenius.TouchStates.TouchBegin);

				self.DefaultTouched:Fire(hit, origin, TouchGenius.TouchStates.TouchBegin);
				
				if hit.Humanoid then
					human = hit.Humanoid
					self.DefaultHumanTouched:Fire(hit, origin, TouchGenius.TouchStates.TouchBegin);
				end
				
				if hit.Player then
					player = hit.Player;
					self.DefaultPlayerTouched:Fire(hit, origin, TouchGenius.TouchStates.TouchBegin);
				end
				
				if not hit.Humanoid and not hit.Player then
					self.DefaultObjectTouched:Fire(hit, origin, TouchGenius.TouchStates.TouchBegin);
				end
			else
				self.DefaultTouched:Fire(origin, TouchGenius.TouchStates.TouchBegin);
			end


			if not self:IsAsyncWaiting(origin) then
				coroutine.wrap(function()
					
					coroutine.wrap(function()
						if not self.TouchParams.RawResults then
							self.Touched:Fire(hit, origin, TouchGenius.TouchStates.TouchBegin);
							
							if human then
								human = hit.Humanoid;
								self.HumanTouched:Fire(hit, origin, TouchGenius.TouchStates.TouchBegin);
							end

							if player then
								player = hit.Player;
								self.PlayerTouched:Fire(hit, origin, TouchGenius.TouchStates.TouchBegin);
							end
							
							if not human and not player then
								self.ObjectTouched:Fire(hit, origin, TouchGenius.TouchStates.TouchBegin);
							end
						else
							self.Touched:Fire(origin, TouchGenius.TouchStates.TouchBegin);
						end
					end)()
					
					
					table.insert(self.AsyncWaiting, origin);
					
					
					origin.Destroying:Connect(function()
						coroutine.wrap(function()
							
							coroutine.wrap(function()
								if not self.TouchParams.RawResults then
									hit = self:CreateTouchResult(origin, TouchGenius.TouchStates.TouchEnd);
									self.TouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchEnd);
									
									if human then
										human = hit.Humanoid;
										self.HumanTouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchEnd);
									end

									if player then
										player = hit.Player;
										self.PlayerTouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchEnd);
									end
									
									if not human and not player then
										self.ObjectTouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchEnd);
									end
								else
									self.TouchEnded:Fire(origin, TouchGenius.TouchStates.TouchEnd);
								end
							end)()

							local _, i = self:IsAsyncWaiting(origin);

							table.remove(self.AsyncWaiting, i);

						end)()
					end)


					coroutine.wrap(function()

						repeat task.wait(self.TouchParams.AsyncWaitingLoopDelay or 0) until self:IsTouching(origin);
						repeat task.wait(self.TouchParams.AsyncWaitingLoopDelay or 0) until not self:IsTouching(origin);


						coroutine.wrap(function()
							if not self.TouchParams.RawResults then
								hit = self:CreateTouchResult(origin, TouchGenius.TouchStates.TouchEnd);
								self.TouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchEnd);
								
								if human then
									human = hit.Humanoid;
									self.HumanTouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchEnd);
								end

								if player then
									player = hit.Player;
									self.PlayerTouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchEnd);
								end
								
								if not human and not player then
									self.ObjectTouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchEnd);
								end
							else
								self.TouchEnded:Fire(origin, TouchGenius.TouchStates.TouchEnd);
							end
						end)()

						local _, i = self:IsAsyncWaiting(origin);

						table.remove(self.AsyncWaiting, i);

					end)()
				end)()
			end
		end)()
	end);
	
	
	
	part.TouchEnded:Connect(function(hit)
		coroutine.wrap(function()
			local origin = hit

			if self:IsFiltered(origin, self.TouchParams.TouchFilter, self.TouchParams.TouchFilterType) then return end;
			if #self.Sifts > 0 and not self:IsSifted(origin) then return end;

			if not self.TouchParams.RawResults then
				hit = self:CreateTouchResult(origin, TouchGenius.TouchStates.TouchEnd);
				
				if hit.Humanoid then
					self.DefaultHumanTouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchBegin);
				end

				if hit.Player then
					self.DefaultPlayerTouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchBegin);
				end

				if not hit.Humanoid and not hit.Player then
					self.DefaultObjectTouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchBegin);
				end
				
				self.DefaultTouchEnded:Fire(hit, origin, TouchGenius.TouchStates.TouchEnd);
			else
				self.DefaultTouchEnded:Fire(origin, TouchGenius.TouchStates.TouchEnd);
			end
			
		end)();
	end)
	
	
	
	--[[if self.TouchParams.Maintain then
		coroutine.wrap(function()
			while task.wait(self.TouchParams.MaintainLoopDelay or 0) do
				if self.TouchParams.Maintain then
					for i, p in ipairs(self:GetTouchingParts()) do
						
						if self.TouchParams.RawResults then
							self.TouchMaintained:Fire(p, TouchGenius.TouchStates.TouchMaintain);
						else
							self.TouchMaintained:Fire(p, p.Instance, TouchGenius.TouchStates.TouchMaintain);
							
							if p.Humanoid then
								self.HumanTouchMaintained:Fire(p, p.Instance, TouchGenius.TouchStates.TouchMaintain);
							end

							if p.Player then
								self.PlayerTouchMaintained:Fire(p, p.Instance, TouchGenius.TouchStates.TouchMaintain);
							end
						end
					end
				end
			end
		end)();
	end]]
	
	
	return self;
end



function TouchGenius:IsTouching(part, filter)
	for i, p in ipairs(self:GetInstanceTouchingParts(filter)) do
		if p == part then return true, i; end
	end
	return false, -1;
end



function TouchGenius:IsAsyncWaiting(part)
	for i, p in ipairs(self.AsyncWaiting) do
		if p == part then return true, i; end
	end
	return false, -1;
end



function TouchGenius:GetTouchingParts(filter, filterType)
	local touching = self:GetInstanceTouchingParts(filter, filterType);
	
	if not self.TouchParams.RawResults then
		for i, t in ipairs(touching) do
			touching[i] = self:CreateTouchResult(t, TouchGenius.TouchStates.TouchMaintain);
		end
	end
	
	return touching;
end



function TouchGenius:GetInstanceTouchingParts(filter, filterType)
	if not filter then filter = self.TouchParams.MaintainFilter; end
	if not filterType then filterType = self.TouchParams.MaintainFilterType end
	local touching = self.Part:GetTouchingParts();


	for i_t, t in ipairs(touching) do
		if self:IsFiltered(t, filter, filterType) then
			table.remove(touching, i_t);
		end
	end
	

	return touching;
end



function TouchGenius:GetRawTouchingParts()
	return self.Part:GetTouchingParts();
end



function TouchGenius:CreateTouchResult(part, state)
	return TouchResult.new(self, part, state);
end



function TouchGenius:Sift(...)
	local tg = TouchGenius.new(self.Part, self.TouchParams);
	tg.Sifts = {...};
	
	table.insert(self.SiftsInstances, tg);
	
	return tg;
end



function TouchGenius.sift(part, params, ...)
	local tg = TouchGenius.new(part, params);
	tg.Sifts = {...};
	return tg;
end



function TouchGenius:IsSifted(part)
	for _, f in pairs(self.Sifts) do
		if f == part.Name then
			return true;
		end
	end
	
	return false;
end



function TouchGenius:IsFiltered(part, filter, filterType)
	local dir = Revared:GetDirectoryOf(part);
	local g = game;

	for _, d in pairs(dir) do
		g = g:FindFirstChild(d);

		for _, f in pairs(filter) do
			if (f == g and filterType == TouchGenius.TouchFilterTypes.Exclude) or (f ~= g and filterType == TouchGenius.TouchFilterTypes.Include) then
				return true;
			end
		end
	end
	
	return false;
end



return TouchGenius