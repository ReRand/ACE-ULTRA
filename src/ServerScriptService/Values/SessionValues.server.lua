local players = game.Players;


players.PlayerAdded:Connect(function(player)
	local kills = player:WaitForChild("kills");
	local sessionKills = player:WaitForChild("sessionKills");
	
	local style = player:WaitForChild("style");
	local sessionStyle = player:WaitForChild("sessionStyle");
	
	local lastKills = 0;
	local lastStyle = 0;
	
	kills.Changed:Connect(function()
		if kills.Value > lastKills then
			sessionKills.Value += 1;
		end
		
		lastKills = kills.Value;
	end);
	
	style.Changed:Connect(function()
		if style.Value > lastStyle then
			sessionStyle.Value += 1;
		end

		lastStyle = style.Value;
	end);
end)