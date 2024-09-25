local player = game.Players.LocalPlayer;

repeat task.wait() until game:IsLoaded();
repeat task.wait() until player.spawned.Value;

local character = player.Character or player.CharacterAdded:Wait();
local players = game.Players;
local humanoid = character:WaitForChild("Humanoid");

local gui = player.PlayerGui.ScreenGui;
-- local text = gui.tip;
local background = gui.background;
local scanlines = gui.scanlines;

local camera = workspace.CurrentCamera;

local respawn = game.ReplicatedStorage.GameEvents:WaitForChild("OnDeathRespawn");
local rs = game.ReplicatedStorage.GameSounds:WaitForChild("RecordScratch");
local rs2 = game.ReplicatedStorage.GameSounds:WaitForChild("RecordScratch2");

local cas = game:GetService("ContextActionService");
local ts = game:GetService("TweenService");

local ignored = {};


local Values = require(workspace.Modules.Values);
local loaded = player.loaded;
local spawned = player.spawned;


-- local KillFeed = require(script.Parent.Modules.KillFeed);


local PlayerModule = require(player.PlayerScripts:WaitForChild('PlayerModule'))
local controls = PlayerModule:GetControls()


player.CharacterAdded:Connect(function()
	background.BackgroundTransparency = 0;
	
	player.killerHuman.Value = nil;
	player.assistHuman.Value = nil;
	
	ts:Create(background, TweenInfo.new(2), {
		BackgroundTransparency = 1;
	}):Play()

	ts:Create(scanlines, TweenInfo.new(2), {
		ImageTransparency = 1;
	}):Play()

	ignored = {};
	
	if loaded.Value and spawned.Value then
		controls:Enable()
	end
	
	local function isIgnored(part)
		for i, p in ipairs(ignored) do
			if p == part then return true end
		end
		return false;
	end

	for i,v in pairs(game:GetDescendants()) do 
		if v:IsA("BasePart") and not isIgnored(v) then
			v.Anchored = false
		end
	end
end)


humanoid.Died:Connect(function()
	-- KillFeed.KillItem.new(player);
	cas:UnbindAction("Menu");
	
	
	if player:FindFirstChild("killerHuman") and player.killerHuman.Value then
		camera.CameraSubject = player.killerHuman.Value;
		camera.CameraType = Enum.CameraType.Track;
	end
	
	
	
	local sounds = game.ReplicatedStorage.GameSounds;
	
	
	local function SoundFilter(sounds)
		for _, sound in pairs(sounds:GetChildren()) do
			if sound:IsA("Sound") then
				sound:Stop();
			elseif sound:IsA("Folder") then
				SoundFilter(sound);
			end
		end
	end
	
	
	SoundFilter(sounds);
	
	
	local song = workspace.GlobalValues.Game:WaitForChild("song").Value;
	
	
	if song then
		ts:Create(song, TweenInfo.new(2), {
			PlaybackSpeed = 0.1
		}):Play();
	end
	
	
	rs:Play();
	rs2:Play();


	task.wait(players.RespawnTime-0.1);


	camera.CameraType = Enum.CameraType.Custom


	if song then
		ts:Create(song, TweenInfo.new(2), {
			PlaybackSpeed = 1
		}):Play()
	end
	
	
	
	--[[local t1 = ts:Create(background, TweenInfo.new(2), {
		BackgroundTransparency = 0;
	})
	
	t1.Completed:Connect(function()]]
	--[[end)
	
	t1:Play()]]
	
	respawn:FireServer()
	
end)