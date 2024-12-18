local Crosshair = {}

local player = game.Players.LocalPlayer;

local color = player:WaitForChild("crosshairColor3");
local size = player:WaitForChild("crosshairSize");
local transparency = player:WaitForChild("crosshairTransparency");


local ts = game:GetService("TweenService");


local function round(exact, placement)
	return tonumber(string.format("%."..placement.."f", exact))
end


function Crosshair:GetSettings()
	return player.PlayerGui.CoolTitleGui:WaitForChild("Middle"):WaitForChild("Surf"):WaitForChild("Settings"):WaitForChild("crosshair"):WaitForChild("settings");
end


function Crosshair:GetNewSliderPosition(value, button)
	return UDim2.new(value, button.Position.X.Offset, button.Position.Y.Scale, button.Position.Y.Offset)
end


function Crosshair.UpdateColor()
	local crosshair = player.PlayerGui.ScreenGui:WaitForChild("crosshair");

	local gui = Crosshair:GetSettings().Parent;
	local showcaseCrosshair = gui:WaitForChild("showcase"):WaitForChild("crosshair")

	local sliders = Crosshair:GetSettings():WaitForChild("color"):WaitForChild("colorsliders");
	local values = Crosshair:GetSettings():WaitForChild("color"):WaitForChild("colorvalues");

	local redButton = sliders:WaitForChild("1red"):WaitForChild("buttonFrame"):WaitForChild("button");
	local greenButton = sliders:WaitForChild("2green"):WaitForChild("buttonFrame"):WaitForChild("button");
	local blueButton = sliders:WaitForChild("3blue"):WaitForChild("buttonFrame"):WaitForChild("button");

	local redValue = values:WaitForChild("1red");
	local greenValue = values:WaitForChild("2green");
	local blueValue = values:WaitForChild("3blue");

	redButton.Position = Crosshair:GetNewSliderPosition(color.Value.R, redButton);
	redValue.Text = math.round(color.Value.R*255)

	greenButton.Position = Crosshair:GetNewSliderPosition(color.Value.G, greenButton);
	greenValue.Text = math.round(color.Value.G*255)

	blueButton.Position = Crosshair:GetNewSliderPosition(color.Value.B, blueButton);
	blueValue.Text = math.round(color.Value.B*255)

	crosshair.img.ImageColor3 = color.Value;
	showcaseCrosshair.img.ImageColor3 = color.Value;

	print('crosshair color updated')
end



function Crosshair.UpdateTransparency()
	local crosshair = player.PlayerGui.ScreenGui:WaitForChild("crosshair");
	local gui = Crosshair:GetSettings().Parent;
	local showcaseCrosshair = gui:WaitForChild("showcase"):WaitForChild("crosshair")

	local sliders = Crosshair:GetSettings():WaitForChild("transparency"):WaitForChild("sliders");
	local values = Crosshair:GetSettings():WaitForChild("transparency"):WaitForChild("values");

	local button = sliders:WaitForChild("slider"):WaitForChild("buttonFrame"):WaitForChild("button");
	local value = values:WaitForChild("value");

	crosshair.img.ImageTransparency = transparency.Value;
	showcaseCrosshair.img.ImageTransparency = transparency.Value;

	button.Position = Crosshair:GetNewSliderPosition(transparency.Value, button);

	value.Text = round(transparency.Value*100, 2);

	print('crosshair transparency updated')
end



function Crosshair.UpdateSize()
	local crosshair = player.PlayerGui.ScreenGui:WaitForChild("crosshair");
	local gui = Crosshair:GetSettings().Parent;
	local showcaseCrosshair = gui:WaitForChild("showcase"):WaitForChild("crosshair")

	local sliders = Crosshair:GetSettings():WaitForChild("size"):WaitForChild("sliders");
	local values = Crosshair:GetSettings():WaitForChild("size"):WaitForChild("values");

	local button = sliders:WaitForChild("slider"):WaitForChild("buttonFrame"):WaitForChild("button");
	local value = values:WaitForChild("value");

	button.Position = Crosshair:GetNewSliderPosition( size.Value/2 , button);

	value.Text = round((size.Value*100)/2, 2);

	crosshair.img.UIScale.Scale = size.Value;
	showcaseCrosshair.img.UIScale.Scale = size.Value*2;

	print('crosshair size updated')
end


return Crosshair
