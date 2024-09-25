local player = game.Players.LocalPlayer;
repeat task.wait() until player:WaitForChild("loaded").Value

local give = game.ReplicatedStorage.GameEvents.Fire:WaitForChild("GiveFireEffect");
local Effect = require(script.Parent.Parent.Parent.Modules.Effect);

local assets = game.ReplicatedStorage.EffectAssets.Fire;

local lit = player:WaitForChild("lit");


give.OnClientEvent:Connect(function(ftime, thatLit)
	local effect = Effect.new({
		Name = "Fire",
		Time = ftime
	});
	
	effect.Icon.Image = assets.icon.Image;
	
	task.delay(ftime, function()
		effect:Destroy()
	end)
end)