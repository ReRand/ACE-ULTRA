-- events
local clientEv = script.Parent.PingPong.Client;
local finalEv = script.Parent.PingPong.Finally;
local GlobalSide = require(script.Parent.Parent.Parent);


local player = game.Players.LocalPlayer;


function healInit(victim, amount, new, old)
	local victimHuman = victim:WaitForChild("Humanoid");
    
	victimHuman.Health = new;

	local res = {
			Vicitm = victim, 
			Amount = amount,
			NewHealth = new,
			OldHealth = old
	};
	
    GlobalSide.Healed.Client:Fire(player, res);
	
    GlobalSide.Healed.Finally:Fire(res);
	finalEv:FireServer(res);
end


clientEv:Connect(healInit);
