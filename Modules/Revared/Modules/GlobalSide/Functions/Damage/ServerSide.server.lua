-- events
local clientEv = script.Parent.PingPong.Client;
local serverEv = script.Parent.PingPong.Server;
local referServerEv = script.Parent.PingPong.ReferServer;
local finalEv = script.Parent.PingPong.Finally;


local GlobalSide = require(script.Parent.Parent.Parent);


function dmgInit(victim, amount)
	local victimHuman = victim:WaitForChild("Humanoid");

    local old = victimHuman.Health
    
	if (victimHuman.Health - amount < 0) then
        amount = amount - math.abs((victimHuman.Health - amount))
    end
    
	victimHuman.Health -= amount;
	local new = victimHuman.Health

	local res = {
			Vicitm = victim, 
			Amount = amount,
			NewHealth = new,
			OldHealth = old
	};
	
    GlobalSide.Damaged.Server:Fire(res);
	clientEv:FireAllClients(victim, amount, new, old);
end


serverEv.OnServerEvent:Connect(function(player, victim, amount)
	dmgInit(victim, amount);		
end)


finalEv.OnServerEvent:Connect(function(res)
	GlobalSide.Damaged.Finally:Fire(res);	
end)


referServerEv.Event:Connect(dmgInit);
