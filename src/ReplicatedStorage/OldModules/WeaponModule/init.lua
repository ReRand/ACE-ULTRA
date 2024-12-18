local WeaponModule = {
	WeaponVisModule = require(script.WeaponVisModule)
};

local player = game.Players.LocalPlayer;
local character = player.Character or player.CharacterAdded:Wait();


local weapons = character:WaitForChild("Weapons");
local Values = require(workspace.Modules.Values);


function WeaponModule:GetWeaponCount()
	local count = 0;
	for _, w in pairs(weapons:GetChildren()) do
		count += (w:IsA("Folder") and 1 or 0);
	end
	return count
end


function WeaponModule:GetNameFromId(id)
	for _, w in pairs(weapons:GetChildren()) do
		if w:IsA("Folder") and id == w.id.Value then
			return w.Name;
		end
	end
end


function WeaponModule:GetImageFromId(id)
	for _, w in pairs(weapons:GetChildren()) do
		if w:IsA("Folder") and id == w.id.Value and w:FindFirstChild("image") then
			return w.image.Image;
		end
	end
end


function WeaponModule:GetWeaponFolderFromId(id)
	for _, w in pairs(weapons:GetChildren()) do
		if w:IsA("Folder") and id == w.id.Value then
			return w;
		end
	end
end


function WeaponModule:GetWeaponModelFromId(id)
	local arm = character:FindFirstChild("Right Arm")
	if not arm then return end;
	return arm:FindFirstChild(id);
end


function WeaponModule:GetViewportWeaponModelFromId(id)
	local viewport = Values:Fetch("viewportModel");
	local vpm = viewport.Value;
	local arm = vpm:FindFirstChild("Right Arm")
	if not arm then return end;
	return arm:FindFirstChild(id);
end


function WeaponModule:GetHandleFromModel(model)
	for _, p in pairs(model:GetChildren()) do
		if string.lower(p.Name) == "handle" then
			return p;
		end
	end
end


return WeaponModule
