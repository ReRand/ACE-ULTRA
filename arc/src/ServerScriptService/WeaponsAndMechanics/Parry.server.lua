--[[
there are a lot of different configurations for the parry behavior and I'll try to list them below

behavior<String>: the behavior of the parry
- boom: explodes upon impact
- pierce: goes through enemies killing instantly
- slide: part gets launched in the direction of the camera
- guardbreak: used when parrying shields, has no flinging kinda just breaks it


parryable<Bool>: if the part is parryable, default false

radius<Number>||<Int>: explosion radius if parry behavior is on boom, default 30

rotation<Number>||<Int>: rotation added onto the y axis of the part upon parrying, default 0

velocity<Number>||<Int>: velocity multiplier for the part when parried, default 300

persist<Bool>: if the explosion should continue damaging even while fading out, default false

multihit<Bool>: if the explosion should hit continously until destroyed, default false

indiv<Number>||<Int>: the amount of time it takes for the first phase of the explosion (fading in) to finish, default 35

outdiv<Number>||<Int>: the amount of time it takes for the second phase of the explosion (fading out) to finish, default 10

damage<Number>||<Int>: the amount of damage put out, automatically calculated using radius by boom but defaults to 100 for pierce and defaults to 25 for guardbreak

healing<Number>||<Int>: the amount of healing gotten from parrying, default 15

transparency<Number>||<Int>: the transparency of the explosion

cooldown<Number>||<Int>: the cooldown for multihit, default 1

bigmult<Number>||<Int>: multiplier for the size of the explosion's outer wave

shockwave<Bool>: if there should be a shockwave, default true

color<Color3>: the color of the explosion

boostable<Bool>: if the projectile can be parried by the shooter of it

knockback<Bool>: if there should be any knockback upon exploding

kbmult<Number>||<Int>: multiplier for the knockback applied on enemies when exploded

]]




repeat task.wait() until script;
repeat task.wait() until script.Parent;


local sv = game.ReplicatedStorage.GameEvents.PunchParry:WaitForChild("ServerVelocity");
local Revared = require(workspace.Modules.Revared);
local global = Revared:GetModule("GlobalSide");

local Values = require(workspace.Modules.Values);
local stamina = Values:Fetch("stamina");


local ts = game:GetService("TweenService");


local cd = game.ReplicatedStorage.GameEvents.PunchParry:WaitForChild("ClientDamage");
local delayed = {};

local Exploder = require(workspace.Modules.Exploder);


sv.OnServerEvent:Connect(function(player, hrp, part, parryConfig, vel, cf)	
	local parryConfig = part:FindFirstChild("ParryConfig") or parryConfig;
	
	if parryConfig then
		local behavior = parryConfig:FindFirstChild("behavior") or { Value = "boom" };
		
		local rotAdd = (part:FindFirstChild("BulletConfig") and part.BulletConfig:FindFirstChild("rotation")) and part.BulletConfig:FindFirstChild("rotation") or { Value = Vector3.new() };
		
		local velMult = parryConfig:FindFirstChild("velocity") or { Value = 300 };
		
		local setDamage = parryConfig:FindFirstChild("damage");
		
		
		if behavior.Value ~= "guardbreak" then
			part.Position += Vector3.new(0, 1, 0);
			part.Velocity = Vector3.new(0, 0, 0);
			

			local x, y, z = cf.Rotation:ToOrientation();
			part.Anchored = false;
			
			part.Orientation = Vector3.new(math.deg(x), math.deg(y), math.deg(z)) + rotAdd.Value;
			
			local clone = part:Clone();
			clone.Parent = workspace;
			clone.Anchored = true;
		end
		
		
		if behavior.Value == "boom" then
			
			part.Velocity = vel*velMult.Value;
			
			
			local exploder = Exploder.new(player, part, "parry", {
				ParryConfig = parryConfig,
				BulletConfig = part:FindFirstChild("BulletConfig");
			});
			
			
			exploder:Prime();
			
			--[[local hitbox = part:FindFirstChild("Hitbox") or part;
			hitbox.Touched:Connect(function() end);
			
			local multihit = parryConfig:FindFirstChild("multihit") or { Value = false }
			
			local knockback = parryConfig:FindFirstChild("knockback") or { Value = true }
			local kbmult = parryConfig:FindFirstChild("kbmult") or { Value = 3 }
			
			
			local cdTime = parryConfig:FindFirstChild("cooldown") or { Value = 1 };
			
			
			while task.wait() do 
				if #hitbox:GetTouchingParts() > 0 then
					
					local voidHit = false;
					
					local voided = Instance.new("BoolValue", hrp);
					voided.Value = true;
					
					for i, p in ipairs(hitbox:GetTouchingParts()) do
						if p == hrp or part.Parent.Name == player.Name then voidHit = true;
						elseif p.Parent.Parent.Name == "ExplodeEffect" then voidHit = true;
						elseif p:FindFirstChild("voided") and p:FindFirstChild("voided").Value == true then voidHit = true;
						elseif string.find(string.lower(p.Name), "hitbox") then voidHit = true;
						end
						
						if part.Name == "HumanoidRootPart" then
							local ePlayer = game.Players:GetPlayerFromCharacter(part.Parent);
							if ePlayer and player.UserId == ePlayer.UserId then voidHit = true; end
							
							for _, bp in pairs(part.Parent:GetChildren()) do
								if p == bp and not voidHit then voidHit = true;
								end
							end
						end
					end
						
					if not voidHit then
						
						local radius = parryConfig:FindFirstChild("radius") or { Value = 30 };
						local color = parryConfig:FindFirstChild("color");
						local transparency = parryConfig:FindFirstChild("transparency");
						
						local shockwave = parryConfig:FindFirstChild("shockwave") or { Value = true };
						local wavemult = parryConfig:FindFirstChild("wavemult") or { Value = 4 };
						
						
						local function GetModel()
							for _, model in pairs(workspace.Explosions:GetChildren()) do
								if model.Name == "ExplodeEffect" and model:WaitForChild("Adornee").Value == part then
									return model;
								end
							end
							
							return game.ReplicatedStorage:WaitForChild("Particles").ExplodeEffect:Clone();
						end
						
						
						local explModel = GetModel();
						
						if not shockwave.Value then
							explModel.Parts.shockwave:Destroy();
						end

						explModel.Parent = workspace.Explosions;
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

						local boomMsg = game.ReplicatedStorage.GameEvents.PunchParry:WaitForChild("BoomMessage");
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
							
							
							
							local indiv = parryConfig:FindFirstChild("indiv") or { Value = 35 };
							local outdiv = parryConfig:FindFirstChild("outdiv") or { Value = 10 };
							local persist = parryConfig:FindFirstChild("persist") or { Value = false };
							local bigmult = parryConfig:FindFirstChild("bigmult") or { Value = 1.5 };
							
							
							
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
										explModel:Destroy();
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
						
						
						part:Destroy();
						
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

										local ifrmEvent = game.ReplicatedStorage.GameEvents.PunchParry:WaitForChild("IFramed")

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
					end
				end
			end]]
			
			
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
		end
	end
end)