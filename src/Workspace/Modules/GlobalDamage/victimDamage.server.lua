repeat task.wait() until game:IsLoaded();

local TweenService = game:GetService("TweenService");

local inInfo = TweenInfo.new(0.2, Enum.EasingStyle.Circular, Enum.EasingDirection.In)
local outInfo = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)


local victimEvent = game.ReplicatedStorage.GlobalDamage.Victim;
local players = game.Players;
local player = players.LocalPlayer;


repeat task.wait() until player:WaitForChild("loaded").Value;
repeat task.wait() until player:WaitForChild("spawned").Value


local dmgGui = game.ReplicatedStorage:WaitForChild("Particles"):WaitForChild("DamageGui").billboard;
local aceDmgGui = game.ReplicatedStorage:WaitForChild("Particles"):WaitForChild("AceDamageGui").billboard;


victimEvent.OnClientEvent:Connect(function(attacker, victim, damage, ace, actionType, ...)
	
	local args = {...};
	
	if (attacker.UserId == player.UserId) then
		local newDmgGui = ace and aceDmgGui:Clone() or dmgGui:Clone();
		local head = victim:FindFirstChild("Head");
		
		newDmgGui.Enabled = true;
		
		local label = newDmgGui.Label;
		label.Text = "-"..tostring(damage);
		
		local baseSize = label.TextSize;
		
		label.TextTransparency = 1;
		label.TextSize = 0;
		
		
		if not head then
			print('SO NO HEAD');
			return;
		end
		
		local ia = nil;

		if not victim:FindFirstChild("IndicatorAttachment") then
			ia = Instance.new("Part", victim);
			ia.Name = "IndicatorAttachment";
			ia.Size = Vector3.new(1, 1, 1);
			ia.Transparency = 1;
			ia.CanCollide = false;

			local weld = Instance.new("Weld", ia)
			weld.Name = "IndicatorAttachmentWeld";
			weld.Part0 = head;
			weld.Part1 = ia;
			weld.C1 = CFrame.new(2, 0, 0)
		else
			ia = victim:FindFirstChild("IndicatorAttachment");
		end
		
		newDmgGui.Parent = ia;
		
		local inTween = TweenService:Create(label, inInfo, {
			TextTransparency = 0,
			TextSize = ace and 35+damage or 25+damage,
			Position = UDim2.new(0, 0, 0, -20)
		});
		
		local outTween = TweenService:Create(label, inInfo, {
			TextTransparency = 1,
			TextSize = 0,
			Position = UDim2.new(0, 0, 0, 0)
		});
		
		inTween:Play();
		
		inTween.Completed:Connect(function()
			task.wait(0.1);
			outTween:Play()
		end)
		
		outTween.Completed:Connect(function()
			newDmgGui:Destroy()
		end)
	end
	
	
	local victimHuman = victim:FindFirstChild("Humanoid");
	
	
	if not victimHuman then return end


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
end)