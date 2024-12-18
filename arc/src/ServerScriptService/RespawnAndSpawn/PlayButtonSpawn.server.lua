repeat task.wait() until script;
repeat task.wait() until script.Parent;

math.randomseed(os.time())
math.random(); math.random(); math.random()

local reloc = game.ReplicatedStorage.GameEvents:WaitForChild("OnBootReloc")
local spwn = game.ReplicatedStorage.GameEvents:WaitForChild("OnPlaySpawn")
local firstBoot = game.ReplicatedStorage.GameEvents:WaitForChild("OnFirstBoot")

local Revared = require(workspace.Modules.Revared);
local glob = Revared:GetModule("PlayerGlob");


local get = game.ReplicatedStorage.GameEvents:WaitForChild("GetSkinId").Server


local function getSkinFolder(id)
	local skins = game.ReplicatedStorage:WaitForChild("Skins")
	for _, skin in pairs(skins:GetChildren()) do
		if skin:IsA("Folder") and (skin:FindFirstChild("id") and skin.id.Value == id) then
			return skin
		end
	end
end



-- local spawnloc = workspace:WaitForChild("LoaderSpawner");


reloc.OnServerEvent:Connect(function(player)
	local ocp = workspace.GameRoundMap.OverviewCameraPart;
	local point = workspace.GameRoundMap.DontTouchThisOrItllMoveTheCameraThanks.MapAttachment;
	local loaderPoint = workspace.GameRoundMap.DontTouchThisOrItllMoveTheCameraThanks.PlayerLoaderPlatformAttachment;
	local baseplate = workspace.GameRoundMap.Baseplate
	local loaderPlatform = workspace.GameRoundMap.PlayerLoaderPlatform;
	
	baseplate.CFrame = point.WorldCFrame;
	loaderPlatform.CFrame = loaderPoint.WorldCFrame;
	
	ocp.Position = workspace.GameRoundMap.Baseplate.Position + Vector3.new(0, 400, 0);
	
	reloc:FireClient(player, ocp.CFrame, loaderPlatform.Position)
end)


firstBoot.OnServerEvent:Connect(function()
	game.ReplicatedStorage.GameEvents.GameRoundMapLoading:WaitForChild("FirstBoot"):Fire();
end)


spwn.OnServerEvent:Connect(function(player, map)


	local function ChangeSpawn(mapModel)
		for _, s in pairs(mapModel.Spawns:GetChildren()) do
			if s.TeamColor == player.TeamColor then
				player.RespawnLocation = s;
				return true;
			end
		end
	end

	local function RandomClaim(mapModel)
		local spawns = {};

		for _, s in pairs(mapModel.Spawns:GetChildren()) do
			table.insert(spawns, s);
		end

		return spawns[math.random(1, #spawns)]
	end


	local spawnloc = workspace.GameRoundMap:WaitForChild("PlayerLoaderPlatform");


	if player.RespawnLocation == spawnloc and player.TeamColor ~= game.Teams.Loading.TeamColor and player.TeamColor ~= game.Teams.Spectator.TeamColor then
		local map = workspace.GlobalValues.Game.map.Value;
		local mapModel = map[map.Name];

		local changed = ChangeSpawn(mapModel);

		if not changed then
			player.RespawnLocation = RandomClaim();
		end
	end
	
	
	if workspace:FindFirstChild(player.Name) then
		workspace[player.Name]:Destroy();	
	end
	
	
	--[[get.Event:Connect(function(pl, id)

		local skinFolder = getSkinFolder(id);

		if skinFolder and player == pl then
			local model = skinFolder.SkinModel:Clone();
			model.Name = player.Name;
			model.Parent = workspace;
			
			local char = player.Character or player.CharacterAdded:Wait();
			
			local parts = {
				"Accessory",
				"Pants",
				"Shirt",
				"ShirtGraphic",
				"BodyColors",
			}
			
			
		end
	end)
	
	
	get:Fire(player)]]
	
	glob:Respawn(player);
end)