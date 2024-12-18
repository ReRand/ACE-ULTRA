local players = game.Players;

players.PlayerAdded:Connect(function(player)
	
	local level = player:WaitForChild("level");
	local curexp = player:WaitForChild("currentExp");
	local reqexp = player:WaitForChild("requiredExp");
	
	curexp.Changed:Connect(function()
		if curexp.Value/reqexp.Value >= 1 then
			local collectiveExp = curexp.Value;
			local collectiveLevel = 1;
			
			while task.wait() do
				
				print(collectiveExp < 57 * (level.Value + collectiveLevel), collectiveExp, 57 * (level.Value + collectiveLevel))
				
				if collectiveExp < 57 * (level.Value + collectiveLevel) then
					break;
				else
					collectiveExp -= 57 * (level.Value + collectiveLevel)
					collectiveLevel += 1;
				end
			end
			
			task.wait(0.5);
			
			level.Value = collectiveLevel + 1;
			reqexp.Value = 57 * level.Value;
			
			
			
			curexp.Value = collectiveExp;
		end
	end)
end)