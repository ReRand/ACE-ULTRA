local cas = game:GetService("ContextActionService");
local uis = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");

local CameraShaker = require(workspace.Modules.CameraShaker)
local Values = require(workspace.Modules.Values)


local Events = script.Parent.Events;
local sprintEvent = Events.Sprint;
local crouchEvent = Events.Crouch;



local Character = script.Parent.Parent;
local Humanoid = Character:WaitForChild("Humanoid");
local Camera = workspace.CurrentCamera;

local DefaultFieldOfView = Camera.FieldOfView
local DefaultWalkingSpeed = Humanoid.WalkSpeed
local DefaultCameraOffset = Humanoid.CameraOffset


local Speed = 4
local Offset = Vector3.new(0, -1.5, 0);


local Keys = {
	Enum.KeyCode.LeftControl, 
	Enum.KeyCode.ButtonR3,
	Enum.KeyCode.ButtonB,
	Enum.KeyCode.C,
	Enum.KeyCode.X
}


local StartTweenSpeed = 1
local EndTweenSpeed = 2



local CrouchingTween = TweenService:Create(Camera, TweenInfo.new(StartTweenSpeed), { FieldOfView = DefaultFieldOfView-10 }) -- for when the player is normally sprinting
local WalkingTween = TweenService:Create(Camera, TweenInfo.new(EndTweenSpeed), { FieldOfView = DefaultFieldOfView }) -- for changing the stuff back



function Start(Input)
	local Sprinting = Values:Fetch("Sprinting")
	local Crouching = Values:Fetch("Crouching")
	local Standing = Values:Fetch("Standing")

	if not Crouching.Value and not Sprinting.Value then

		local IntoTween = TweenService:Create(Humanoid, TweenInfo.new(StartTweenSpeed), { 
			WalkSpeed = Speed,
			CameraOffset = Offset
		})
		
		IntoTween:Play()

		Crouching.Value = true

		CrouchingTween:Play()
	end

end



function Stop(Input)
	local Crouching = Values:Fetch("Crouching")

	if Crouching.Value then
		local OutTween = TweenService:Create(Humanoid, TweenInfo.new(EndTweenSpeed), { 
			WalkSpeed = DefaultWalkingSpeed,
			CameraOffset = DefaultCameraOffset
		})
		
		OutTween:Play()

		Crouching.Value = false

		WalkingTween:Play()
	end

end


local function Handler(Name, State, Input)
	if State == Enum.UserInputState.Begin then
		Start(Input)

	elseif State == Enum.UserInputState.End then
		Stop(Input)
	end
end


-- Bind action to function
cas:BindAction("Crawl", Handler, true, table.unpack(Keys));
cas:SetTitle("Crawl", "Crawl")