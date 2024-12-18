local player = game.Players.LocalPlayer;

repeat task.wait() until game:IsLoaded();
repeat task.wait() until player.spawned.Value;

repeat task.wait() until script;
repeat task.wait() until script.Parent;
repeat task.wait() until script.Parent.Parent;

local rs = game:GetService("RunService");
local ammo = script.Parent;
local max = script.Parent.Parent.maxammo;

local cooldown = false;
local last = ammo.Value

local id = script.Parent.Parent.id.Value;

local wm = require(script.Parent.Parent.Parent.Parent.Modules:WaitForChild("WeaponModule"));

ammo.Value = max.Value;


ammo.Changed:Connect(function()
	
	local model = wm:GetViewportWeaponModelFromId(id)
	
	if model then
		local label = model.ammo.SurfaceGui.Frame.TextLabel;
		label.Text = ammo.Value;
	end
	
	if ammo.Value < last then
		cooldown = true;
		
		task.wait( ammo.Value > 0 and 1 or 3 );
		
		cooldown = false;
	end
	
	last = ammo.Value;
end)


while task.wait(1) do
	if not cooldown and ammo.Value + 1 <= max.Value then 
		ammo.Value += 1;
	end
end