local player = game.Players.LocalPlayer;
local uis = game:GetService("UserInputService");
local rs = game:GetService("RunService");

repeat task.wait() until player:WaitForChild("loaded").Value

local color = player:WaitForChild("crosshairColor3");
local size = player:WaitForChild("crosshairSize");
local transparency = player:WaitForChild("crosshairTransparency");
local hold = player:WaitForChild("crosshairHold");


local function GetSettings()
	return player.PlayerGui.CoolTitleGui:WaitForChild("Middle"):WaitForChild("Surf"):WaitForChild("Settings"):WaitForChild("crosshair"):WaitForChild("settings");
end


local gui = GetSettings().Parent;


local crosshair = require(script.Parent.Parent.Parent.Modules.Crosshair);


-- colors
local colorsliders = GetSettings():WaitForChild("color"):WaitForChild("colorsliders");
local colorvalues = GetSettings():WaitForChild("color"):WaitForChild("colorvalues");

local redButton = colorsliders:WaitForChild("1red"):WaitForChild("buttonFrame"):WaitForChild("button");
local greenButton = colorsliders:WaitForChild("2green"):WaitForChild("buttonFrame"):WaitForChild("button");
local blueButton = colorsliders:WaitForChild("3blue"):WaitForChild("buttonFrame"):WaitForChild("button");


-- transparency
local transparencySliders = GetSettings():WaitForChild("transparency"):WaitForChild("sliders");
local transparencyValues = GetSettings():WaitForChild("transparency"):WaitForChild("values");

local transparencyButton = transparencySliders:WaitForChild("slider"):WaitForChild("buttonFrame"):WaitForChild("button");
local transparencyValue = transparencyValues:WaitForChild("value");


-- size
local sizeSliders = GetSettings():WaitForChild("size"):WaitForChild("sliders");
local sizeValues = GetSettings():WaitForChild("size"):WaitForChild("values");

local sizeButton = sizeSliders:WaitForChild("slider"):WaitForChild("buttonFrame"):WaitForChild("button");
local sizeValue = sizeValues:WaitForChild("value");


local redHold = false;
local greenHold = false;
local blueHold = false;

local transparencyHold = false;
local sizeHold = false;


local function snap(number, factor)
	if factor == 0 then
		return number
	else
		return math.floor(number/factor+0.5)*factor;
	end
end


local step = 0.01;

local cooldown = false;


local function GetPercent(button)
	local mousePos = uis:GetMouseLocation().X;

	local buttonPos = button.Position;
	local frameSize = button.Parent.AbsoluteSize.X;
	local framePos = button.Parent.AbsolutePosition.X;
	local pos = snap(( mousePos - framePos )/frameSize, step)

	local per = math.clamp((pos/2)-0.5, 0, 1)
	
	return per;
end


uis.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 --[[and Input.UserInputType == Enum.UserInputType.Touch]] then
		
		hold.Value = false;
		local ct = 0.3
		
		if redHold and not cooldown then
			color.Value = Color3.new(GetPercent(redButton)+0.00005, color.Value.G, color.Value.B);
			cooldown = true;
			
			task.delay(ct, function()
				cooldown = false;
			end)
		end
		
		if greenHold and not cooldown then
			color.Value = Color3.new(color.Value.R, GetPercent(greenButton)+0.00005, color.Value.B);
			cooldown = true;
			
			task.delay(ct, function()
				cooldown = false;
			end)
		end
		
		if blueHold and not cooldown then
			color.Value = Color3.new(color.Value.R, color.Value.G, GetPercent(blueButton)+0.00005);
			cooldown = true;
			
			task.delay(ct, function()
				cooldown = false;
			end)
		end
		
		if transparencyHold and not cooldown then
			transparency.Value = GetPercent(transparencyButton)+0.00005;
			cooldown = true;

			task.delay(ct, function()
				cooldown = false;
			end)
		end
		
		if sizeHold and not cooldown then
			size.Value = (GetPercent(sizeButton)*1.8)+0.00005;
			cooldown = true;

			task.delay(ct, function()
				cooldown = false;
			end)
		end
		
		redHold = false;
		greenHold = false;
		blueHold = false;
		transparencyHold = false;
		sizeHold = false;
	end
end)


redButton.MouseButton1Down:Connect(function()
	if cooldown then return end
	redHold = true;
	hold.Value = true;
end)

greenButton.MouseButton1Down:Connect(function()
	if cooldown then return end
	greenHold = true;
	hold.Value = true;
end)

blueButton.MouseButton1Down:Connect(function()
	if cooldown then return end
	blueHold = true;
	hold.Value = true;
end)


transparencyButton.MouseButton1Down:Connect(function()
	if cooldown then return end
	transparencyHold = true;
	hold.Value = true;
end)


sizeButton.MouseButton1Down:Connect(function()
	if cooldown then return end
	sizeHold = true;
	hold.Value = true;
end)


rs.RenderStepped:Connect(function()
	if redHold and not cooldown then
		color.Value = Color3.new(GetPercent(redButton), color.Value.G, color.Value.B);
		-- redButton.Position = UDim2.new(per, 0, redButton.Position.Y.Scale, redButton.Position.Y.Offset)
	end
	
	if greenHold and not cooldown then
		color.Value = Color3.new(color.Value.R, GetPercent(greenButton), color.Value.B);
		-- greenButton.Position = UDim2.new(per, 0, greenButton.Position.Y.Scale, greenButton.Position.Y.Offset)
	end
	
	if blueHold and not cooldown then
		color.Value = Color3.new(color.Value.R, color.Value.G, GetPercent(blueButton));
		-- blueButton.Position = UDim2.new(per, 0, blueButton.Position.Y.Scale, blueButton.Position.Y.Offset)
	end
	
	if transparencyHold and not cooldown then
		transparency.Value = GetPercent(transparencyButton);
	end
	
	if sizeHold and not cooldown then
		size.Value = (GetPercent(sizeButton)*1.8);
	end
end)