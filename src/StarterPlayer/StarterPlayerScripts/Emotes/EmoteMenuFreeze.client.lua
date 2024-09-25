local player = game.Players.LocalPlayer;

local PlayerModule = require(player.PlayerScripts:WaitForChild('PlayerModule'))
local controls = PlayerModule:GetControls()

repeat task.wait() until player:WaitForChild("loaded").Value;


local Values = require(workspace.Modules.Values);

local emotesMenuOpen = Values:Fetch("emotesMenuOpen");

emotesMenuOpen.Changed:Connect(function()
	if emotesMenuOpen.Value then
		controls:Disable()
	else
		controls:Enable()
	end
end)