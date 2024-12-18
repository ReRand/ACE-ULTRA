repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("valuesLoaded").Value

local PlayerModule = require(player.PlayerScripts:WaitForChild('PlayerModule'))
local controls = PlayerModule:GetControls()


local spawned = player.spawned;


spawned.Changed:Connect(function()
	if spawned.Value == true then
		controls:Enable()
	else
		controls:Disable()
	end
end)

controls:Disable()