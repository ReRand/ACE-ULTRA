-- repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;
repeat task.wait() until player.spawned.Value;

local cas = game:GetService("ContextActionService");

local character = player.Character or player.CharacterAdded:Wait();
local humanoid = character:WaitForChild("Humanoid");

local Values = require(workspace.Modules.Values);

local typing = Values:Fetch("typing")

local spawned = player.spawned

local mmg = require(script.Parent.Parent.Modules.MobileMockGui);
local GlobalDamage = require(workspace.Modules.GlobalDamage);


function Began(Input)
	if not typing.Value and spawned.Value then
		player:FindFirstChild("deathReason").Value = 4;
		GlobalDamage:Inflict(humanoid, 420, "noweapon");
	end
end


cas:BindAction("Kill", function(name, state, Input)
	if state == Enum.UserInputState.Begin then
		Began(Input);
	end
end, true, Enum.KeyCode.K);



mmg:Replicate("Kill");