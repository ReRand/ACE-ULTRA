-- server bullet shot module

local id = game.StarterPlayer.StarterCharacterScripts.Weapons.Heartslag.id.Value


return (function(player, ammotype, part, customconfig)
	if customconfig.WeaponId and customconfig.WeaponId == id then
		local character = player.Character or player.CharacterAdded:Wait();
		local hrp = character:WaitForChild("HumanoidRootPart");
		local arm = character:WaitForChild("Right Arm");
		local model = arm:WaitForChild(id);

		if model then
			local ammo = model:WaitForChild("ammo");
			local lockedParticles = ammo:WaitForChild("Particles"):WaitForChild("YuckyJuices");
			
			local partpart = model:WaitForChild("particles");
			local particles = partpart:WaitForChild("YuckyJuices");
			
			-- print(math.abs(hrp.Velocity.Y));
			
			local speed = math.abs(hrp.Velocity.Y)+20
			
			particles.Speed = NumberRange.new(speed);
			particles:Emit(particles.Rate);
			
			lockedParticles:Emit(lockedParticles.Rate);
		end
		
		--[[player:WaitForChild("weaponId").Changed:Connect(function()
			if player:FindFirstChild("weaponId").Value ~= id then
				local model = arm:WaitForChild(id);

				if model then
					model:WaitForChild("particle"):WaitForChild("YuckyJuices"):Clear();
				end
			end
		end)]]
	end
end)