local CurveKeyFrame = {};
CurveKeyFrame.__index = CurveKeyFrame;


function CurveKeyFrame.new(Int)
	local self = setmetatable({

		Int = Int,
		Tweens = {},
		TweenTable = {}

	}, CurveKeyFrame);

	return self;
end


return CurveKeyFrame;