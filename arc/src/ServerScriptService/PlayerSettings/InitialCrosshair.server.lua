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
		
		local srd1, red = req("PlayerData", "CrosshairColorRed", player.UserId);
		local sgr1, green = req("PlayerData", "CrosshairColorGreen", player.UserId);
		local sbl1, blue = req("PlayerData", "CrosshairColorBlue", player.UserId);
		local ssi1, size = req("PlayerData", "CrosshairSize", player.UserId);
		local str1, transparency = req("PlayerData", "CrosshairTransparency", player.UserId);
		
		
		if not red or not srd1 then
			red = 1;
			
			local srd2, err = post("PlayerData", "CrosshairColorRed", player.UserId, red);
			if not srd2 then print('crosshair red applier failed'); print(err); end
			red = 1;
		end
		
		if not green or not sgr1 then
			green = 1;
			
			local sgr2, err = post("PlayerData", "CrosshairColorGreen", player.UserId, green);
			if not sgr2 then print('crosshair green applier failed'); print(err); end
			green = 1
		end
		
		if not blue or not sbl1 then
			blue = 1;
			
			local sbl2, err = post("PlayerData", "CrosshairColorBlue", player.UserId, blue);
			if not sbl2 then print('crosshair blue applier failed'); print(err); end
			blue = 1;
		end
		
		if not size or not ssi1 then
			size = 0.5;
			
			local ssi2, err = post("PlayerData", "CrosshairSize", player.UserId, size);
			if not ssi2 then print('crosshair size applier failed'); print(err); end
		end
		
		if not transparency or not str1 then
			transparency = 0;
			
			local str2, err = post("PlayerData", "CrosshairTransparency", player.UserId, transparency);
			if not str2 then print('crosshair transparency applier failed'); print(err); end
		end
		

		player:WaitForChild("crosshairColor3").Value = Color3.new(red, blue, green);
		player:WaitForChild("crosshairSize").Value = size;
		player:WaitForChild("crosshairTransparency").Value = transparency;
		
	--end);
end);