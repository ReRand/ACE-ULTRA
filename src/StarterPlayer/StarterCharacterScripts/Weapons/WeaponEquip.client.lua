local Values = require(workspace.Modules.Values);
local player = game.Players.LocalPlayer;
local loaded = player.loaded;

repeat task.wait() until loaded.Value;
repeat task.wait() until player.spawned.Value;

task.wait(0.05);

repeat task.wait() until script;
repeat task.wait() until script.Parent;
repeat task.wait() until script.Parent.Parent;

local RunService = game:GetService("RunService");

local wm = require(script.Parent.Parent.Modules.WeaponModule);
local mmg = require(script.Parent.Parent.Modules.MobileMockGui).init();
local wvm = wm.WeaponVisModule;

local uis = game:GetService("UserInputService");
local cas = game:GetService("ContextActionService");

local character = player.Character or player.CharacterAdded:Wait();

local WeaponID = player:WaitForChild("weaponId");
local LastID = player:WaitForChild("lastWeaponId");
local WeaponModels = game.ReplicatedStorage:WaitForChild("Weapons");
local emotesMenuOpen = Values:Fetch("emotesMenuOpen");

local arm = character:WaitForChild("Right Arm");
local armCFrame = arm.RightShoulderAttachment.CFrame;


local viewport = Values:Fetch("viewportModel");
repeat task.wait() until viewport.Value;


local vpArm = viewport.Value:WaitForChild("Right Arm");
local vpArmCFrame = vpArm.RightShoulderAttachment.CFrame;

-- armCFrame *= CFrame.Angles(math.deg(90), 0, 0)


local frame = player.PlayerGui.CoolGui.Left.Frame;
local label = frame.label;
local image = frame.image;



local character = player.Character or player.CharacterAdded:Wait();
-- local GlobalEquip = require(workspace.Modules.GlobalEquip)

local model = nil;
local vpModel = nil;
local id = 1;


local data = nil;
local module = nil;


local Init = game.ReplicatedStorage.GameEvents.WeaponVisParity:WaitForChild("WeapInit");



local thirdPerson = Values:Fetch("thirdPerson");


thirdPerson.Changed:Connect(function()
	id = WeaponID.Value;
	model = arm:FindFirstChild(id);
	vpModel = vpArm:FindFirstChild(id);
	
	if model and vpModel then
		if thirdPerson.Value then
			wvm:Disappear(model);
			wvm:Disappear(vpModel, true);
		else
			arm.Transparency = 1;
			arm.LocalTransparency = 1;
			
			wvm:Appear(model, arm);
			wvm:Appear(vpModel, vpArm, true);
		end
	end
end)


Init.OnClientEvent:Connect(function(model, id)
	
	if not vpArm:FindFirstChild(id) then
		vpModel = model:Clone();
		vpModel.Parent = vpArm;

		repeat task.wait() until #vpModel:GetChildren() > 0

		local handle = wm:GetHandleFromModel(vpModel)

		if not vpModel:FindFirstChild("ArmWeld") then
			local weld = Instance.new("Weld", handle);
			weld.Name = "ArmWeld";
			weld.Part0 = handle;
			weld.Part1 = vpArm;
			weld.Parent = vpModel;

			weld.C1 = vpArm.RightGripAttachment.CFrame;
			weld.C0 = handle.Grip.CFrame;
		end

		if handle then
			handle.Anchored = false;
		end

		wvm:Disappear(vpModel, true);
	end
	
	print('waiting')
	
	repeat task.wait() until model and #model:GetChildren() > 0
	repeat task.wait() until vpModel and #vpModel:GetChildren() > 0
	
	print('done waiting');
	
	local handle = wm:GetHandleFromModel(model);
	local vpHandle = wm:GetHandleFromModel(vpModel);
	
	coroutine.wrap(function()
		if not handle then
			repeat task.wait(0.05); handle = wm:GetHandleFromModel(model) until handle
		end
		
		if not vpHandle then
			repeat task.wait(0.05); vpHandle = wm:GetHandleFromModel(vpModel) until vpHandle
		end

		handle.Anchored = false;
		vpHandle.Anchored = false;

		wvm:Filter(model);
		wvm:Filter(vpModel, true);

		data = wm:GetWeaponFolderFromId(id);

		if data and data:FindFirstChild("stuff") then
			module = require(data.stuff)

			if data.stuff:FindFirstChild("SwitchTo") then
				data.stuff.SwitchTo:Fire();
			end

		else
			module = nil;
		end
	end)()
end)


WeaponID.Changed:Connect(function()
	id = WeaponID.Value;
	local lastId = LastID.Value;
	
	label.Text = wm:GetNameFromId(id) or "None";
	image.Image = wm:GetImageFromId(id) or "http://www.roblox.com/asset/?id=16802825668";
	
	if arm:FindFirstChild(lastId) then
		wvm:Disappear(arm:FindFirstChild(lastId));
		wvm:Disappear(vpArm:FindFirstChild(lastId), true);
	end
	
	model = WeaponModels:FindFirstChild(tostring(id));
	
	
	if vpModel and not vpArm:FindFirstChild(id) then
		vpModel = model:Clone();
		vpModel.Parent = vpArm;

		local vpHandle = wm:GetHandleFromModel(vpModel);
		
		
		if not vpModel:FindFirstChild("ArmWeld") then
			local vpWeld = Instance.new("Weld", vpHandle);
			vpWeld.Name = "ArmWeld";
			vpWeld.Part0 = vpHandle;
			vpWeld.Part1 = vpArm;
			vpWeld.Parent = vpModel;

			vpWeld.C1 = vpArm.RightGripAttachment.CFrame;
			vpWeld.C0 = vpHandle.Grip.CFrame;
		end

		vpHandle.Anchored = false;

		wvm:Filter(vpModel, true);
		
		
	elseif vpArm:FindFirstChild(id) then
		wvm:Appear(vpArm:FindFirstChild(id), vpArm, true);
	end
	
	
	if model and not arm:FindFirstChild(id) then
		model = model:Clone();
		model.Parent = arm;
		
		local handle = wm:GetHandleFromModel(model)
		
		
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
		
		wvm:Filter(model);
		
		
	elseif arm:FindFirstChild(id) then
		wvm:Appear(arm:FindFirstChild(id), arm);
	end
	
	
	data = wm:GetWeaponFolderFromId(id);


	if data and data:FindFirstChild("stuff") then
		module = require(data.stuff)
		
		if data.stuff:FindFirstChild("SwitchTo") then
			data.stuff.SwitchTo:Fire();
		end
		
	else
		module = nil;
	end
	
	
	print(id);
end)


local cooldown = false;
local typing = Values:Fetch('typing');


uis.InputBegan:Connect(function(Input)
	if Input.KeyCode ~= Enum.KeyCode.Escape and not emotesMenuOpen.Value and not typing.Value and not thirdPerson.value and WeaponID.Value > 0 and module and Input.UserInputType == Enum.UserInputType.MouseButton1 and not workspace.GlobalValues.Game.ended.Value then
		-- print(Input.KeyCode)
		module:Fire();
	end
end)


cas:BindAction("Shoot", function(name, state, Input)
	if Input.KeyCode ~= Enum.KeyCode.Escape and not emotesMenuOpen.Value and  not typing.Value and not thirdPerson.value and WeaponID.Value > 0 and module and not workspace.GlobalValues.Game.ended.Value and state == Enum.UserInputState.Begin then
		-- print(Input.KeyCode)
		module:Fire();
	end

end, true, Enum.KeyCode.ButtonR2);

mmg:Replicate("Shoot");


local models = {}

for _, model in pairs(WeaponModels:GetChildren()) do
	if model:IsA("Model") then
		table.insert(models, model);
	end
end


for i, model in ipairs(models) do
	local id = model.Name;
	
	Init:FireServer(model, id, vpArm.Name);
	
	if i == #models then
		task.delay(0.3, function()
			LastID.Value = 0;
			WeaponID.Value = 1;
		end)
	end
end