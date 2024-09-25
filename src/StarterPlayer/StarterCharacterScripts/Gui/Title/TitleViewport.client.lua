repeat task.wait() until game:IsLoaded();

local players = game.Players;
local player = players.LocalPlayer;
local loaded = player:WaitForChild("loaded");

repeat task.wait() until loaded.Value


local vmf = player.PlayerGui:WaitForChild("CoolTitleGui").Right.Surf.playervm.ViewportFrame

if vmf:WaitForChild("WorldModel"):FindFirstChild("TitleViewportPlayerModel") then
	vmf:WaitForChild("Camera"):Destroy();
	vmf:WaitForChild("WorldModel"):FindFirstChild("TitleViewportPlayerModel"):Destroy();	
end
	
if vmf:FindFirstChild("Camera") then
	vmf:WaitForChild("Camera"):Destroy();
	vmf:WaitForChild("WorldModel"):FindFirstChild("TitleViewportPlayerModel"):Destroy();	
end


local get = game.ReplicatedStorage.GameEvents.GetSkinId.Client


local function getSkinFolder(id)
	local skins = game.ReplicatedStorage:WaitForChild("Skins")
	for _, skin in pairs(skins:GetChildren()) do
		if skin:IsA("Folder") and (skin:FindFirstChild("id") and skin.id.Value == id) then
			return skin
		end
	end
end


get.OnClientEvent:Connect(function(pl, id)
	
	local skinFolder = getSkinFolder(id);
	
	if skinFolder and player == pl then
		local character = skinFolder:WaitForChild("SkinModel"):Clone();
		character.Name = "TitleViewportPlayerModel";
		character.Parent = workspace;

		local hrp = character:WaitForChild("HumanoidRootPart");
		hrp.Anchored = true;

		local cameraPart = workspace.CoolTitleGui:WaitForChild("PlayerVmCameraPart");

		local restPoint = cameraPart.CFrame;

		cameraPart.Anchored = false;
		cameraPart.Weld.Part0 = hrp;
		local cam = Instance.new("Camera", vmf);

		-- vmf.LightDirection = cameraPart.CFrame.LookVector;

		cam.CFrame = cameraPart.CFrame;
		vmf.CurrentCamera = cam;
		character.Parent = vmf:WaitForChild("WorldModel");
	end
end)


get:FireServer()