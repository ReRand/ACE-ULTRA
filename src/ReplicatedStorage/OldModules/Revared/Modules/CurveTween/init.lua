--[[


local ct1 = CurveTween.new(Part, CurveTweenInfo.new(1), {
	
});



local ct2 = CurveTween.new(Part, TweenInfo.new(1), {
	
});



local ct3 = CurveTween.new(Part, CurveTweenInfo.new(1, 50), {
	
});



]]


local Signal = require(script.Parent.Signal);


local function Lerp(a, b, c)
	return a + (b - a) * c
end


local function QuadBezier (StartPosition, MidPosition, EndPosition, Offset)
	local L1 = Lerp(StartPosition, MidPosition, Offset)
	local L2 = Lerp(MidPosition, EndPosition, Offset)
	local QuadBezier = Lerp(L1, L2, Offset)

	return QuadBezier
end

local CurveTweenInfo = require(script.CurveTweenInfo);
local CurveKeyFrame = require(script.CurveKeyFrame);
local types = require(script.Types);

local ts = game:GetService("TweenService");


local CurveTween = {};
CurveTween.__index = CurveTween;


function CurveTween.new(Inst, Info: CurveTweenInfo | TweenInfo, TweenTable)

	local OriginPoints = {};
	local Magnitudes = {};
	local MidPoints = {};


	if typeof(Info) == "TweenInfo" then
		Info = CurveTweenInfo.new(Info);
	end
	
	
	for k, y in pairs(TweenTable) do
		local x = Inst[k];
		
		OriginPoints[k] = x;

		for _, t in pairs(types) do
			local name = t["Name"];
			local mag = t["Magnitude"];
			local mid = t["MidPoint"];

			if typeof(x) == name then
				
				local magnitude = mag(x, y);
				Magnitudes[k] = magnitude;
				
				local midpoint = mid(magnitude, x, y);
				MidPoints[k] = midpoint;
				
				break;
			end
		end
	end


	local self = setmetatable({
		
		Instance = Inst,
		Info = Info,
		TweenTable = TweenTable,
		MidPoints = MidPoints,
		Magnitudes = Magnitudes,
		OriginPoints = OriginPoints,
		
		
		IsPlaying = false,
		IsPaused = false,
		IsCancelled = false,
		
		
		CancelTweens = {},
		Tweens = {},
		
		
		KeyFrameNumber = 1;
		KeyFrame = nil,
		LastKeyFrame = nil,
		KeyFrames = {},
		

		KeyFrameStart = Signal.new(),
		KeyFrameEnd = Signal.new(),
		Completed = Signal.new(),
		Cancelled = Signal.new(),
		Paused = Signal.new(),
		UnPaused = Signal.new()

	}, CurveTween);


	return self;
end



function CurveTween:Play()
	self.IsPlaying = true;
	
	if self.IsCancelled then
		for k, v in pairs(self.CancelTweens) do
			v:Pause();
		end
	end
	
	
	if self.IsPaused then
		self.UnPaused:Fire(self.KeyFrame);
		
		coroutine.wrap(function()
			while self.IsPlaying and self.KeyFrameNumber <= self.Info.KeyFrameCount do
				
				for _, t in pairs(self.KeyFrame.Tweens) do
					local t: Tween = t;
					t:Play();
				end


				self.KeyFrame.Tweens[1].Completed:Wait();


				for _, t in pairs(self.KeyFrame.Tweens) do
					t.Completed:Wait(); break;
				end


				if self.KeyFrameNumber >= self.Info.KeyFrameCount then
					self.Completed:Fire(self.KeyFrame);
					return
				end
				
				self.KeyFrameNumber += 1;
			end
		end)();
		
	else
		
		coroutine.wrap(function()
			while self.IsPlaying and self.KeyFrameNumber <= self.Info.KeyFrameCount do
				self.LastKeyFrame = self.KeyFrame;
				
				
				if not self.KeyFrames[self.KeyFrameNumber] then
					self.KeyFrame = CurveKeyFrame.new(self.KeyFrameNumber);
					self.KeyFrames[self.KeyFrameNumber] = self.KeyFrame;
				end
				
				
				for k, to in pairs(self.TweenTable) do
					local origin = self.OriginPoints[k];
					local midpoint = self.MidPoints[k];

					local curve = QuadBezier(origin, midpoint, to, (self.KeyFrame.Int / self.Info.KeyFrameCount));
					
					self.KeyFrame.TweenTable[k] = curve;

					local tween = ts:Create(self.Instance, TweenInfo.new(self.Info.Time / self.Info.KeyFrameCount), {
						[k] = curve
					});
					
					table.insert(self.Tweens, tween)
					
					self.KeyFrame.Tweens[k] = tween;
				end
				
				
				self.KeyFrameStart:Fire(self.KeyFrame);
				
				
				for k, t in pairs(self.KeyFrame.Tweens) do
					-- print('should be playing tween for '..k);
					t:Play();
				end
				
				for _, t in pairs(self.KeyFrame.Tweens) do
					t.Completed:Wait(); break;
				end
				
				
				self.KeyFrameEnd:Fire(self.KeyFrame);
				

				if self.KeyFrameNumber >= self.Info.KeyFrameCount then
					
					self.Completed:Fire(self.KeyFrame);
					return
				end
				
				self.KeyFrameNumber += 1;
			end
		end)();
	end
	
	self.IsPaused = false;
	self.IsCancelled = false;
end



function CurveTween:Pause()
	self.IsPaused = true;
	self.IsCancelled = false;
	
	for _, t in pairs(self.KeyFrame.Tweens) do
		t:Pause();
	end
	
	if self.IsPlaying == true then
		self.Paused:Fire(self.KeyFrame);
	end
	
	self.IsPlaying = false;
end



function CurveTween:Cancel(fadeTime)
	
	if not fadeTime then
		fadeTime = 0;
	end
	
	
	if self.IsPlaying == true then
		self.Cancelled:Fire(self.KeyFrame);
	end
	
	self.IsPlaying = false;
	self.IsPaused = false;
	self.IsCancelled = true;
	
	
	local tween: Tween = self.KeyFrame.Tween;
	tween:Cancel();
	
	
	self.KeyFrame = CurveKeyFrame.new(0, nil, self.TweenTable);
	self.LastKeyFrame = nil;
	
	
	for k in pairs(self.TweenTable) do
		local t = ts:Create(self.Part, TweenInfo.new(fadeTime), {
			[k] = self.OriginPoints[k]
		});
		
		self.CancelTweens[k] = t;
		
		t:Play();
	end
	
	return self.CancelTweens;
end



function CurveTween:Destroy()
	self.IsPlaying = false;
	self.IsPaused = false;
	self.IsCancelled = false;
	
	for k, t in pairs(self.Tweens) do
		t:Destroy();
	end
end



return CurveTween;