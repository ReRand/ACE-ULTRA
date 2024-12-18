local WeaponVisModule = {}
local ignore = {};


local Disappear = game.ReplicatedStorage.GameEvents.WeaponVisParity:WaitForChild("Disappear");
local Appear = game.ReplicatedStorage.GameEvents.WeaponVisParity:WaitForChild("Appear");
local Filter = game.ReplicatedStorage.GameEvents.WeaponVisParity:WaitForChild("Filter");

local rs = game:GetService("RunService");



function GetHandleFromModel(model)
	for _, p in pairs(model:GetChildren()) do
		if string.lower(p.Name) == "handle" then
			return p;
		end
	end
end

local dump = workspace:WaitForChild("ViewportWeaponDump");


function WeaponVisModule:Disappear(model, vp)
	
	if not model then return end;
	
	if rs:IsClient() and not vp then 
		Disappear:FireServer(model);
	end
	
	local weld = model:FindFirstChild("ArmWeld");
	
	local handle = GetHandleFromModel(model);
	
	-- handle.Anchored = true;
	
	weld.Part1 = dump;
	
	-- model:PivotTo(CFrame.new());
	
	--[[for _, thing in pairs(model:GetChildren()) do
		if (not thing:FindFirstChild("ignore") or (thing:FindFirstChild("ignore") and thing.ignore.Value == false)) and (string.find(thing.ClassName, "Part") and thing.ClassName ~= "ParticleEmitter") or thing:IsA("UnionOperation") or thing:IsA("Texture") or thing:IsA("Decal") then
			if thing.Transparency == 1 then
				ignore[#ignore+1] = thing;
			end
			
			thing.Transparency = 1;
			
			if rs:IsClient() then
				thing.LocalTransparencyModifier = 1 -- thing.Transparency
				-- print(thing.LocalTransparencyModifier);
			end
			
		elseif thing:IsA("SurfaceGui") then
			if thing.Enabled == false then
				ignore[#ignore+1] = thing;
			end
			thing.Enabled = false
		end

		WeaponVisModule:Disappear(thing);
	end]]
end


function WeaponVisModule:IsIgnored(model)
	for _, i in pairs(ignore) do
		if i == model then
			return true;
		end
	end
	return false;
end


function WeaponVisModule:Appear(model, arm, vp)
	if rs:IsClient() and not vp then 
		Appear:FireServer(model);
	end
	
	local weld = model:FindFirstChild("ArmWeld");

	local handle = GetHandleFromModel(model);
	-- handle.Anchored = false;
	
	if not weld then
		weld = Instance.new("Weld", handle);
		weld.Name = "ArmWeld";
		weld.Part0 = handle;
		weld.Part1 = arm;
		weld.Parent = model;

		weld.C1 = arm.RightGripAttachment.CFrame;
		weld.C0 = handle.Grip.CFrame;
	end

	weld.Part1 = arm;
	
	--[[for _, thing in pairs(model:GetChildren()) do
		if (not thing:FindFirstChild("ignore") or (thing:FindFirstChild("ignore") and thing.ignore.Value == false)) and (string.find(thing.ClassName, "Part") and thing.ClassName ~= "ParticleEmitter") or thing:IsA("UnionOperation") or thing:IsA("Texture") or thing:IsA("Decal") then
			if not WeaponVisModule:IsIgnored(thing) then
				
				if rs:IsClient() then
					thing.LocalTransparencyModifier = 1 --thing.Transparency
					-- print(thing.LocalTransparencyModifier);
				else
					thing.Transparency = 0;
				end
			end
		elseif thing:IsA("SurfaceGui") then
			if not WeaponVisModule:IsIgnored(thing) and rs:IsServer() then
				thing.Enabled = true
			end
		end

		WeaponVisModule:Appear(thing);
	end

	ignore = {};]]
end


function WeaponVisModule:Filter(model, vp)
	if rs:IsClient() and not vp then 
		Filter:FireServer(model);
	end
	
	if model then
		for _, p in pairs(model:GetChildren()) do

			pcall(function()
				p.Anchored = false;
				p.CanTouch = false;
				p.CanQuery = false;

				p:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
					p.LocalTransparencyModifier = 1 --p.Transparency;
				end)
				
				p.LocalTransparencyModifier = 0;
			end)

			WeaponVisModule:Filter(p)
		end
	end
end



return WeaponVisModule;
