--!strict



local Players = game:GetService("Players");
local Attributes = game.ReplicatedStorage.GameCore.Attributes
local ids = 0;


local att = require(game.ReplicatedStorage.Modules.Attributes);



-- attributes specifically for players that are deleted when the player is deleted

local PlayersAttributes = Attributes.Entities.Players
local PlayerMap = require(Attributes.AttributeMaps.Player);

local PlayerAttributes = PlayerMap.Defaults :: PlayerMap.Attributes



-- attributes specifically for characters that are deleted when the character is deleted

local CharactersAttributes = Attributes.Entities.Characters
local CharacterMap = require(Attributes.AttributeMaps.Character);

local CharacterAttributes = CharacterMap.Defaults :: CharacterMap.Attributes;



local function HandleModel(model : Model)
	if model:IsA("Model") and model:FindFirstChild("Humanoid") then
		local player = Players:GetPlayerFromCharacter(model);
		local id;

		if player then
			id = player:GetAttribute("EntityId");
			model:SetAttribute("EntityId", id);
		else
			id = tostring(ids);
			model:SetAttribute("EntityId", id);
			ids += 1;
		end
		
		local Config = Instance.new("Configuration");
		Config.Parent = CharactersAttributes;
		Config.Name = id;
		
		for k, v in pairs(CharacterAttributes) do
			Config:SetAttribute(k, v);
		end
		
		if player then
			Config:SetAttribute("playerId", player.UserId);
			Config:SetAttribute("isPlayer", true);
		end
		
		model.Destroying:Connect(function()
			Config:Destroy();
		end)
		
		att.CharacterAttributed:Fire(id, model, Config);
	end
end



for _, v in workspace:GetDescendants() do HandleModel(v); end
workspace.DescendantAdded:Connect(HandleModel);



Players.PlayerAdded:Connect(function(player)
	local id = tostring(ids)
	player:SetAttribute("EntityId", id);


	local Config = Instance.new("Configuration");
	Config.Parent = PlayersAttributes;
	Config.Name = id;


	for k, v in pairs(PlayerAttributes) do
		Config:SetAttribute(k, v);
	end
	
	
	Config:SetAttribute("playerId", player.UserId);
	
	
	player.Destroying:Connect(function()
		Config:Destroy();
	end)
	
	
	att.PlayerAttributed:Fire(id, player, Config);
end)