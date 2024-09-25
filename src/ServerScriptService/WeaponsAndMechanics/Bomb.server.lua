local lightBomb = game.ReplicatedStorage.GameEvents.LightBomb;
local unlightBomb = game.ReplicatedStorage.GameEvents.UnlightBomb;
local ts = game:GetService("TweenService");


local projectile = game.ReplicatedStorage:WaitForChild("AmmoTypes"):WaitForChild("Bomb");
projectile.BulletConfig.defaultRadius.Value = projectile.BulletConfig.radius.Value;


local fuse = game.ReplicatedStorage.GameSounds.Bomb.Fuse



lightBomb.OnServerEvent:Connect(function(player, model)
	
	if not model then return; end
	
	local handle = model:WaitForChild('handle');
	
	local sound = fuse:Clone();
	sound.Parent = handle;
	
	sound:Play();
	
	local attachment = handle:WaitForChild("Attachment");
	
	local light = attachment:WaitForChild("Light");
	local particles = attachment:WaitForChild("ParticleEmitter");
	
	local trail = handle:WaitForChild("FuseTrail");
	
	light.Enabled = true;
	
	task.delay(0.07, function()
		light.Enabled = false;
	end)
	
	particles.Enabled = true;
	trail.Enabled = true;
end)


unlightBomb.OnServerEvent:Connect(function(player, model)
	
	if not model then return; end
	
	local handle = model:WaitForChild('handle');
	local sound = handle:FindFirstChild("Fuse");
	
	if sound then
		sound:Destroy();
	end

	local attachment = handle:WaitForChild("Attachment");

	local light = attachment:WaitForChild("Light");
	local particles = attachment:WaitForChild("ParticleEmitter");
	
	local trail = handle:WaitForChild("FuseTrail");

	light.Enabled = false;
	particles.Enabled = false;
	
	trail.Enabled = false;
end)