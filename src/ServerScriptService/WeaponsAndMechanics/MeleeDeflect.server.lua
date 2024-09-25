repeat task.wait() until script;
repeat task.wait() until script.Parent;

local deflecter = game.ReplicatedStorage.GameEvents.ProjMod:WaitForChild("Deflecter")

local Revared = require(workspace.Modules.Revared);
local global = Revared:GetModule("GlobalSide");

local cs = game:GetService("CollectionService");

local ts = game:GetService("TweenService");

local colser = game:GetService("CollectionService");

local cd = game.ReplicatedStorage.GameEvents.ProjMod:WaitForChild("ClientDamage")
local delayed = {};
local tweenTime = 0.1;


deflecter.OnServerEvent:Connect(function(player, hrp, part, vel, cf, mult)
	
	if not mult then mult = 2 end
	
	local effect = script.Effect;

	effect.DeflectLight:Clone().Parent = part;
	local textures = effect.Textures:Clone();
	textures.Parent = part;


	for _, surface in pairs(textures:GetChildren()) do
		surface.Adornee = part;

		ts:Create(surface.ImageLabel, TweenInfo.new(tweenTime), {
			Size = UDim2.fromScale(math.random(0, 100)/100, math.random(0, 100)/100)
		}):Play()
	end
	
	
	colser:AddTag(part, player.UserId);
	local config = part:FindFirstChild("ParryConfig") or (function()
		local c = Instance.new("Configuration", part);
		c.Name = "ParryConfig";
		return c;
	end)();
	
	
	if config:FindFirstChild("boostable") then
		config.boostable.Value = true;
	else
		local boostable = Instance.new("BoolValue", config);
		boostable.Name = "boostable";
		boostable.Value = true;
	end
	
	
	local hitbox = part:FindFirstChild("Hitbox") or part;
	hitbox.Touched:Connect(function() end);


	local cdTime = part.ParryConfig:FindFirstChild("cooldown") or { Value = 1 };

	part.Anchored = false;
	part.CanCollide = true;
	part.Position += Vector3.new(0, 1, 0)

	part.Velocity = Vector3.new(hrp.Velocity.X, hrp.Velocity.Y*1.25, hrp.Velocity.Z);
	
	
	if part.ParryConfig:FindFirstChild("damage") then
		part.ParryConfig.damage.Value *= mult;
	end
	
	if part.ParryConfig:FindFirstChild("radius") then
		part.ParryConfig.radius.Value *= mult;
	end


	while task.wait() do 
		if #hitbox:GetTouchingParts() > 0 then

			local voidHit = false;

			local voided = Instance.new("BoolValue", hrp);
			voided.Value = true;

			for i, p in ipairs(hitbox:GetTouchingParts()) do
				if p.Parent.Name == "Parts" and p.Parent.Parent.Name == "exploder" then voidHit = true;
				elseif string.find(string.lower(p.Name), "hitbox") then voidHit = true;
				elseif p:FindFirstChild("voided") and p:FindFirstChild("voided").Value == true then voidHit = true;
				end
			end

			if not voidHit then
				part.ParryConfig.parryable.Value = false;
				
				if part:FindFirstChild("Trail") then part.Trail:Destroy() end
				
				ts:Create(part.DeflectLight, TweenInfo.new(2), {
					Brightness = 0
				}):Play()
				
				for _, surface in pairs(textures:GetChildren()) do
					surface.Adornee = part;

					ts:Create(surface.ImageLabel, TweenInfo.new(2), {
						Size = UDim2.fromScale(math.random(0, 100)/100, math.random(0, 100)/100),
						ImageTransparency = 1
					}):Play()
				end
				
				break;
			end
		end
	end

	
	

	--[[if behavior.Value ~= "guardbreak" then
		part.Anchored = false;
		part.CanCollide = true;
		part.Velocity = hrp.Velocity*1.1;
	end


	if behavior.Value == "boom" then

		local hitbox = part:FindFirstChild("Hitbox") or part;
		hitbox.Touched:Connect(function() end);

		local multihit = part.ParryConfig:FindFirstChild("multihit") or { Value = false }

		local knockback = part.ParryConfig:FindFirstChild("knockback") or { Value = true }
		local kbmult = part.ParryConfig:FindFirstChild("kbmult") or { Value = 3 }


		local cdTime = part.ParryConfig:FindFirstChild("cooldown") or { Value = 1 };


		while task.wait() do 
			if #hitbox:GetTouchingParts() > 0 then

				local voidHit = false;

				local voided = Instance.new("BoolValue", hrp);
				voided.Value = true;

				for i, p in ipairs(hitbox:GetTouchingParts()) do
					if p.Parent.Name == "Parts" and p.Parent.Parent.Name == "exploder" then voidHit = true;
					elseif string.find(string.lower(p.Name), "hitbox") then voidHit = true;
					elseif p:FindFirstChild("voided") and p:FindFirstChild("voided").Value == true then voidHit = true;
					else
						print(p);
					end
				end

				if not voidHit then

					local radius = part.ParryConfig:FindFirstChild("radius") or { Value = 30 };
					local color = part.ParryConfig:FindFirstChild("color");
					local transparency = part.ParryConfig:FindFirstChild("transparency");

					local shockwave = part.ParryConfig:FindFirstChild("shockwave") or { Value = true };
					local wavemult = part.ParryConfig:FindFirstChild("wavemult") or { Value = 4 };


					local function GetModel()
						for _, model in pairs(workspace:GetChildren()) do
							if model.Name == "exploder" and model:FindFirstChild("Adornee") and model.Adornee.Value == part then
								return model;
							end
						end

						return workspace:WaitForChild("Particles").exploder:Clone();
					end


					local explModel = GetModel();

					if not shockwave.Value then
						explModel.Parts.shockwave:Destroy();
					end

					explModel.Parent = workspace;
					explModel.Adornee.Value = part;
					
					local sounds = explModel.Sounds:GetChildren();

					local sound = sounds[math.random(1, #sounds)];

					local baseVolume = sound.Volume;
					local baseSpeed = sound.PlaybackSpeed;

					sound.Volume = radius.Value/75
					sound.PlaybackSpeed = 25 / radius.Value;
					sound.RollOffMinDistance = radius.Value;

					local s = sound:Clone()
					s.Parent = explModel.Parts.big

					s.Ended:Connect(function()
						sound.Volume = baseVolume;
						s:Destroy();
					end)

					s:Play();

					local boomMsg = script.Parent.Events.BoomMessage;
					boomMsg:FireAllClients(part, radius.Value);


					local lights = {};
					local hittable = true;


					for _, light in pairs(explModel.Parts.big:GetChildren()) do
						if light:IsA("PointLight") or light:IsA("SurfaceLight") then
							lights[#lights+1] = light;

							if color then
								light.Color = color.Value;
							end

							light.Range = 0
							light.Brightness = 0
						end
					end

					for _, light in pairs(explModel.Parts.small:GetChildren()) do
						if light:IsA("PointLight") or light:IsA("SurfaceLight") then
							lights[#lights+1] = light;

							if color then
								light.Color = color.Value;
							end

							light.Range = 0
							light.Brightness = 0
						end
					end

					for _, light in pairs(lights) do
						(ts:Create(light, TweenInfo.new(radius.Value/50, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
							Range = radius.Value/5,
							Brightness = radius.Value/10
						})):Play()
					end

					for _, union in pairs(explModel.Parts:GetChildren()) do
						union.Size = Vector3.new(0, 0, 0)
						union.Position = part.Position;



						local indiv = part.ParryConfig:FindFirstChild("indiv") or { Value = 35 };
						local outdiv = part.ParryConfig:FindFirstChild("outdiv") or { Value = 10 };
						local persist = part.ParryConfig:FindFirstChild("persist") or { Value = false };
						local bigmult = part.ParryConfig:FindFirstChild("bigmult") or { Value = 1.5 };



						local s = Vector3.new(radius.Value, radius.Value, radius.Value);
						local t = radius.Value/indiv.Value;
						local r = Vector3.new(math.random(0, 360), math.random(0, 360), math.random(0, 360))



						if union.Name == "big" then

							s = Vector3.new(radius.Value*bigmult.Value, radius.Value*bigmult.Value, radius.Value*bigmult.Value);
							t = radius.Value/(indiv.Value*0.7142857143);

						elseif union.Name == "shockwave" then
							s = Vector3.new(0.7*(radius.Value*wavemult.Value), union.Size.Y*(radius.Value/50), 0.7*(radius.Value*wavemult.Value));
							t = radius.Value/(indiv.Value/2);
							r = Vector3.new(0, 0, 0)
						end



						local tween1 = ts:Create(union, TweenInfo.new(t, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
							Size = s,
							Rotation = r,
						});



						for _, texture in pairs(union:GetChildren()) do
							if texture:IsA("Decal") or texture:IsA("Texture") then
								if color then
									texture.Color3 = color.Value;
								end

								if transparency then
									texture.Transparency = transparency.Value;
								end

								local t = radius.Value/(outdiv.Value*1.5);

								local textureTween = ts:Create(texture, TweenInfo.new(t, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
									Transparency = 1
								});

								textureTween.Completed:Connect(function()
									union:Destroy();
								end)

								textureTween:Play();
							end
						end



						tween1.Completed:Connect(function()

							local r = Vector3.new(math.random(0, 360), math.random(0, 360), math.random(0, 360));

							local t = radius.Value/(outdiv.Value);
							local lt = radius.Value/(outdiv.Value*5);

							if union.Name == "shockwave" then
								r = Vector3.new(0, 0, 0)
								t = radius.Value/(outdiv.Value/2);
							end

							local tween2 = ts:Create(union, TweenInfo.new(t, Enum.EasingStyle.Cubic), {
								Size = Vector3.new(0, 0, 0),
								Rotation = r,
							});

							for _, light in pairs(lights) do
								(ts:Create(light, TweenInfo.new(lt, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
									Range = 0,
									Brightness = 0
								})):Play()
							end

							tween2.Completed:Connect(function()
								explModel:Destroy();
							end)

							tween2:Play();

							if not persist.Value then
								hittable = false;
							end
						end)

						tween1:Play();

					end

					if part.Name == "HumanoidRootPart" then
						local eHuman = part.Parent:FindFirstChild("Humanoid");
						eHuman.Health = 0;
					end

					local hit = {};
					local cooldown = {};

					local hb = explModel.Parts.hitbox;
					hb.Touched:Connect(function() end);

					while hittable do

						for _, part in pairs(hb:GetTouchingParts()) do

							local function hasHit(part)
								if multihit.Value then return false end
								for i, p in ipairs(hit) do
									if p == part then return true, i; end
								end

								return false;
							end

							local function onCooldown(part)
								if not multihit.Value then return false end;
								for i, p in ipairs(cooldown) do
									if p == part then return true, i; end
								end

								return false;
							end

							local function onDelay(part)
								if not multihit.Value then return false end;
								for i, p in ipairs(delayed) do
									if p == part then return true, i; end
								end

								return false;
							end

							if part.Name == "HumanoidRootPart" and hittable and not onCooldown(part) then

								local eHuman = part.Parent:FindFirstChild("Humanoid");
								local eChar = part.Parent;
								local voidHit = false;

								local ePlayer = game.Players:GetPlayerFromCharacter(eChar);

								local distance = (part.Position - hb.Position).magnitude

								if (part == hrp or part.Parent.Name == player.Name) and distance <= 1 then voidHit = true;
								elseif part:FindFirstChild("voided") and part:FindFirstChild("voided").Value == true then voidHit = true;
								end

								local iframed = false;

								if ePlayer then

									local ifrmEvent = script.Parent.Events.IFramed

									ifrmEvent:FireClient(ePlayer);

									local resPlayer, resIFramed = ifrmEvent.OnServerEvent:Wait();

									if resPlayer == ePlayer then
										iframed = resIFramed;
									end
								end


								if eHuman and not voidHit and not hasHit(part) and not iframed and not onCooldown(part) then

									local i = #cooldown+1;
									cooldown[i] = part;

									eHuman.Died:Connect(function()
										if onCooldown(part) then
											local _, i = onCooldown(part);
											table.remove(cooldown, i);	
										end

										if hasHit(part) then
											local _, i = hasHit(part);
											table.remove(hit, i);
										end


										if onDelay(part) then
											local _, i = onDelay(part);
											table.remove(delayed, i);
										end
									end)


									local damage = setDamage and setDamage.Value or radius.Value-(math.abs(distance));

									if damage < 0 then
										damage = 0;
									end

									hit[#hit+1] = part;

									if knockback.Value then
										part.AssemblyLinearVelocity = CFrame.lookAt(hb.Position, part.Position).LookVector*(radius.Value*kbmult.Value)
									end

									cd:FireClient(player, eHuman, damage);

								end
							elseif part.Name == "HumanoidRootPart" and onCooldown(part) and not onDelay(part) then
								local eHuman = part.Parent:FindFirstChild("Humanoid");

								delayed[#delayed+1] = part;

								task.delay(cdTime.Value, function()
									local _, i = onCooldown(part);
									table.remove(cooldown, i)
									table.remove(delayed, i);
								end);

							end
						end

						for _, union in pairs(explModel.Parts:GetChildren()) do
							for _, texture in pairs(union:GetChildren()) do
								if texture:IsA("Decal") or texture:IsA("Texture") then
									if texture.Transparency >= 0.98 then hittable = false; end
								end
							end
						end

						task.wait()
					end
					
					part:Destroy();
				end
			end
		end


	elseif behavior.Value == "pierce" then
		part.Velocity = vel*velMult.Value;

		local hitbox = part:FindFirstChild("Hitbox") or part;
		hitbox.Touched:Connect(function() end);

		while task.wait() do 
			if hitbox and #hitbox:GetTouchingParts() > 0 then

				for i, p in ipairs(hitbox:GetTouchingParts()) do

					local voidHit = false;

					for i, victim in ipairs(hitbox:GetTouchingParts()) do
						if p == hrp or part.Parent.Name == player.Name then voidHit = true;
						elseif p:FindFirstChild("voided") and p:FindFirstChild("voided").Value == true then voidHit = true;
						end

						if not voidHit then

							if part.Name == "HumanoidRootPart" then
								local eHuman = part.Parent:FindFirstChild("Humanoid");
								eHuman.Health = 0;
							end

							local voidHit = false;

							if victim == hrp or victim.Parent.Name == player.Name then voidHit = true;
							elseif victim:FindFirstChild("voided") and victim:FindFirstChild("voided").Value == true then voidHit = true;
							end

							local eHuman = victim.Parent:FindFirstChild("Humanoid");
							if eHuman then
								local damage = part:FindFirstChild("damage") or { Value = 100 };
								cd:FireClient(player, eHuman, damage.Value);
							else
								part:Destroy();
								break;
							end
						end
					end
				end
			end
		end

	elseif behavior.Value == "slide" then
		part.Velocity = vel*velMult.Value;
	end]]
end)