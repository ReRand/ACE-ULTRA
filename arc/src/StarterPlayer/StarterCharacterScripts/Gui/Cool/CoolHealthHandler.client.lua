local rs = game:GetService("RunService");

local player = game.Players.LocalPlayer;
local character = player.Character or player:WaitForChild("Character");
local humanoid = character:WaitForChild("Humanoid");

local thing = player.PlayerGui:WaitForChild("CoolGui").Left.Frame.health;
local Values = require(workspace.Modules.Values);

local ts = game:GetService("TweenService");

local last = humanoid.Health;

local gui = player.PlayerGui.ScreenGui.border;
local crack = player.PlayerGui.ScreenGui.crack;
local sl = player.PlayerGui.ScreenGui.scanlines;
local ct = crack.ImageTransparency;


local thirdPerson = Values:Fetch("thirdPerson");
local arm = character:WaitForChild("Left Arm");


while task.wait() do
	local dispay = math.round(humanoid.Health);
	if dispay > 100 then
		dispay = 100;
	end
	
	thing.Text = dispay;
	
	if humanoid.Health ~= last then
		
		--[[if humanoid.Health < last then
			if thirdPerson.Value then
				player.CameraMode = Enum.CameraMode.LockFirstPerson
				player.CameraMinZoomDistance = game.StarterPlayer.CameraMinZoomDistance;
				player.PlayerGui.CoolGui.Left.Enabled = true;
				player.PlayerGui.CoolGui.Right.Enabled = true;

				arm.Transparency = 1;
				arm.LocalTransparencyModifier = arm.Transparency;

				thirdPerson.Value = false;
			end
		end]]
		
		local dmg = last - humanoid.Health;
		
		--[[(ts:Create(sl, TweenInfo.new(0.5), {
			ImageTransparency = (1 - (dmg/50))
		})):Play()]]
		
		
		task.delay(dmg/10, function()
			
			if humanoid.Health > 0 then
				--[[(ts:Create(sl, TweenInfo.new(dmg/15), {
					ImageTransparency = 1;
				})):Play()]]
			end
		end)
		
		
		if dmg >= 35 then
			crack.Visible = true;
			
			task.delay(5, function()
				(ts:Create(crack, TweenInfo.new(3), {
					ImageTransparency = 1
				})):Play()
			end)
		end
		
	
		local t1 = humanoid.Health > last and 
			ts:Create(thing, TweenInfo.new(0.1), {
				TextColor3 = Color3.new(0, 1)
			})
		
		or
			ts:Create(thing, TweenInfo.new(0.1), {
				TextColor3 = Color3.new(1)
			})
		
		
		t1.Completed:Connect(function()
			(ts:Create(thing, TweenInfo.new(0.5), {
				TextColor3 = Color3.new(1-(dispay/100), (dispay/100));
			})):Play();
		end)
		

		t1:Play();
		local guit1 = ts:Create(gui, TweenInfo.new(0.5), {
			ImageTransparency = (gui.ImageTransparency - dmg/10) + 0.2
		})
		
		guit1.Completed:Connect(function()
			(ts:Create(gui, TweenInfo.new(dmg/10), {
				ImageTransparency = 1
			})):Play()
		end)
		
		guit1:Play();
	end
	
	last = humanoid.Health;
end