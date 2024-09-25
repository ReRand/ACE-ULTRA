local DataStoreService = game:GetService("DataStoreService");
local BadgeService = game:GetService("BadgeService");



local Server = require(script.Parent);



local request = script.Parent.Events.Request;
local post = script.Parent.Events.Post;
local out = script.Parent.Events.Out;


request.OnServerEvent:Connect(function(player, dataStore, scope, key)
	local store = DataStoreService:GetDataStore(dataStore, scope);
	
	
	local success, data = pcall(function()
		return store:GetAsync(tostring(key));
	end);
	
	
	out:FireClient(player, Server.Types.Request, data);
end)



post.OnServerEvent:Connect(function(player, dataStore, scope, key, data)
	local store = DataStoreService:GetDataStore(dataStore, scope);


	local success = pcall(function()
		return store:SetAsync(tostring(key), data);
	end);


	out:FireClient(player, Server.Types.Post, data);
end)