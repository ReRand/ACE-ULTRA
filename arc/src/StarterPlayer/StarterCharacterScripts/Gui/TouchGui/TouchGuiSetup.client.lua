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

--[[

local ctg = playerGui:WaitForChild("CoolTouchGui")
ctg.Left.Enabled = false;
ctg.Right.Enabled = false;

local gui = workspace:FindFirstChild("PlayerTouchGuiInstance") or Instance.new("Folder", workspace);
gui.Name = "PlayerTouchGuiInstance";



local rightFrame = gui:FindFirstChild("RightAdorneePart") or workspace.CoolGui:WaitForChild("RightAdorneePart"):Clone()
local leftFrame = gui:FindFirstChild("LeftAdorneePart") or workspace.CoolGui:WaitForChild("LeftAdorneePart"):Clone()


rightFrame.Parent = gui;
leftFrame.Parent = gui;


local rightSurface = playerGui:FindFirstChild("CoolGui"):FindFirstChild("Right")
local leftSurface = playerGui:FindFirstChild("CoolGui"):FindFirstChild("Left")


rightSurface.Adornee = rightFrame;
leftSurface.Adornee = leftFrame;


local camera = workspace.CurrentCamera
local xRatio = camera.ViewportSize.X/camera.ViewportSize.Y
local yRatio = camera.ViewportSize.Y/camera.ViewportSize.X


local leftOffset = Vector3.new(
	-0.3, --horizontal scale
	-2.5, --how far down or up it is
	10 --depth
)

local rightOffset = Vector3.new(
	0.1, --horizontal scale
	0, --how far down or up it is
	8 --depth
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

local rad = math.rad;

local rightRotOffset = Vector3.new(0, -20, 0)
local leftRotOffset = Vector3.new(0, 20, 0)

local rightCalculatedRot = CFrame.Angles(rad(rightRotOffset.X), rad(rightRotOffset.Y), rad(rightRotOffset.Z))
local leftCalculatedRot = CFrame.Angles(rad(leftRotOffset.X), rad(leftRotOffset.Y), rad(leftRotOffset.Z))

local rs = game:GetService("RunService");

rs.RenderStepped:Connect(function()
	local newRightCFrame = camera.CFrame * CFrame.new(rightCalculatedOffset) * rightCalculatedRot
	local newLeftCFrame = camera.CFrame * CFrame.new(leftCalculatedOffset) * leftCalculatedRot

	if rightFrame then
		rightFrame.CFrame = rightFrame.CFrame:Lerp(newRightCFrame, 1/1.15)
	end

	if leftFrame then
		leftFrame.CFrame = leftFrame.CFrame:Lerp(newLeftCFrame, 1/1.15)
	end
end)


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

		for _, g in pairs(leftSurface:GetDescendants()) do

			if g:IsA("Frame") and g.Name == "BoxFrame" then
				g.BackgroundColor3 = colors.bg.Value;
				g.BorderColor3 = colors.border.Value;
				g.BackgroundTransparency = colors.transparency.Value;

			elseif g:IsA("TextLabel") and (not g:FindFirstChild("ignore") or (g:FindFirstChild("ignore") and not g.ignore.Value)) then
				g.TextColor3 = colors.text.Value;

				if colors:FindFirstChild("stroke") then
					g.TextStrokeColor3 = colors.text.Value;
					g.TextStrokeTransparency = 0;
				else
					g.TextStrokeTransparency = 1;
				end
			end

		end

		for _, g in pairs(rightSurface:GetDescendants()) do

			if g:IsA("Frame") and g.Name == "BoxFrame" then
				g.BackgroundColor3 = colors.bg.Value;
				g.BorderColor3 = colors.border.Value;
				g.BackgroundTransparency = colors.transparency.Value;

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
end
]]