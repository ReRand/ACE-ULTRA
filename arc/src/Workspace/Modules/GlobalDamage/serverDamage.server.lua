local serverEvent = game.ReplicatedStorage.GlobalDamage.Server;
local victimEvent = game.ReplicatedStorage.GlobalDamage.Victim;
local TweenService = game:GetService("TweenService");


local KillFeed = require(workspace.Modules.KillFeed)



serverEvent.OnServerEvent:Connect(function(player, victim, damage, ace, actionType, ...)
	
	local victimPlayer = game.Players:GetPlayerFromCharacter(victim);
	
	
	if string.match(victim.Name, "Dummy") or victim.Name == "TrueJim" or victim:FindFirstChild("DummyData") then
		victimPlayer = victim:FindFirstChild("DummyData");
	end
	
	local teamColor = nil;
	if victimPlayer then
		teamColor = ((typeof(victimPlayer.TeamColor) == "Instance" and victimPlayer.TeamColor:IsA("BrickColorValue")) and victimPlayer.TeamColor.Value or victimPlayer.TeamColor);
	end
	
	
	if victimPlayer and teamColor and player.TeamColor == teamColor and victimPlayer ~= player then
		return;
	end
	
	local iframed = player:WaitForChild("iframed");
	if iframed.Value then return end;
	
	
	local parrying = player:WaitForChild("parrying");
	if parrying.Value then
		
	else
		local args = {...};
		
		
		local playerChar = player.Character or player.CharacterAdded:Wait();
		
		
		local victimHuman = victim:WaitForChild("Humanoid");
		local playerHuman = playerChar:WaitForChild("Humanoid");
		
		local mult = 2;

		if actionType == "ace" and #args > 0 then
			mult = args[1];
		end
		
		
		if damage < 0 then damage = math.abs(damage) end;
		damage = ace and damage*mult or damage;
		if (victimHuman.Health <= 0) then return end;
		
		
		damage = math.round(damage);
		victimHuman:TakeDamage(damage);
		
		
		if (victimHuman.Health <= 0) then
			local assist = nil;
			local killer = playerHuman;
			local weapon = nil;
			local reason = nil;
			local typ = 2;
			
			-- print(player:FindFirstChild("weaponId"));
			
			if player:FindFirstChild("weaponId") and actionType ~= "noweapon" then
				weapon = player:FindFirstChild("weaponId").Value;	
			end
			
			
			if victimPlayer then
				
				assist = victimPlayer.assistHuman.Value;
				reason = victimPlayer.deathReason.Value;
				
				victimPlayer.killerHuman.Value = killer;
				
				if weapon then
					victimPlayer.killerWeapon.Value = weapon;
				end
				
				if victimPlayer.assistHuman.Value == playerHuman then
					victimPlayer.assistHuman.Value = assist;
				end
			end
			
			
			if victimPlayer and victimPlayer:IsA("Player") and player then
				player.kills.Value += 1
			end
			
			
			-- weapon kill (no assist)
			if (not reason or reason < 1) and victim ~= playerChar and weapon and (not assist or assist == playerHuman) then
				typ = 1;
			
			
			-- weapon kill (assist)
			elseif (not reason or reason < 1) and victim ~= playerChar and weapon and assist and assist ~= playerHuman then
				typ = 3;
				
			-- reason
			elseif reason and reason >= 1 --[[and not assist]] then
				typ = 2;
			
			
			-- self weapon kill
			elseif (not reason or reason < 1) and victim == playerChar and weapon and (not assist or assist == playerHuman) then
				typ = 6
			end
				
			
			--print(assist, killer, weapon, reason, typ);
			
			local assistChar = nil;
			local assistPlayer = nil;
			
			if assist then
				assistChar = assist.Parent;
				
				if assistChar then
					assistPlayer = game.Players:GetPlayerFromCharacter(assistChar);
				end
			end
			
			
			KillFeed.KillItem.new({
				
				Victim = victim,
				VictimHuman = victimHuman,
				VictimPlayer = victimPlayer,
				
				Attacker = playerChar,
				AttackerHuman = playerHuman,
				AttackerPlayer = player,
				
				Assist = assistChar,
				AssistHuman = assist,
				AssistPlayer = assistPlayer,
				
				Weapon = weapon,
				Reason = reason,
				
				Type = typ
			});
			
			
			if victimPlayer then
				victimPlayer.assistHuman.Value = nil;
				victimPlayer.killerHuman.Value = nil;
				victimPlayer.deathHeadshot.Value = false;
				victimPlayer.deathReason.Value = 0;
				victimPlayer.deathType.Value = 0;
			end
			
		elseif victimPlayer and victimPlayer:FindFirstChild("assistHuman") and victimPlayer.assistHuman.Value == nil then
			victimPlayer.assistHuman.Value = playerHuman;
			
			task.delay(15, function()
				if victimPlayer and victimPlayer:FindFirstChild("assistHuman") and victimPlayer.assistHuman.Value == playerHuman then
					victimPlayer.assistHuman.Value = nil;
				end
			end)
		end
		
		
		victimEvent:FireAllClients(player, victim, damage, ace, actionType, ...);
		
		
		if (actionType) then
			if actionType == "fling" then
				local vel = args[1];
				local hrp = victim:WaitForChild("HumanoidRootPart");
				
				hrp.Velocity += vel;
				
				
			elseif actionType == "kickbackpos" then
				
				local attacker = args[1];
				local attackerHRP = attacker:WaitForChild("HumanoidRootPart");
				local kickBackSettings = args[2];
				local hrp = victim:WaitForChild("HumanoidRootPart");
				
				local bp = Instance.new("BodyPosition", hrp)

				local info = TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
				local tween = TweenService:Create(bp, info, kickBackSettings);

				tween:Play()
				local startTime = tick()
				
				
				local baseJumpHeight = victimHuman.JumpHeight

				local pos = hrp.CFrame.Position;
				local rawRot = attackerHRP.Rotation;
				local rot = CFrame.fromOrientation(rawRot.X, 0, rawRot.Z);
				rot += pos;
				

				hrp.Rotation = Vector3.new(rawRot.X, rawRot.Y+180, rawRot.Z);
				

				for i=0, 20 do
					local currtime = tick()
					local elapsedtime = currtime - startTime
					victimHuman.JumpHeight = 0;
					
					bp.Position = (hrp.CFrame * CFrame.new(0, 1, 2.5)).Position
					task.wait();
				end

				victimHuman.JumpHeight = baseJumpHeight
				bp:Destroy()
				
			
			elseif actionType == "kickbackvel" then

				local attacker = args[1];
				local attackerHRP = attacker:WaitForChild("HumanoidRootPart");
				local kickBackTime = args[2]
				local kickBackSettings = args[3];
				local hrp = victim:WaitForChild("HumanoidRootPart");

				local bv = Instance.new("BodyVelocity", hrp)
				
				for attr, value in pairs(kickBackSettings) do
					bv[attr] = value;
				end
				
				game.Debris:AddItem(bv, kickBackTime);
			end
		end
	end
end)