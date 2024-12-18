local CurveTweenInfo = {
	DefaultKeyFrameCount = 20;	
};
CurveTweenInfo.__index = CurveTweenInfo;



function CurveTweenInfo.new(Info: number | TweenInfo, ...)
	
	local self = setmetatable({}, CurveTweenInfo);
	local args = {...}
	
	if typeof(Info) == "TweenInfo" then
		self.Time = Info.Time;
		self.KeyFrameCount = CurveTweenInfo.DefaultKeyFrameCount;
		self.EasingStyle = Info.EasingStyle;
		self.RepeatCount = Info.RepeatCount;
		self.Reverses = Info.Reverses;
		self.DelayTime = Info.DelayTime;
	else
		self.Time = Info;
		self.KeyFrameCount = args.KeyFrameCount or CurveTweenInfo.DefaultKeyFrameCount;
		self.EasingStyle = args.EasingStyle;
		self.RepeatCount = args.RepeatCount;
		self.Reverses = args.Reverses;
		self.DelayTime = args.DelayTime;
	end
	
	return self;
end



return CurveTweenInfo;