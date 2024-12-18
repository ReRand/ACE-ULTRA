local cas = game:GetService("ContextActionService");

local player = game.Players.LocalPlayer;
repeat task.wait() until player:WaitForChild("spawned").Value;


local character = player.Character or player.CharacterAdded:Wait();
local humanoid = character:WaitForChild("Humanoid");

local events = game.ReplicatedStorage.GameEvents.SlideSlam;


local slidestart = events.SlideBegan;
local slideend = events.SlideEnded;
local slam = events.Slam

local Values = require(workspace.Modules.Values);
local stamina = Values:Fetch("stamina");
local sliding = Values:Fetch("sliding");
local slamming = Values:Fetch("slamming");


local mmg = require(script.Parent.Parent.Modules.MobileMockGui);


local rs = game:GetService("RunService");

local function HandleSlam(state, Input)
	if not player:WaitForChild("slamEnabled").Value then return end;
	
	if state == Enum.UserInputState.Begin and stamina.Value > 0 and humanoid.FloorMaterial == Enum.Material.Air then
		slam:Fire(Input)
	end
	
end

local function HandleSlide(state, Input)
	if not player:WaitForChild("slideEnabled").Value then return end;
	
	if state == Enum.UserInputState.Begin and not slamming.Value then
		slidestart:Fire(Input)

	elseif state == Enum.UserInputState.End and sliding.Value then
		slideend:Fire(Input);
	end
end


cas:BindAction("SlideSlam", function(name, state, Input)
	
	HandleSlam(state, Input);
	HandleSlide(state, Input);
	
	
end, true, Enum.KeyCode.C, Enum.KeyCode.LeftControl);


mmg:Replicate("SlideSlam");


humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
	if humanoid.FloorMaterial == Enum.Material.Air then
		cas:SetTitle("SlideSlam", "Slam")
	else
		cas:SetTitle("SlideSlam", "Slide")
	end
end)