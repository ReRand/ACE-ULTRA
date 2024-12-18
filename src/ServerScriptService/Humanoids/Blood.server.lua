local particles = game.ReplicatedStorage:WaitForChild("Storage").Particles;
local Debris = game:GetService("Debris");

local fly: Part = particles.Blood.Fly;

local crush = game.ReplicatedStorage.GameCore.Events.SlideSlam.CrushLimb;

local splatters = {
	particles.Blood.Splatter1,
	particles.Blood.Splatter2,
	particles.Blood.Splatter3,
};


local ts = game:GetService("TweenService");



local function doBloodStuff(intensity, origin, root, filter, filtertype)
	
	local params = RaycastParams.new()
	
	params.IgnoreWater = true;
	params.CollisionGroup = "HumanNonCol"
	params.FilterDescendantsInstances = filter;
	params.FilterType = filtertype;


	local ray = workspace:Raycast(root.Position, root.UpVector*-10, params);


	if ray then
		local splat = (splatters[math.random(1, #splatters)]):Clone();
		splat.Parent = workspace.Tempstances.Blood.Ground;
		splat.Name = "RootSplat";

		splat.Size *= intensity / 4

		splat.CFrame = CFrame.new(ray.Position, ray.Normal)
		-- splat.CFrame *= CFrame.Angles( splat.CFrame.Rotation.X, math.rad(math.random(0, 360)), splat.CFrame.Rotation.Z);	
	end
	
	
	for i = 1, intensity do
		local effect = fly:Clone();
		effect.Parent = workspace.Tempstances.Blood.Fly;
		effect.Transparency = ( math.random(1, math.abs((15/(intensity/20))+1) )-1 ) > 1 and 1 or 0;

		if effect.Transparency > 0 then
			for _, t in effect:getChildren() do
				if t:IsA("Decal") then
					t:Destroy();
				end
			end
		end


		local trail: Trail = effect.Trail;
		trail.Enabled = false;


		effect.CFrame = origin * CFrame.Angles(0, math.rad(math.random(360)), 0);


		local speed = 5;
		local xz = ((speed/7) * 10)

		local x = math.random(-xz, xz)
		if x == 0 then x = 1; end

		local z = math.random(-xz, xz)
		if z == 0 then z = 1; end


		local pos = effect.Position + Vector3.new(x, 5, z);


		trail.Enabled = true;

		effect.Anchored = false;
		effect.AssemblyLinearVelocity += CFrame.lookAt(root.Position, pos).LookVector*35


		local bloodfly2 = ts:Create(effect, TweenInfo.new(5), {
			Rotation = Vector3.new(math.random(-360, 360), math.random(-360, 360), math.random(-360, 360))
		})

		bloodfly2.Completed:Connect(function()
			bloodfly2:Destroy();
			effect:Destroy();
		end)


		local touched = false;


		effect.Touched:Connect(function(t)	
			if not touched and (t and t.Parent and not t.Parent:FindFirstChild("Humanoid")) then
				touched = true;

				if effect.Transparency == 0 then
					effect.CanCollide = true;
				end
				

				local cf = CFrame.lookAt(effect.Position, t.Position);

				local ray = workspace:Raycast(effect.Position, cf.LookVector*50, params);

				if ray then
					
					print(ray.Instance, ray.Instance.Parent);
					
					local splat: Part = (splatters[math.random(1, #splatters)]):Clone();
					splat.Parent = workspace.Tempstances.Blood.Ground;
					splat.Name = "FlySplat";

					splat.Size *= intensity / 5

					splat.CFrame = CFrame.new(ray.Position, ray.Normal)
					-- splat.CFrame *= CFrame.Angles( splat.CFrame.Rotation.X, math.rad(math.random(0, 360)), splat.CFrame.Rotation.Z);
				end
				
				Debris:AddItem(effect, 3);

				bloodfly2:Destroy();
			end
		end)
		
		Debris:AddItem(effect, 5);

		bloodfly2:Play();

	end
end


local function init(d)
	if d:IsA("Model") then
		
		local human: Humanoid = d:FindFirstChild("Humanoid");


		if human then
			
			local character = d;
			local player = game.Players:GetPlayerFromCharacter(character);
			local hrp = character.HumanoidRootPart;
			local head = character.Head;


			local oldhealth = human.Health;


			human.HealthChanged:Connect(function(health)
				if health < oldhealth then
					
					local dummydata = character:FindFirstChild("DummyData")
					
					if player and player.lit.Value then return;
					elseif not player and dummydata and dummydata.lit.Value then return end;
					
					local intensity = (oldhealth - health)/5 + 2;
					
					if health <= 0 then
						intensity += math.random(2, 6);
					end
					
					doBloodStuff(intensity, head.CFrame, hrp.CFrame, {
						character
					}, Enum.RaycastFilterType.Exclude);
				end

				oldhealth = health;
			end);
		end
	end
end;


workspace.DescendantAdded:Connect(init);


for _, d in pairs(workspace:GetDescendants()) do
	init(d);
end


crush.OnServerEvent:Connect(function(player, ...)
	doBloodStuff(...)
end);