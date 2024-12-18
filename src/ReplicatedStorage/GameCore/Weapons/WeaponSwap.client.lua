
local Values = require(workspace.Modules.Values);
local player = game.Players.LocalPlayer;
local loaded = player.loaded;

repeat task.wait() until loaded.Value;
repeat task.wait() until player.spawned.Value;

task.wait(0.08);

repeat task.wait() until script;
repeat task.wait() until script.Parent;
repeat task.wait() until script.Parent.Parent;

local RunService = game:GetService("RunService");

local wm = require(script.Parent.Parent.Modules.WeaponModule);
local mmg = require(script.Parent.Parent.Modules.MobileMockGui).init();
local wvm = wm.WeaponVisModule;

local uis = game:GetService("UserInputService");
local cas = game:GetService("ContextActionService");

local WeaponID = player:WaitForChild("weaponId");
local LastID = player:WaitForChild("lastWeaponId");

local thirdPerson = Values:Fetch("thirdPerson");

local cooldown = false;
local typing = Values:Fetch('typing');


uis.InputChanged:Connect(function(Input)
	if not thirdPerson.value and not typing.Value and Input.UserInputType == Enum.UserInputType.MouseWheel and not cooldown and not workspace.GlobalValues.Game.ended.Value then
		LastID.Value = WeaponID.Value;

		if Input.Position.Z > 0 then
			WeaponID.Value = (WeaponID.Value+1 > wm:GetWeaponCount()) and 1 or WeaponID.Value + 1
		else
			WeaponID.Value = (WeaponID.Value-1 < 1) and wm:GetWeaponCount() or WeaponID.Value - 1
		end

		cooldown = true;

		wait(0.1);

		cooldown = false;
	end
end)



cas:BindAction("Slot1", function(name, state, Input)
	if not typing.Value and not thirdPerson.value and not cooldown and state == Enum.UserInputState.Begin then 
		LastID.Value = WeaponID.Value;
		WeaponID.Value = 1 

		cooldown = true;

		wait(0.05);

		cooldown = false;
	end

end, true, Enum.KeyCode.One);


cas:BindAction("Slot2", function(name, state, Input)
	if not typing.Value and not thirdPerson.value and not cooldown and state == Enum.UserInputState.Begin then 
		LastID.Value = WeaponID.Value;
		WeaponID.Value = 2 

		cooldown = true;

		wait(0.05);

		cooldown = false;
	end

end, true, Enum.KeyCode.Two);


cas:BindAction("Slot3", function(name, state, Input)
	if not typing.Value and not thirdPerson.value and not cooldown and state == Enum.UserInputState.Begin then 
		LastID.Value = WeaponID.Value;
		WeaponID.Value = 3 

		cooldown = true;

		wait(0.05);

		cooldown = false;
	end

end, true, Enum.KeyCode.Three);


cas:BindAction("Slot4", function(name, state, Input)

	if not typing.Value and not thirdPerson.value and not cooldown and state == Enum.UserInputState.Begin then 
		LastID.Value = WeaponID.Value;
		WeaponID.Value = 4 

		cooldown = true;

		wait(0.05);

		cooldown = false;
	end

end, true, Enum.KeyCode.Four);



mmg:Replicate("Slot1", "SlotFrame");
mmg:Replicate("Slot2", "SlotFrame");
mmg:Replicate("Slot3", "SlotFrame");
mmg:Replicate("Slot4", "SlotFrame");