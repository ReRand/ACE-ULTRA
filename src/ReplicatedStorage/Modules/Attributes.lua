--!strict


local GameAttributes = game.ReplicatedStorage.GameCore.Attributes;
local Events = game.ReplicatedStorage.GameCore.Events.Attributes;
local Signal = require(script.Parent.Signal);
local rs = game:GetService("RunService");


if not _G.Attributes then

	_G.Attributes = {
		PlayerAttributed = Signal.new(),
		CharacterAttributed = Signal.new()
	};


	if rs:IsServer() then

		_G.Attributes.PlayerAttributed:Connect(function(...)
			Events.PlayerAttributed:FireAllClients(...);
		end)
		
		_G.Attributes.CharacterAttributed:Connect(function(...)
			Events.CharacterAttributed:FireAllClients(...);
		end)

	end
end


local Attributes = {
	PlayerAttributed = _G.Attributes.PlayerAttributed,
	CharacterAttributed = _G.Attributes.CharacterAttributed
};



function Attributes.FetchEntity(entityId : string, sub : string?) : { [string] : Configuration }?
	if sub then
		local folder = GameAttributes.Entities:FindFirstChild(sub)
		return folder:WaitForChild(entityId);
	end
	
	local data = {}
	
	for _, folder in GameAttributes.Entities:GetChildren() do
		data[folder.Name] = folder:WaitForChild(entityId);
	end
	
	-- if it has content then return it if it doesn't then return nothing
	
	for _ in pairs(data) do
		return data;
	end
	return;
end



function Attributes.FetchEntityFromInstance(instance: Instance, sub : string?) : { [string] : Configuration }?
	return Attributes.FetchEntity(instance:GetAttribute("EntityId"), sub);
end



function Attributes.FetchEntityFromUUID(uuid: string, sub : string?) : { [string] : Configuration }?
	for _, inst in game:GetDescendants() do if inst:GetAtrtribute("EntityId") == uuid then return Attributes.FetchEntityFromInstance(inst, sub); end end
	return;
end



function Attributes.FetchEntityFromPlayerId(playerId : string, sub : string?) : { [string] : Configuration }?
	for _, player in GameAttributes.Entities.Players:GetChildren() do
		print(player:GetAttribute("playerId"), playerId)
		if player:GetAttribute("playerId") == playerId then
			local eid = player.Name;
			
			return Attributes.FetchEntity(eid, sub);
		end
	end
	
	return;
end



return Attributes