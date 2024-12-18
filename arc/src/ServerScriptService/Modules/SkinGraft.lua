local SkinGraft = {}

local dss = game:GetService("DataStoreService");
local Revared = require(workspace.Modules.Revared);
local glob = Revared:GetModule("PlayerGlob");


local events = game.ReplicatedStorage.GameEvents

local update = events.UpdateSkin
local cc = events.ChangeCharacter

local getSidClient = events.GetSkinId.Client
local getSidServer = events.GetSkinId.Server


local getModelClient = events.GetSkinModel.Client
local getModelServer = events.GetSkinModel.Server



local function req(dataStore, scope, key)
	local store = dss:GetDataStore(dataStore, scope);
	return pcall(function() return store:GetAsync(tostring(key)); end)
end


local function post(dataStore, scope, key, data)
	local store = dss:GetDataStore(dataStore, scope);
	return pcall(function() store:SetAsync(tostring(key), data); end)
end



function SkinGraft.GetSkinFolder(id)
	local skins = game.ReplicatedStorage:WaitForChild("Skins")
	for _, skin in pairs(skins:GetChildren()) do
		if skin:IsA("Folder") and (skin:FindFirstChild("id") and skin.id.Value == id) and skin:FindFirstChild("active").Value then
			return skin
		end
	end
end



function SkinGraft.GetSkinId(player, context)
	local success, skinId = req("PlayerData", "SkinIds", player.UserId)

	if not skinId or not success then
		local success = post("PlayerData", "SkinIds", player.UserId, 1);
		if not success then print('skin applier failed'); return end

		skinId = 1;
	end

	if not context or context == 1 then
		return skinId;
	elseif context == 2 then
		getSidClient:FireClient(player, player, skinId)
	elseif context == 3 then
		getSidServer:Fire(player, skinId)
	end
end



function SkinGraft.GetSkinModelForPlayer(player, context)
	local skinId = SkinGraft.GetSkinId(player, 1);

	local skin = SkinGraft.GetSkinFolder(skinId);

	player:WaitForChild("skinId").Value = skinId;

	local model = skin.SkinModel:Clone()

	if not context or context == 1 then
		return model
	elseif context == 2 then
		getModelClient:FireClient(player, player, model)
	elseif context == 3 then
		getModelServer:Fire(player, model)
	end
end



function SkinGraft.UpdatePlayerSkin(player)
	--[[local character = player.Character or player.CharacterAdded:Wait();
	if not player:HasAppearanceLoaded() then player.CharacterAppearanceLoaded:Wait() end

	local skinId = SkinGraft.GetSkinId(player, 1);

	local skin = SkinGraft.GetSkinFolder(skinId);

	player:WaitForChild("skinId").Value = skinId;

	local character = player.Character or player.CharacterAdded:Wait();
	local hrp = character:WaitForChild("HumanoidRootPart");

	local model = skin.SkinModel:Clone();
	model.Parent = workspace;

	character:WaitForChild("Humanoid"):Clone().Parent = model;
	model:WaitForChild("Humanoid"):Destroy();
	model:WaitForChild("Animate"):Destroy();

	model.Name = player.Name;

	local mhrp = model:WaitForChild("HumanoidRootPart");
	mhrp.CFrame = hrp.CFrame;

	player.Character = model;
	
	--repeat task.wait() until player.Character == model;
	
	--glob:Respawn(player);

	-- game.ReplicatedStorage.GameEvents.ChangeCharacter:FireClient(player, model);
	
	task.wait(0.05);

	for _, s in pairs(game.StarterPlayer.StarterCharacterScripts:GetChildren()) do
		s:Clone().Parent = model;
	end


	--[[local chuman = nil;
	
	repeat task.wait(0.5) until (function()
		local chuman = character:WaitForChild("Humanoid");
		return chuman;
	end)
	
	local mhuman = model:WaitForChild("Humanoid");
	
	print(mhuman:GetAppliedDescription())
	
	repeat task.wait(0.5) until pcall(function() chuman:ApplyDescription(mhuman:GetAppliedDescription()); end)
	
	model:Destroy();
	
	glob:RespawnWithDescription(player, mhuman:GetAppliedDescription())]]
end



return SkinGraft
