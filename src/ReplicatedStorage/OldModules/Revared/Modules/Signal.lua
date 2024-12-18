local Signal = {}
Signal.__index = Signal

local HttpService = game:GetService("HttpService");


function shallow(t)
	local t2 = {}
	for k,v in pairs(t) do
		t2[k] = v
	end
	return t2
end



function Signal.new()
	local self = setmetatable({
		
		_bindableEvent = Instance.new("BindableEvent"),
		_cooldown = false,
		_queue = {}
		
	}, Signal)


	return self
end



function Signal:Fire(...)
	local args = {...}
	
	coroutine.wrap(function()
		repeat task.wait() until self._cooldown == false;

		local queueId = HttpService:GenerateGUID(false);

		self:__addqueued(queueId, table.unpack(args));

		self._bindableEvent:Fire(queueId);
	end)();
	
end



function Signal:Connect(handler)
	if not (type(handler) == "function") then error(("connect(%s)"):format(typeof(handler)), 2) end
	
	return self._bindableEvent.Event:Connect(function(queueId)
		coroutine.wrap(function()
			repeat task.wait() until self._cooldown == false;

			local queueData = self._queue[queueId];
			local args = queueData.args;
			local count = queueData.count;

			handler(unpack(args, 1, count));

			self._cooldown = true;

			task.delay(1/1000, function()
				self._cooldown = false;
				self:__remqueued(queueId);
			end);
		end)();
	end);
end



function Signal:Wait()
	coroutine.wrap(function()
		local queueId = self._bindableEvent.Event:Wait();

		local queueData = self._queue[queueId];
		local args = queueData.args;
		local count = queueData.count;

		assert(args, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.");

		local stuff = unpack(args, 1, count);

		self:__remqueued(queueId);

		return stuff;
	end)();
end



function Signal:Destroy()
	if self._bindableEvent then self._bindableEvent:Destroy(); self._bindableEvent = nil end
	self._queue = nil;
end



function Signal:__addqueued(queueId, ...)
	self._queue[queueId] = {
		args = {...},
		argCount = select("#", ...)
	};
end


function Signal:__remqueued(queueId)
	self._queue[queueId] = nil;
end



return Signal