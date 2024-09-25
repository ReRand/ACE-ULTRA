local camera = workspace.CurrentCamera

local player = game.Players.LocalPlayer;
local playerGui = player.PlayerGui;
local character = player.Character or player.CharacterAdded:Wait();

repeat task.wait() until script;
repeat task.wait() until game:IsLoaded();

repeat task.wait() until script.Parent;


local ContextActionService = game:GetService("ContextActionService")
local uis = game:GetService("UserInputService");
local ts = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Revared = require(workspace.Modules.Revared);
local ContentProvider = game:GetService("ContentProvider")


local PlayerModule = require(player.PlayerScripts:WaitForChild('PlayerModule'))
local te = require(script.Parent.Parent.Parent.Modules.TitleEffect);
local controls = PlayerModule:GetControls()


local humanoid = character:WaitForChild("Humanoid");


local loaded = player.loaded;
local spawned = player.spawned;


if not spawned.Value then
	humanoid.JumpPower = 0;
end


repeat task.wait() until loaded.Value


local teams = player.PlayerGui.CoolTitleGui.Left.Surf.Frame.buttons.playButton.teams;


local red = teams.red.redTeamButton;
local blue = teams.blue.blueTeamButton;


local specTeam = game.Teams.Spectator;
local redTeam = game.Teams.Red;
local blueTeam = game.Teams.Blue;

local basejp = game.StarterPlayer.CharacterJumpPower;



local function Switch(team)
	print(player.mapLocallyLoaded.Value);
	if player.mapLocallyLoaded.Value then
		
		humanoid.JumpHeight = basejp

		ContextActionService:UnbindAction("freezeMovement")
		StarterGui:SetCore("ResetButtonCallback", true)
		camera.CameraType = Enum.CameraType.Custom

		-- player.PlayerGui.CoolTitleGui.ScreenGui.Enabled = false;

		player.TeamColor = team.TeamColor;

		player.spawned.Value = true;
		player.menu.Value = false;

		te:FadeOut(0.3);
	end
end


red.Activated:Connect(function()
	Switch(redTeam);
end)
blue.Activated:Connect(function()
	Switch(blueTeam)
end)


local label = player.PlayerGui.CoolTitleGui.Left.Surf.Frame.buttons.playButton.loaded;
local plabel = player.PlayerGui.CoolTitleGui.Left.Surf.Frame.buttons.playButton.playtext;

local baseSize = plabel.TextSize;
local baseTT = label.TextTransparency;

plabel.TextYAlignment = Enum.TextYAlignment.Center

label.TextTransparency = 1
plabel.TextSize = 45


local freezeLoading = false;


uis.WindowFocusReleased:Connect(function()
	freezeLoading = true;
end)

uis.WindowFocused:Connect(function()
	freezeLoading = false;
end)


local function Reload()
	
	for _, sound in pairs(game.ReplicatedStorage.GameSounds:GetDescendants()) do
		if sound:IsA("Sound") then
			sound:Stop();
		end
	end
	
	red.Parent.lock.Visible = true;
	blue.Parent.lock.Visible = true;

	local parts = {};
	local loadedParts = 0;

	local mapV = workspace.GlobalValues.Game.map;

	local percent = math.round((loadedParts/#parts)*100);
	if tostring(percent) == "nan" then percent = 0; end

	label.Text = "Loading ("..percent.."%)";
	
	
	local started = workspace.GlobalValues.Game.started;
	
	repeat task.wait() until started.Value;
	
	plabel.TextYAlignment = Enum.TextYAlignment.Top

	ts:Create(label, TweenInfo.new(0.2), {
		TextTransparency = baseTT
	}):Play();

	ts:Create(plabel, TweenInfo.new(0.5), {
		TextSize = baseSize
	}):Play();
	
	task.wait(1);

	repeat task.wait() until mapV.Value;
	local map = mapV.Value;

	while #parts <= 0 do 
		for _, p in pairs(map[map.Name]:GetDescendants()) do
			if p:IsA("Part") or p:IsA("MeshPart") or p:IsA("UnionOperation") then
				table.insert(parts, p);
			end
		end

		task.wait()
	end


	local swait = 0;
	local maxSwait = map:FindFirstChild("maxSwait") and map.maxSwait.Value or 3;


	for i, part in ipairs(parts) do 
		local success = pcall(function()
			ContentProvider:PreloadAsync({part});
			
			repeat task.wait() until not freezeLoading
			
			if swait == maxSwait then
				wait();
				swait = 0
			else
				swait += 1
			end


			loadedParts += 1

			local percent = math.round((loadedParts/#parts)*100);

			label.Text = "Loading ("..percent.."%)";
		end)

		if not success then
			warn(Revared:GetDirectoryOf(part).." failed to load")
		end
	end
	
	task.delay(0.1, function()
		player.mapLocallyLoaded.Value = true;

		red.Parent.lock.Visible = false;
		blue.Parent.lock.Visible = false;

		plabel.TextYAlignment = Enum.TextYAlignment.Center

		ts:Create(label, TweenInfo.new(0.2), {
			TextTransparency = 1
		}):Play();

		ts:Create(plabel, TweenInfo.new(0.5), {
			TextSize = 45
		}):Play();
	end)
end


game.ReplicatedStorage.GameEvents:WaitForChild("OnMenuReload").Event:Connect(Reload)



if not spawned.Value then
	
	te:Enable();
	
	camera.CameraType = Enum.CameraType.Scriptable

	local ocp = workspace.GameRoundMap:WaitForChild("OverviewCameraPart")

	local reloc = game.ReplicatedStorage.GameEvents:WaitForChild("OnBootReloc")

	reloc.OnClientEvent:Connect(function(cf, ppos)
		camera.CFrame = cf

		character:MoveTo(ppos);

		local spwn = game.ReplicatedStorage.GameEvents:WaitForChild("OnPlaySpawn");

		if not player.menu.Value and not player.mapLoaded.Value then

			Reload()

		else
			plabel.TextYAlignment = Enum.TextYAlignment.Center

			ts:Create(label, TweenInfo.new(0.2), {
				TextTransparency = 1
			}):Play();

			ts:Create(plabel, TweenInfo.new(0.5), {
				TextSize = 45
			}):Play();
		end


		-- workspace.LoaderSpawner.Enabled = false;

		player.mapLoaded.Value = true;


		if not player.menu.Value then
			player.Team = specTeam;

			player.spawned.Value = false;
			player.menu.Value = true;
		end


		repeat task.wait() until spawned.Value


		spwn:FireServer()
	end)

	reloc:FireServer()
end