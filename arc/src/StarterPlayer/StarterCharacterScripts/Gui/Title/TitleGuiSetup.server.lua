repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer

repeat task.wait() until player:WaitForChild("valuesLoaded").Value

local loaded = player:WaitForChild("loaded");

repeat task.wait() until loaded.Value;

local playerGui = player.PlayerGui;

local Values = require(workspace.Modules.Values);

local unlock = Values:Fetch("unlockTitleGui");

-- local character = player.Character or player.CharacterAdded:Wait()

local ts = game:GetService("TweenService");

local gui = workspace:FindFirstChild("PlayerTitleGuiInstance") or Instance.new("Folder", workspace);
gui.Name = "PlayerTitleGuiInstance";

local rightFrame = gui:FindFirstChild("RightAdorneePart") or workspace.CoolTitleGui:WaitForChild("RightAdorneePart"):Clone()
local leftFrame = gui:FindFirstChild("LeftAdorneePart") or workspace.CoolTitleGui:WaitForChild("LeftAdorneePart"):Clone()
local midFrame = gui:FindFirstChild("MiddleAdorneePart") or workspace.CoolTitleGui:WaitForChild("MiddleAdorneePart"):Clone()
local logo = gui:FindFirstChild("Logo") or workspace.CoolTitleGui:WaitForChild("Logo"):Clone()

-- playerGui.CoolTitleGui.ScreenGui.Enabled = true;

rightFrame.Parent = gui;
leftFrame.Parent = gui;
midFrame.Parent = gui;
logo.Parent = gui;


local rightSurface = playerGui:FindFirstChild("CoolTitleGui"):FindFirstChild("Right")
local leftSurface = playerGui:FindFirstChild("CoolTitleGui"):FindFirstChild("Left")
local midSurface = playerGui:FindFirstChild("CoolTitleGui"):FindFirstChild("Middle")

rightSurface.Adornee = rightFrame;
leftSurface.Adornee = leftFrame;
midSurface.Adornee = midFrame;
logo.Weld.Part1 = leftFrame;
logo.Anchored = false;


local camera = workspace.CurrentCamera


local CWeld = require(script.Parent.Parent.Parent.Modules.CWeld);
local CWeldConfig = CWeld.CWeldConfig;


local leftConfig = CWeldConfig.new({
	X = 0.4, --horizontal scale
	Y = -0.3, --how far down or up it is
	D = 9, --depth
	LerpStep = 1/1.15,
	Rotation = Vector3.new(0, 5, 0)
});

local rightConfig = CWeldConfig.new({
	X = -0.3, --horizontal scale
	Y = 0.3, --how far down or up it is
	D = 10, --depth
	LerpStep = 1/1.15,
	Rotation = Vector3.new(0, -5, 0)
});

local midConfig = CWeldConfig.new({
	X = 0, --horizontal scale
	Y = -1, --how far down or up it is
	D = 7, --depth
	LerpStep = 1/1.15,
	Rotation = Vector3.new(0, 0, 0)
});


local left = CWeld.new(leftFrame, camera, leftConfig);
local right = CWeld.new(rightFrame, camera, rightConfig);
local mid = CWeld.new(midFrame, camera, midConfig);


local cwelds = {
	left, right, mid
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
	0.4, --horizontal scale
	-0.3, --how far down or up it is
	9 --depth
)

local rightOffset = Vector3.new(
	-0.3, --horizontal scale
	0.3, --how far down or up it is
	10 --depth
)

local midOffset = Vector3.new(
	0, --horizontal scale
	-1, --how far down or up it is
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

local rad = math.rad;

local rightRotOffset = Vector3.new(0, -5, 0)
local leftRotOffset = Vector3.new(0, 5, 0)
local midRotOffset = Vector3.new(0, 0, 0)

local rightCalculatedRot = CFrame.Angles(rad(rightRotOffset.X), rad(rightRotOffset.Y), rad(rightRotOffset.Z))
local leftCalculatedRot = CFrame.Angles(rad(leftRotOffset.X), rad(leftRotOffset.Y), rad(leftRotOffset.Z))
local midCalculatedRot = CFrame.Angles(rad(midRotOffset.X), rad(midRotOffset.Y), rad(midRotOffset.Z))


local rs = game:GetService("RunService");


rs.RenderStepped:Connect(function()
	local newRightCFrame = camera.CFrame * CFrame.new(rightCalculatedOffset) * rightCalculatedRot
	local newLeftCFrame = camera.CFrame * CFrame.new(leftCalculatedOffset) * leftCalculatedRot
	local newMidCFrame = camera.CFrame * CFrame.new(midCalculatedOffset) * midCalculatedRot
	
	if not unlock.Value then
		if rightFrame then
			rightFrame.CFrame = newRightCFrame
		end
		
		if leftFrame then
			leftFrame.CFrame = newLeftCFrame
		end
		
		if midFrame then
			midFrame.CFrame = midFrame.CFrame:Lerp(newMidCFrame, 1/1.15)
		end
	end
end)
]]