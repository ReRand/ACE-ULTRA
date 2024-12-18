local Revared = require(workspace.Modules.Revared);
local global = Revared:GetModule("GlobalSide");

local TweenService = game:GetService("TweenService");

local inInfo = TweenInfo.new(0.2, Enum.EasingStyle.Circular, Enum.EasingDirection.In)
local outInfo = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)


local player = game.Players.LocalPlayer;


global.Damaged.Client:Connect(function(attacker, res)
	
	print('a');

	local victim = res.Victim;
	local damage = res.Amount;


	local dmgGui = workspace.Particles:WaitForChild("DamageGui").billboard;
	local aceDmgGui = workspace.Particles:WaitForChild("AceDamageGui").billboard;


	local ace = true;


	if (attacker.UserId == player.UserId) then
		local newDmgGui = ace and aceDmgGui:Clone() or dmgGui:Clone();
		local head = victim:FindFirstChild("Head");


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
			TextSize = ace and 75+damage*2 or 75+damage,
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
	end

end)



global.Healed.Client:Connect(function(inflicter, res)
	local victim = res.Victim;
	local amount = res.Amount;


	local hlGui = workspace.Particles:WaitForChild("DamageGui").billboard;
	local aceHlGui = workspace.Particles:WaitForChild("AceDamageGui").billboard;


	local ace = true;


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
			TextSize = ace and 75+amount*2 or 75+amount,
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
	end
end)