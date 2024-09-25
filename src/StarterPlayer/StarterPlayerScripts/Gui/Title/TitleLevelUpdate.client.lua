local player = game.Players.LocalPlayer;

local level = player:WaitForChild("level");
local curexp = player:WaitForChild("currentExp");
local reqexp = player:WaitForChild("requiredExp");

local ts = game:GetService("TweenService");

repeat task.wait() until player:WaitForChild("loaded").Value

local gui = player.PlayerGui:WaitForChild("CoolTitleGui"):WaitForChild("Left"):WaitForChild("Surf"):WaitForChild("Frame"):WaitForChild("level");
local startgui = game.StarterGui:WaitForChild("CoolTitleGui"):WaitForChild("Left"):WaitForChild("Surf"):WaitForChild("Frame"):WaitForChild("level");

local baseLevelSize = gui.level.TextSize;
local baseLevelColor = gui.level.TextColor3;
local baseLevelStrokeColor = gui.level.TextStrokeColor3;
local baseLevelStrokeTransparency = gui.level.TextStrokeTransparency;

local amount = gui:WaitForChild("amount");
local levelt = gui:WaitForChild("level");
local outof = gui:WaitForChild("outof");

local startamount = startgui:WaitForChild("amount");
local startlevelt = startgui:WaitForChild("level");
local startoutof = startgui:WaitForChild("outof");


function format(n)
	local i, j, minus, int, fraction = tostring(n):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction
end


function split(input, sep)
	if sep == nil then
		sep = "%s"
	end
	
	local t = {}
	for str in string.gmatch(input, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	
	return t
end


local function GetReqCur()
	return reqexp.Value, curexp.Value;
end


local function Update()
	
	local gui = player.PlayerGui:WaitForChild("CoolTitleGui"):WaitForChild("Left"):WaitForChild("Surf"):WaitForChild("Frame"):WaitForChild("level");
	local startgui = game.StarterGui:WaitForChild("CoolTitleGui"):WaitForChild("Left"):WaitForChild("Surf"):WaitForChild("Frame"):WaitForChild("level");

	local amount = gui:WaitForChild("amount");
	local levelt = gui:WaitForChild("level");
	local outof = gui:WaitForChild("outof");

	local startamount = startgui:WaitForChild("amount");
	local startlevelt = startgui:WaitForChild("level");
	local startoutof = startgui:WaitForChild("outof");
	
	print('level updated on menu')
	
	local req, cur = GetReqCur();
	
	local size = (cur)/(req);
	
	startamount.Size = UDim2.new(size, amount.Size.X.Offset, amount.Size.Y.Scale, amount.Size.Y.Offset)
	startlevelt.Text = format(math.round(level.Value))
	startoutof.Text = format(cur).."/"..format(req)

	local tt = 0.5;
	

	local amountTween = ts:Create(amount, TweenInfo.new(tt, Enum.EasingStyle.Cubic), {
		Size = UDim2.new(size, amount.Size.X.Offset, amount.Size.Y.Scale, amount.Size.Y.Offset)
	});
	
	
	outof.Text = format(cur).."/"..format(req)


	local levelTweenIn = ts:Create(levelt, TweenInfo.new(tt == 0 and 0.1 or tt-0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextSize = 50,
		Rotation = 10,
		TextColor3 = Color3.fromRGB(200, 175, 255),
		TextStrokeColor3 = Color3.fromRGB(136, 0, 255),
		TextStrokeTransparency = 0
	});
	
	local levelTweenOut = ts:Create(levelt, TweenInfo.new(tt == 0 and 0.1 or tt+0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextSize = baseLevelSize,
		Rotation = 0,
		TextColor3 = baseLevelColor,
		TextStrokeColor3 = baseLevelStrokeColor,
		TextStrokeTransparency = baseLevelStrokeTransparency
	});
	
	levelTweenIn.Completed:Connect(function()
		levelTweenOut:Play();
	end)

	if curexp.Value >= reqexp.Value then
		amountTween.Completed:Connect(function()
			levelTweenIn:Play();
			levelt.Text = format(math.round(level.Value))
			startoutof.Text = format(cur).."/"..format(req)
		end)
	else
		levelt.Text = format(math.round(level.Value))
		startoutof.Text = format(cur).."/"..format(req)
		outof.Text = format(cur).."/"..format(req)
	end
	
	amountTween:Play();
end

curexp.Changed:Connect(Update);
-- reqexp.Changed:Connect(Update);

Update();

local req, cur = GetReqCur();

outof.Text = format(cur).."/"..format(req)

Update();