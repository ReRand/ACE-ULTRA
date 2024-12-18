repeat task.wait() until game:IsLoaded();


local player = game.Players.LocalPlayer

repeat task.wait() until player:WaitForChild("valuesLoaded").Value

local loaded = player.loaded;

repeat task.wait() until loaded.Value;
repeat task.wait() until player.spawned.Value;


local Values = require(workspace.Modules.Values);

local playerGui = player.PlayerGui

local character = player.Character or player.CharacterAdded:Wait()

local ts = game:GetService("TweenService");

local ctg = playerGui:WaitForChild("CoolTitleGui")
ctg.Left.Enabled = false;
ctg.Right.Enabled = false;

local gui = workspace:FindFirstChild("PlayerGuiInstance") or Instance.new("Folder", workspace);
gui.Name = "PlayerGuiInstance";


local rightFrame = gui:FindFirstChild("RightAdorneePart") or workspace.CoolGui:WaitForChild("RightAdorneePart"):Clone()
local leftFrame = gui:FindFirstChild("LeftAdorneePart") or workspace.CoolGui:WaitForChild("LeftAdorneePart"):Clone()
local midFrame = gui:FindFirstChild("MiddleAdorneePart") or workspace.CoolGui:WaitForChild("MiddleAdorneePart"):Clone()
local eFrame = gui:FindFirstChild("EmoteAdorneePart") or workspace.CoolGui:WaitForChild("EmoteAdorneePart"):Clone()
local fFrame = gui:FindFirstChild("FeedAdorneePart") or workspace.CoolGui:WaitForChild("FeedAdorneePart"):Clone()

rightFrame.Parent = gui;
leftFrame.Parent = gui;
midFrame.Parent = gui;
eFrame.Parent = gui;
fFrame.Parent = gui;

local emotesMenuOpen = Values:Fetch("emotesMenuOpen")


local rightSurface = playerGui:FindFirstChild("CoolGui"):FindFirstChild("Right")
local leftSurface = playerGui:FindFirstChild("CoolGui"):FindFirstChild("Left")
local midSurface = playerGui:FindFirstChild("CoolGui"):FindFirstChild("Middle")
local fSurface = playerGui:FindFirstChild("CoolGui"):FindFirstChild("KillFeed")


for _, e in pairs(player.PlayerGui.EmoteWheel:GetChildren()) do
	pcall(function()
		e.Enabled = false;
		e.Adornee = eFrame:FindFirstChild(e.Adornee.Name);
	end)
end

for _, e in pairs(player.PlayerGui.EmoteWheel.Emotes:GetChildren()) do
	pcall(function()
		e.Enabled = false;
		e.Adornee = eFrame:FindFirstChild(e.Adornee.Name);
	end)
end


midSurface.Enabled = false;
midSurface.Active = false;


rightSurface.Adornee = rightFrame;
leftSurface.Adornee = leftFrame;
midSurface.Adornee = midFrame;
fSurface.Adornee = fFrame;


local camera = workspace.CurrentCamera;

local CWeld = require(script.Parent.Parent.Parent.Modules.CWeld);
local CWeldConfig = CWeld.CWeldConfig;


local leftConfig = CWeldConfig.new({
	X = -1, --horizontal scale
	Y = -2, --how far down or up it is
	D = 12, --depth
	LerpStep = 1/1.15,
	Rotation = Vector3.new(0, 30, 0)
});

local rightConfig = CWeldConfig.new({
	X = 2, --horizontal scale
	Y = 2, --how far down or up it is
	D = 11, --depth
	LerpStep = 1/1.15,
	Rotation = Vector3.new(0, -30, 0)
});

local midConfig = CWeldConfig.new({
	X = 0, --horizontal scale
	Y = 15, --how far down or up it is
	D = 13, --depth
	LerpStep = 1/1.15,
	Rotation = Vector3.new(0, 0, 0)
});

local eConfig = CWeldConfig.new({
	X = 0, --horizontal scale
	Y = 2, --how far down or up it is
	D = 7, --depth
	LerpStep = 1/1.15,
	Rotation = Vector3.new(0, 0, 0)
});

local fConfig = CWeldConfig.new({
	X = 0, --horizontal scale
	Y = 3, --how far down or up it is
	D = 8, --depth
	LerpStep = 1/1.15,
	Rotation = Vector3.new(0, 10, 0)
});


local left = CWeld.new(leftFrame, camera, leftConfig);
local right = CWeld.new(rightFrame, camera, rightConfig);
local mid = CWeld.new(midFrame, camera, midConfig);
local e = CWeld.new(eFrame, camera, eConfig);
local f = CWeld.new(fFrame, camera, fConfig);


local cwelds = {
	left, right, mid, e, f
};


local rs = game:GetService("RunService");
local offset = player:WaitForChild("uiOffset");

rs.RenderStepped:Connect(function()
	for i, cw in ipairs(cwelds) do
		cw.OffsetCFrame = offset.Value;
	end
end)


for i, cw in ipairs(cwelds) do
	cw:Activate();
end


--[[
local xRatio = camera.ViewportSize.X/camera.ViewportSize.Y
local yRatio = camera.ViewportSize.Y/camera.ViewportSize.X


local leftOffset = Vector3.new(
	-1, --horizontal scale
	-2, --how far down or up it is
	12 --depth
)

local rightOffset = Vector3.new(
	2, --horizontal scale
	2, --how far down or up it is
	11 --depth
)

local midOffset = Vector3.new(
	0, --horizontal scale
	15, --how far down or up it is
	13 --depth
)


local eOffset = Vector3.new(
	0, --horizontal scale
	2, --how far down or up it is
	7 --depth
)

local rightCalculatedOffset = Vector3.new(
	rightOffset.X * xRatio,
	rightOffset.Y * yRatio,
	-rightOffset.Z
)

local leftCalculatedOffset = Vector3.new(
	leftOffset.X * xRatio,
	leftOffset.Y * yRatio,
	-leftOffset.Z
)

local midCalculatedOffset = Vector3.new(
	midOffset.X * xRatio,
	midOffset.Y * yRatio,
	-midOffset.Z
)

local eCalculatedOffset = Vector3.new(
	eOffset.X * xRatio,
	eOffset.Y * yRatio,
	-eOffset.Z
)

local rad = math.rad;

local rightRotOffset = Vector3.new(0, -30, 0)
local leftRotOffset = Vector3.new(0, 30, 0)
local midRotOffset = Vector3.new(0, 0, 0)
local eRotOffset = Vector3.new(0, 0, 0)

local rightCalculatedRot = CFrame.Angles(rad(rightRotOffset.X), rad(rightRotOffset.Y), rad(rightRotOffset.Z))
local leftCalculatedRot = CFrame.Angles(rad(leftRotOffset.X), rad(leftRotOffset.Y), rad(leftRotOffset.Z))
local midCalculatedRot = CFrame.Angles(rad(midRotOffset.X), rad(midRotOffset.Y), rad(midRotOffset.Z))
local eCalculatedRot = CFrame.Angles(rad(eRotOffset.X), rad(eRotOffset.Y), rad(eRotOffset.Z))

local rs = game:GetService("RunService");

rs.RenderStepped:Connect(function()
	local newRightCFrame = camera.CFrame * CFrame.new(rightCalculatedOffset) * rightCalculatedRot
	local newLeftCFrame = camera.CFrame * CFrame.new(leftCalculatedOffset) * leftCalculatedRot
	local newMidCFrame = camera.CFrame * CFrame.new(midCalculatedOffset) * midCalculatedRot
	local newEmoteCFrame = camera.CFrame * CFrame.new(eCalculatedOffset) * eCalculatedRot

	if rightFrame then
		rightFrame.CFrame = rightFrame.CFrame:Lerp(newRightCFrame, 1/1.15)
	end
	
	if leftFrame then
		leftFrame.CFrame = leftFrame.CFrame:Lerp(newLeftCFrame, 1/1.15)
	end
	
	if midFrame then
		midFrame.CFrame = midFrame.CFrame:Lerp(newMidCFrame, 1/1.15)
	end
	
	if eFrame then
		eFrame.CFrame = eFrame.CFrame:Lerp(newEmoteCFrame, 1/1.15)
	end
end)
]]

local function GetTeam(color)
	for _, team in pairs(game.Teams:GetTeams()) do
		if team.TeamColor == color then return team end;
	end
end


local lighting = game.Lighting;


if player.TeamColor then
	
	local team = GetTeam(player.TeamColor);
	
	if player.TeamColor == game.Teams["MARKED FOR DEATH"].TeamColor then
		lighting.MFDEffect.Enabled = true;
	else
		lighting.MFDEffect.Enabled = false;
	end
	
	local colors = workspace.TeamColorGuiValues:FindFirstChild(team.Name);

	if colors then
		
		local function Filter(g)
			for _, g in pairs(g:GetDescendants()) do

				if g:IsA("Frame") and string.match(g.Name, "BoxFrame") then
					
					local tmod = 0;
					
					if g:FindFirstChild("transparency") then
						tmod = g.transparency.Value;
					end
					
					g.BackgroundColor3 = colors.bg.Value;
					g.BorderColor3 = colors.border.Value;
					
					if g:FindFirstChild("UIStroke") then
						g.UIStroke.Color = colors.border.Value;
						g.UIStroke.Transparency = colors.transparency.Value + tmod/2;
					end
					
					g.BackgroundTransparency = colors.transparency.Value + tmod;

				elseif g:IsA("TextLabel") and (not g:FindFirstChild("ignore") or (g:FindFirstChild("ignore") and not g.ignore.Value)) then
					g.TextColor3 = colors.text.Value;

					if colors:FindFirstChild("stroke") then
						g.TextStrokeColor3 = colors.text.Value;
						g.TextStrokeTransparency = 0
					else
						g.TextStrokeTransparency = 1;
					end
				end

			end
		end
		
		Filter(leftSurface);
		Filter(rightSurface);
		Filter(midSurface);
		
	end
end