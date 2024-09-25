local player = game.Players.LocalPlayer;
local playerGui = player.PlayerGui;
local character = player.Character or player.CharacterAdded:Wait();

repeat task.wait() until script;
repeat task.wait() until game:IsLoaded();

repeat task.wait() until script.Parent;

local Values = require(workspace.Modules.Values);

local unlock = Values:Fetch("unlockTitleGui");

local ContextActionService = game:GetService("ContextActionService")
local uis = game:GetService("UserInputService");
local ts = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local loaded = player.loaded;
local spawned = player.spawned;


repeat task.wait() until loaded.Value


local settingsButton = player.PlayerGui.CoolTitleGui.Left.Surf.Frame.buttons.settingsButton;
local exitButton = player.PlayerGui.CoolTitleGui.Middle.Surf.BoxFrame.ExitButton
local settingsGui = player.PlayerGui.CoolTitleGui.Middle.Surf;


settingsGui.Visible = false;


local gui = workspace:WaitForChild("PlayerTitleGuiInstance")

local rightFrame = gui:FindFirstChild("RightAdorneePart")
local leftFrame = gui:FindFirstChild("LeftAdorneePart")
local midFrame = gui:FindFirstChild("MiddleAdorneePart")
local logo = gui:FindFirstChild("Logo")


local rest = nil


midFrame.Position += Vector3.new(0, 35, 0)


local function Toggle()
	if settingsGui.Visible then
		exitButton.Active = false;
		
		ts:Create(rightFrame, TweenInfo.new(1, Enum.EasingStyle.Quad), {
			Position = rightFrame.Position - Vector3.new(0, 0, 50)
		}):Play();

		ts:Create(leftFrame, TweenInfo.new(1, Enum.EasingStyle.Quad), {
			Position = leftFrame.Position - Vector3.new(0, 0, -50)
		}):Play();

		ts:Create(logo, TweenInfo.new(1, Enum.EasingStyle.Quad), {
			Position = logo.Position - Vector3.new(0, 0, -50)
		}):Play();

		local midTween = ts:Create(midFrame, TweenInfo.new(1, Enum.EasingStyle.Quad), {
			Position = rest + Vector3.new(35, 0, 0)
		});
		
		midTween.Completed:Connect(function()
			settingsGui.Visible = false;
			unlock.Value = false;
		end);
		
		midTween:Play();
	else

		settingsGui.Visible = true;
		unlock.Value = true;

		print(rightFrame.Position);

		ts:Create(rightFrame, TweenInfo.new(1, Enum.EasingStyle.Quad), {
			Position = rightFrame.Position + Vector3.new(0, 0, 50)
		}):Play();

		ts:Create(leftFrame, TweenInfo.new(1, Enum.EasingStyle.Quad), {
			Position = leftFrame.Position + Vector3.new(0, 0, -50)
		}):Play();

		ts:Create(logo, TweenInfo.new(1, Enum.EasingStyle.Quad), {
			Position = logo.Position + Vector3.new(0, 0, -50)
		}):Play();

		rest = midFrame.Position;
		midFrame.Position += Vector3.new(35, 0, 0)

		settingsGui.Visible = true;
		exitButton.Active = true;

		ts:Create(midFrame, TweenInfo.new(1, Enum.EasingStyle.Quad), {
			Position = rest
		}):Play();
	end
end


settingsButton.Activated:Connect(Toggle);
exitButton.Activated:Connect(Toggle);
