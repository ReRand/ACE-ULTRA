local dss = game:GetService("DataStoreService");
local Revared = require(workspace.Modules.Revared);
local glob = Revared:GetModule("PlayerGlob");


local function req(dataStore, scope, key)
	local store = dss:GetDataStore(dataStore, scope);
	return pcall(function() return store:GetAsync(tostring(key)); end)
end


local function post(dataStore, scope, key, data)
	local store = dss:GetDataStore(dataStore, scope);
	return pcall(function() store:SetAsync(tostring(key), data); end)
end


game.Players.PlayerAdded:Connect(function(player)
	
	--player:WaitForChild("loaded").Changed:Connect(function()
		
		local s1, level = req("PlayerData", "Levels", player.UserId);
		local s2, curExp = req("PlayerData", "CurrentExp", player.UserId);

		if not level or not s1 or not s2 then
			local s3, err1 = post("PlayerData", "Levels", player.UserId, 1);
			if not s3 then print('level applier failed'); print(err1); end

			local s4, err2 = post("PlayerData", "CurrentExp", player.UserId, 0);
			if not s4 then print('current exp applier failed'); print(err2); end;

			level = 1;
			curExp = 0;

		end

		local reqExp = 57 * level;

		player:WaitForChild("level").Value = level;
		player:WaitForChild("currentExp").Value = curExp;
		player:WaitForChild("requiredExp").Value = reqExp;
		
	--end);
end);