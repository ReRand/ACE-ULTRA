repeat task.wait() until game:IsLoaded();

local camera = workspace.CurrentCamera

local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local music = script.music:GetChildren()
local ding = script.ding

local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("valuesLoaded");

local loaded = player.loaded;

player.PlayerGui:WaitForChild("LoaderGui").Enabled = true

local colors = game.Lighting.ColorCorrection
colors.Brightness = -1


-- player.CameraMode = Enum.CameraMode.Classic
camera.CameraType = Enum.CameraType.Scriptable


local song = music[math.random(1, #music)]

local songLabel = player.PlayerGui.LoaderGui.song;
local authorLabel = player.PlayerGui.LoaderGui.author;

songLabel.Text = '"'..song.Name..'"';
authorLabel.Text = song.author.Value;

if song.Name == "The Song That Plays in the Level Colloquially Known as 4-S" then
	songLabel.TextScaled = false;
	songLabel.Size = UDim2.fromScale(1, 0.046);
	songLabel.TextXAlignment = Enum.TextXAlignment.Left
end

song:Play();


loaded.Changed:Connect(function()
	
	local info1 = TweenInfo.new(1, Enum.EasingStyle.Linear)
	local info2 = TweenInfo.new(3, Enum.EasingStyle.Linear)


	for _, child in pairs(player.PlayerGui.LoaderGui:GetDescendants()) do
		if not not child.ClassName:match("Label$") or not not child.ClassName:match("Button$") then

			if child.ClassName == "TextLabel" then
				TweenService:Create(child, info1, { TextTransparency = 1 }):Play()

			elseif child.ClassName == "ImageLabel" then
				TweenService:Create(child, info1, { ImageTransparency = 1 }):Play()
				TweenService:Create(child, info2, { BackgroundTransparency = 1 }):Play()
				
			elseif child.ClassName == "TextButton" then
				TweenService:Create(child, info1, { 
					TextTransparency = 1,
					BackgroundTransparency = 1
					
				}):Play()
			end

		end
	end


	TweenService:Create(song, info1, { Volume = 0 }):Play();


	ding:Play()


	local final = TweenService:Create(colors, info2, { Brightness = 0 });
	
	final.Completed:Connect(function()
		player.PlayerGui.LoaderGui:Destroy()
	end);
	
	final:Play();
end)