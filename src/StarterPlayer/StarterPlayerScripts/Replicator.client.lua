local events = workspace.Modules.Revared.Modules.Replicator.Events

local clientFromServer = events:WaitForChild("GetClientFromServer");
local Revared = require(workspace.Modules.Revared);


local player = game.Players.LocalPlayer;


clientFromServer.OnClientEvent:Connect(function(dir, args)
	local inst = game;

	for _, d in ipairs(dir) do
		inst = inst[d];
	end

	for _, a in ipairs(args) do
		inst = inst[a];
	end

	clientFromServer:FireServer(player, inst);
	return inst;
end)