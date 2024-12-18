repeat task.wait() until game:IsLoaded();

local TweenService = game:GetService("TweenService");

local inInfo = TweenInfo.new(0.2, Enum.EasingStyle.Circular, Enum.EasingDirection.In)
local outInfo = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)


local victimEvent = game.ReplicatedStorage.GlobalHealing.Victim;
local players = game.Players;
local player = players.LocalPlayer;

repeat task.wait() until player:WaitForChild("loaded").Value;
repeat task.wait() until player:WaitForChild("spawned").Value;


local hlGui = game.ReplicatedStorage:WaitForChild("Particles"):WaitForChild("HealingGui").billboard;
local aceHlGui = game.ReplicatedStorage:WaitForChild("Particles"):WaitForChild("AceHealingGui").billboard;


victimEvent.OnClientEvent:Connect(function(inflicter, victim, amount, ace, actionType, ...)
	
	if (inflicter.UserId == player.UserId) then
		local newHlGui = ace and aceHlGui:Clone() or hlGui:Clone();
		local head = victim:FindFirstChild("Head");
		
		
		local label = newHlGui.Label;
		label.Text = "+"..tostring(amount);
		
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
		
		newHlGui.Parent = ia;
		
		local inTween = TweenService:Create(label, inInfo, {
			TextTransparency = 0,
			TextSize = ace and amount*2 or 25+amount,
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
			newHlGui:Destroy()
		end)
	end
	
	local victimHuman = victim:WaitForChild("Humanoid");


	if actionType then
		
	end


	-- victimHuman.Health += amount;
end)