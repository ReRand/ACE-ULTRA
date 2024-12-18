local Disappear = game.ReplicatedStorage.GameEvents.WeaponVisParity:WaitForChild("Disappear");
local Appear = game.ReplicatedStorage.GameEvents.WeaponVisParity:WaitForChild("Appear");
local Filter = game.ReplicatedStorage.GameEvents.WeaponVisParity:WaitForChild("Filter");
local Init = game.ReplicatedStorage.GameEvents.WeaponVisParity:WaitForChild("WeapInit");


local Values = require(workspace.Modules:WaitForChild("Values"));


local wvm = require(game.StarterPlayer.StarterCharacterScripts.Modules.WeaponModule.WeaponVisModule)


function GetHandleFromModel(model)
	for _, p in pairs(model:GetChildren()) do
		if string.lower(p.Name) == "handle" then
			return p;
		end
	end
end


Init.OnServerEvent:Connect(function(player, model, id)
	
	local character = player.Character or player.CharacterAdded:Wait();
	local arm = character:WaitForChild("Right Arm");
	
	
	if model and not arm:FindFirstChild(id) then
	
		model = model:Clone();
		model.Parent = arm;

		repeat task.wait() until #model:GetChildren() > 0

		local handle = GetHandleFromModel(model)

		if not model:FindFirstChild("ArmWeld") then
			local weld = Instance.new("Weld", handle);
			weld.Name = "ArmWeld";
			weld.Part0 = handle;
			weld.Part1 = arm;
			weld.Parent = model;

			weld.C1 = arm.RightGripAttachment.CFrame;
			weld.C0 = handle.Grip.CFrame;
		end

		handle.Anchored = false;

		wvm:Disappear(model);
	end
	
	
	Init:FireClient(player, model, id)
end)


Disappear.OnServerEvent:Connect(function(player, model)
	-- print(player, model)
	if model then
		wvm:Disappear(model)
	end
end)


Filter.OnServerEvent:Connect(function(player, model)
	-- print(player, model)
	if model then
		wvm:Filter(model)
	end
end)


Appear.OnServerEvent:Connect(function(player, model, arm)
	--print(player, model)
	if model then
		wvm:Appear(model, arm);
	end
end)