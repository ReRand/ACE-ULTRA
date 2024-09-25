repeat task.wait() until game:IsLoaded();

local player = game.Players.LocalPlayer;

local parts = {};
local label = player.PlayerGui:WaitForChild("LoaderGui").label;

local uis = game:GetService("UserInputService");

local freezeLoading = false;

uis.WindowFocusReleased:Connect(function()
	freezeLoading = true;
end)
uis.WindowFocused:Connect(function()
	freezeLoading = false;
end)


while #parts <= 0 do 
	for _, p in pairs(workspace:GetDescendants()) do
		if p:IsA("Part") or p:IsA("MeshPart") or p:IsA("UnionOperation") then
			table.insert(parts, p);
		end
	end
	task.wait();
end


local Values = require(workspace.Modules.Values);
local weaponid = Values:Fetch("weaponId");
local loaded = player.loaded;


local loadedParts = 0;

local percent = math.round((loadedParts/#parts)*100);

label.Text = "Loading.. ("..percent.."%)";

local character = player.Character or player.CharacterAdded:Wait();

character:MoveTo(Vector3.new(0, 0, 0))

game.ReplicatedStorage.GameEvents:WaitForChild("OnLoadRespawn"):FireServer();

local Revared = require(workspace.Modules.Revared);
local ContentProvider = game:GetService("ContentProvider")

local swait = 0;
local maxSwait = 1;

for i, part in ipairs(parts) do 
	local success = pcall(function()
		ContentProvider:PreloadAsync({part});
		
		repeat task.wait() until not freezeLoading
		
		if swait == maxSwait then
			wait();
			swait = 0
		else
			swait += 1
		end
		
		local percent = math.round((loadedParts/#parts)*100);
		
		loadedParts += 1
		label.Text = "Loading.. ("..percent.."%)";
	end)
	
	if not success then
		warn(Revared:GetDirectoryOf(part).." failed to load")
	end
	
	if loadedParts == #parts then
		loaded.Value = true;
		label.Text = "Loading.. (100%)";
	end
	
end