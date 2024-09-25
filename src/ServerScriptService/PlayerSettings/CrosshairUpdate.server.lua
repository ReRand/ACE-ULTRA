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
	local color = player:WaitForChild("crosshairColor3");
	local hold = player:WaitForChild("crosshairHold");
	local size = player:WaitForChild("crosshairSize");
	local transparency = player:WaitForChild("crosshairTransparency");
	
	
	local colorQueued = false;
	local transparencyQueued = false;
	local sizeQueued = false;
	
	
	color.Changed:Connect(function()
		
		if colorQueued then return end;
		
		if hold.Value then
			colorQueued = true;
			hold.Changed:Wait();
			colorQueued = false;
		end
		
		print("data store crosshair color updated");
		
		local srd, err = post("PlayerData", "CrosshairColorRed", player.UserId, color.Value.R);
		if not srd then print('crosshair red updater failed'); print(err); end
		
		local sgr, err = post("PlayerData", "CrosshairColorGreen", player.UserId, color.Value.G);
		if not sgr then print('crosshair green updater failed'); print(err); end
		
		local sbl, err = post("PlayerData", "CrosshairColorBlue", player.UserId, color.Value.B);
		if not sbl then print('crosshair blue updater failed'); print(err); end
	end)
	
	
	transparency.Changed:Connect(function()

		if transparencyQueued then return end;

		if hold.Value then
			transparencyQueued = true;
			hold.Changed:Wait();
			transparencyQueued = false;
		end

		print("data store crosshair transparency updated");

		local srd, err = post("PlayerData", "CrosshairTransparency", player.UserId, transparency.Value);
		if not srd then print('crosshair transparency updater failed'); print(err); end
	end)
	
	
	size.Changed:Connect(function()

		if sizeQueued then return end;

		if hold.Value then
			sizeQueued = true;
			hold.Changed:Wait();
			sizeQueued = false;
		end

		print("data store crosshair size updated");

		local srd, err = post("PlayerData", "CrosshairSize", player.UserId, size.Value);
		if not srd then print('crosshair size updater failed'); print(err); end
	end)
end)