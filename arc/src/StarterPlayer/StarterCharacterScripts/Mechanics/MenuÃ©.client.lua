-- repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;
repeat task.wait() until player.spawned.Value;

local cas = game:GetService("ContextActionService");

local character = player.Character or player.CharacterAdded:Wait();
local humanoid = character:WaitForChild("Humanoid");

local Values = require(workspace.Modules.Values);

local typing = Values:Fetch("typing")

local spawned = player.spawned

local camera = workspace.CurrentCamera;

local resp = game.ReplicatedStorage.GameEvents:WaitForChild("MenuRespawner")


local mmg = require(script.Parent.Parent.Modules.MobileMockGui);


local actions = {
	"Punch",
	"Menu",
	"Dash"
}


function Began(Input)
	if not typing.Value and spawned.Value then
		spawned.Value = false;
		
		for _, act in pairs(actions) do
			cas:UnbindAction(act);
		end
		
		resp:FireServer();
	end
end


cas:BindAction("Menu", function(name, state, Input)
	if state == Enum.UserInputState.Begin then
		Began(Input);
	end
end, true, Enum.KeyCode.M, Enum.KeyCode.ButtonStart);


mmg:Replicate("Menu");