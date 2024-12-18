--if _G.TitleEffect then return _G.TitleEffect end;

local TitleEffect = {}


local lighting = game:GetService("Lighting");
local ts = game:GetService("TweenService");

local effect = lighting.TitleEffect;
local base = lighting.ColorCorrection;


local titleAttr = {
	Contrast = effect.Contrast,
	Saturation = effect.Saturation,
	TintColor = effect.TintColor
}

local ccc = nil;

if not lighting:FindFirstChild("ColorCorrectionCopy") then
	ccc = base:Clone();
	ccc.Parent = lighting;
	ccc.Enabled = false
	ccc.Name = "ColorCorrectionCopy";
else
	ccc = lighting:FindFirstChild("ColorCorrectionCopy");
end


local baseAttr = {
	Contrast = ccc.Contrast,
	Saturation = ccc.Saturation,
	TintColor = ccc.TintColor
}




local enable = ts:Create(lighting.ColorCorrection, TweenInfo.new(0), titleAttr)
local fadeout = ts:Create(lighting.ColorCorrection, TweenInfo.new(0.3), baseAttr)



function TitleEffect:Enable()
	local tween = ts:Create(lighting.ColorCorrection, TweenInfo.new(0), titleAttr)
	tween:Play();
	return tween;
end


function TitleEffect:Disable()
	local tween = ts:Create(lighting.ColorCorrection, TweenInfo.new(0), baseAttr)
	tween:Play();
	return tween;
end


function TitleEffect:FadeIn(t)
	local tween = ts:Create(lighting.ColorCorrection, TweenInfo.new(t), titleAttr)
	tween:Play();
	return tween;
end


function TitleEffect:FadeOut(t)
	local tween = ts:Create(lighting.ColorCorrection, TweenInfo.new(t), baseAttr)
	tween:Play();
	return tween;
end



--_G.TitleEffect = TitleEffect;
return TitleEffect