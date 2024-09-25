local player = game.Players.LocalPlayer;

repeat task.wait() until player.loaded.Value;


local Values = require(workspace.Modules.Values);
local staminaHold = Values:Fetch("staminaHold");
local stamina = Values:Fetch("stamina");
local peak = stamina.Value;


local RunService = game:GetService("RunService");
local cooldown = false;


while task.wait() do
	
	if stamina.Value <= 0 then
		stamina.Value = 0;
		
	elseif stamina.Value > peak then
		stamina.Value = peak;
	end
	
	
	if not staminaHold.Value and stamina.Value < peak and not cooldown then
		stamina.Value += 1;
		
		cooldown = true;
		
		task.delay(0.01, function()
			cooldown = false;	
		end);
	end
end