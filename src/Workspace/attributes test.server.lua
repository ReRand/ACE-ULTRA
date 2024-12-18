local Attributes = require(game.ReplicatedStorage.Modules.Attributes);

Attributes.CharacterAttributed:Connect(function(eid, character, charattr : Configuration)
	
	print(`{character.Name} ({eid}), is player: {charattr:GetAttribute("isPlayer")}`);
	
	if charattr:GetAttribute("isPlayer") then
	
		local playerattr: Configuration = Attributes.FetchEntity(eid, "Players");
		print(`player id: {playerattr:GetAttribute("playerId")}`);
	end
end)