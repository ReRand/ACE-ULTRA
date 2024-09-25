-- server bullet shot module

local id = game.StarterPlayer.StarterCharacterScripts.Weapons.Plasmatrix.id.Value


return (function(player, ammotype, part, customconfig)
	if customconfig.WeaponId and customconfig.WeaponId == id then
		local character = player.Character or player.CharacterAdded:Wait();
		local arm = character:WaitForChild("Right Arm");
		local model = arm:WaitForChild(id);
		
		if model then
			local handle = model:WaitForChild("handle");
			handle:WaitForChild("Circle"):WaitForChild("CircleEmitter"):Emit(2)
			handle:WaitForChild("BeamStart"):WaitForChild("FlashEmitter"):Emit(2)
		end
		
		if part then
			part:WaitForChild("CoreBeam").Enabled = true;
		end
		
		player:WaitForChild("weaponId").Changed:Connect(function()
			if player:FindFirstChild("weaponId").Value ~= id and player:FindFirstChild("lastWeaponId").Value == id then
				local model = arm:WaitForChild(id);

				if model then
					local handle = model:WaitForChild("handle");
					handle:WaitForChild("Circle"):WaitForChild("CircleEmitter"):Clear();
					handle:WaitForChild("BeamStart"):WaitForChild("FlashEmitter"):Clear();
				end
			end
		end)
	end
end)