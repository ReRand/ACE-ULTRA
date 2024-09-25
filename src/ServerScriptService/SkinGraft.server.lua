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


local sg = require(script.Parent.Modules.SkinGraft);


update.Event:Connect(sg.UpdatePlayerSkin);


getSidClient.OnServerEvent:Connect(function(...) sg.GetSkinId(..., 2) end);
getSidServer.Event:Connect(function(...) sg.GetSkinId(..., 3) end);

getModelClient.OnServerEvent:Connect(function(...) sg.GetSkinModelForPlayer(..., 2) end);
getModelServer.Event:Connect(function(...) sg.GetSkinModelForPlayer(..., 3) end);


game.Players.PlayerAdded:Connect(function(player)
	local spawned = player:WaitForChild("spawned");
	local loaded = player:WaitForChild("loaded");
	
	loaded.Changed:Connect(function()
		if loaded.Value then
			sg.UpdatePlayerSkin(player)
		end
	end)
	
	spawned.Changed:Connect(function()
		if spawned.Value then
			sg.UpdatePlayerSkin(player)
		end
	end)
end)