local players = game:GetService("Players")


local RESPAWN_DELAY = game.Players.RespawnTime;


-- Players.CharacterAutoLoads = false


local Revared = require(workspace.Modules.Revared);
local glob = Revared:GetModule("PlayerGlob");


local function onPlayerAdded(player)
	
	if not players.CharacterAutoLoads then
		player:LoadCharacter();
	end
	
	--[[local function onCharacterAdded(character)
		local humanoid = character:WaitForChild("Humanoid")

		local function onDied()
			task.wait(RESPAWN_DELAY)
			glob:Respawn(player)
		end

		humanoid.Died:Connect(onDied)
	end

	player.CharacterAdded:Connect(onCharacterAdded)]]
end


players.PlayerAdded:Connect(onPlayerAdded)