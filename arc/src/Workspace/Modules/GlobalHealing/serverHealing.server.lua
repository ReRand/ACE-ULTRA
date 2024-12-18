local serverEvent = game.ReplicatedStorage.GlobalHealing.Server;
local victimEvent = game.ReplicatedStorage.GlobalHealing.Victim;
local TweenService = game:GetService("TweenService");


serverEvent.OnServerEvent:Connect(function(player, victim, amount, ace, actionType, ...)
	
	local args = {...};
	
	
	local victimHuman = victim:WaitForChild("Humanoid");
	
	
	if amount < 0 then amount = math.abs(amount) end;
	amount = ace and amount*2 or amount;
	if (victimHuman.Health <= 0) then return end;
	
	
	victimHuman.Health += amount;
	victimEvent:FireAllClients(player, victim, amount, ace, actionType, ...);
	
	
	if (actionType) then
		
	end
end)