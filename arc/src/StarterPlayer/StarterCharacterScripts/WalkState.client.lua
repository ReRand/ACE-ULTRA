local player = game.Players.LocalPlayer;

repeat task.wait() until game:IsLoaded();
repeat task.wait() until player.spawned.Value;


local character = player.Character or player.CharacterAdded:Wait();
local Humanoid = character:WaitForChild("Humanoid")
local Values = require(workspace.Modules.Values)


Humanoid:SetStateEnabled(12, false)


Humanoid.Running:Connect(function(speed)
	local Standing = Values:Fetch("standing")
	local Walking = Values:Fetch("walking")
	local pstanding = player:WaitForChild("standing");
	local pwalking = player:WaitForChild("walking");


	if math.round(speed) == 0 then
		Standing.Value = true;
		pstanding.Value = true;
		Walking.Value = false;
		pwalking.Value = false;

	else
		Standing.Value = false
		pstanding.Value = false;
	end
end)