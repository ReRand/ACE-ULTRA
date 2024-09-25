local players = game.Players;

local function IsPlayerPart(part)
	return players:GetPlayerFromCharacter(part.Parent);
end

for _, dp in pairs(script.Parent:GetChildren()) do
	if dp:IsA("Part") then
		dp.Touched:Connect(function(part)
			
			local player = IsPlayerPart(part);
			
			if player then
				player.killerHuman.Value = dp;
				
				if dp.Name == "TopBound" then
					player.deathReason.Value = 2;
				else
					player.deathReason.Value = 1;
				end
				
				local humanoid = part.Parent:FindFirstChild("Humanoid");
				
				if humanoid then
					humanoid.Health = 0;
				end
			else
				part:Destroy();
			end
		end)
	end
end