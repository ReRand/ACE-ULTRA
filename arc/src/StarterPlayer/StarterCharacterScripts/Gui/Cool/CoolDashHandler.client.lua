local Values = require(workspace.Modules.Values);

local stamina = Values:Fetch("stamina");

local player = game.Players.LocalPlayer;

local thing = player.PlayerGui:WaitForChild("CoolGui").Left.Frame.dash;

while task.wait(0.1) do
	thing.Text = stamina.Value;
end