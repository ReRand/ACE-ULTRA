--< Services >--
local camera = workspace.CurrentCamera
local players  = game:GetService("Players")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local Values = require(workspace.Modules.Values)
local lighting = game:GetService("Lighting")

local player = players.LocalPlayer;
local stat = player.stats;


--< Variables >--
local fullbright = false;
local firstperson = true;
local unlock = false;
local freecam = false;
local gui = true;

local onMobile = not uis.KeyboardEnabled
local keysDown = {}
local rotating = false

local speed = 5
local sens = .3

speed /= 10
if onMobile then sens*=2 end


repeat task.wait() until game:IsLoaded();

local baseAmbient = lighting.Ambient;
local baseBrightness = lighting.Brightness
local baseColorShiftTop = lighting.ColorShift_Top
local baseColorShiftBot = lighting.ColorShift_Bottom
local baseOutdoorAmbient = lighting.OutdoorAmbient
local baseEnvDiffScale = lighting.EnvironmentDiffuseScale
local baseEnvSpecScale = lighting.EnvironmentSpecularScale


local character = player.Character or player.CharacterAdded:Wait()
local arm = character:WaitForChild("Left Arm");
local thirdPerson = Values:Fetch("thirdPerson");
local debugThirdPerson = Values:Fetch("debugThirdPerson");


local te = require(script.Parent.Modules.TitleEffect)


local baseAT = 0;


uis.InputBegan:Connect(function(Input: InputObject, Processed: boolean)

	if Input.KeyCode == Enum.KeyCode.Backquote then
		if stat.Value then
			player:WaitForChild("mapLocallyLoaded").Value = false;
			player.PlayerGui.StatsGui.Enabled = false
			stat.Value = false;
		else
			player:WaitForChild("mapLocallyLoaded").Value = true;
			player.PlayerGui.StatsGui.Enabled = true;
			stat.Value = true;
		end
		
	
	elseif Input.KeyCode == Enum.KeyCode.F2 then
		if not fullbright then
			fullbright = true
			lighting.Ambient = Color3.new(1,1,1)
			lighting.Brightness = 10
			lighting.ColorShift_Top = Color3.new(1,1,1)
			lighting.ColorShift_Bottom = Color3.new(1,1,1)
			lighting.OutdoorAmbient = Color3.new(1,1,1)
			lighting.EnvironmentDiffuseScale = 0
			lighting.EnvironmentSpecularScale = 0
		else
			fullbright = false
			lighting.Ambient = baseAmbient
			lighting.Brightness = baseBrightness
			lighting.ColorShift_Top = baseColorShiftTop
			lighting.ColorShift_Bottom = baseColorShiftBot
			lighting.OutdoorAmbient = baseOutdoorAmbient
			lighting.EnvironmentDiffuseScale = baseEnvDiffScale
			lighting.EnvironmentSpecularScale = baseEnvSpecScale
		end

	elseif Input.KeyCode == Enum.KeyCode.F4 then
		if not unlock then 
			unlock = true
			uis.MouseIconEnabled = true;
			camera.CameraType = Enum.CameraType.Scriptable 
		else 
			unlock = false 
			uis.MouseIconEnabled = true;
			camera.CameraType = Enum.CameraType.Custom 
		end
	
	elseif Input.KeyCode == Enum.KeyCode.F6 then
		if not thirdPerson.Value then
			player.CameraMode = Enum.CameraMode.Classic
			player.CameraMinZoomDistance = game.StarterPlayer.ZoomOutMax.Value;
			player.PlayerGui.CoolGui.Left.Enabled = false;
			player.PlayerGui.CoolGui.Right.Enabled = false;
			player.PlayerGui.CoolGui.Middle.Enabled = false;
			player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("crosshair").Visible = false;
			
			arm.Transparency = baseAT;
			-- arm.LocalTransparencyModifier = arm.Transparency;
			
			thirdPerson.Value = true;
			debugThirdPerson.Value = true;
		else
			player.CameraMode = Enum.CameraMode.LockFirstPerson
			player.CameraMinZoomDistance = game.StarterPlayer.CameraMinZoomDistance;
			player.PlayerGui.CoolGui.Left.Enabled = true;
			player.PlayerGui.CoolGui.Right.Enabled = true;
			player.PlayerGui.CoolGui.Middle.Enabled = true;
			player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("crosshair").Visible = true;
			
			baseAT = arm.Transparency;
			
			arm.Transparency = 1;
			-- arm.LocalTransparencyModifier = arm.Transparency;
			
			thirdPerson.Value = false;
			debugThirdPerson.Value = false;	
		end
	
	
	elseif Input.KeyCode == Enum.KeyCode.F8 then
		if gui then
			player.PlayerGui.CoolGui.Left.Enabled = false;
			player.PlayerGui.CoolGui.Right.Enabled = false;
			player.PlayerGui.CoolGui.Middle.Enabled = false;
			player.PlayerGui.CoolTitleGui.Left.Enabled = false;
			player.PlayerGui.CoolTitleGui.Right.Enabled = false;
			player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("crosshair").Visible = false;
			gui = false;
		else
			
			if player.spawned.Value then
				player.PlayerGui.CoolGui.Left.Enabled = true;
				player.PlayerGui.CoolGui.Right.Enabled = true;
				player.PlayerGui.CoolGui.Middle.Enabled = true;
				player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("crosshair").Visible = true;
			end
			
			if not player.spawned.Value then
				player.PlayerGui.CoolTitleGui.Left.Enabled = true;
				player.PlayerGui.CoolTitleGui.Right.Enabled = true;
			end
			
			gui = true
		end
	
	
	elseif Input.KeyCode == Enum.KeyCode.F10 then
		
		local funkylight = (lighting.ColorCorrection.Contrast == lighting.TitleEffect.Contrast);
		
		if funkylight then
			te:FadeOut(0.3);
		else
			te:FadeIn(0.3);
		end
	end
end)