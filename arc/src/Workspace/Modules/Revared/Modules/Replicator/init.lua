local RBXScriptSignal = require(script.Parent.Signal);


local Replicator = {
	ReplicatedClient = RBXScriptSignal.new(),
	ReplicatedServer = RBXScriptSignal.new()
}


local ReplicatedThing = {
	Event = RBXScriptSignal.new(),
	Activated = RBXScriptSignal.new()
}

ReplicatedThing.__index = ReplicatedThing;



function ReplicatedThing.new(thing)
	local self = setmetatable({}, ReplicatedThing);
	
	return self;
end

function ReplicatedThing:Activate()
	self.Activated:Fire();
end


local rs = game:GetService("RunService");
local Revared = require(workspace.Modules.Revared);


local serverFromClient = script.Events:WaitForChild("GetServerFromClient");
local clientFromServer = script.Events:WaitForChild("GetClientFromServer");


function Replicator:GetServer(thing: Instance, args)
	
	if rs:IsClient() then
		
		local dir = Revared:GetDirectoryOf(thing);
		
		serverFromClient:FireServer(dir, args);
		
		local player, inst = nil, nil;
		
		while task.wait() do
			player, inst = serverFromClient.OnClientEvent:Wait();
			
			if player == game.Players.LocalPlayer then
				break;
			end
		end
		
		local stuff = ReplicatedThing.new();

		stuff.Activated:Connect(function()
			stuff.Event:Fire(inst);
			self.ReplicatedServer:Fire(inst);
		end)

		return stuff;
		
	else
		local dir = Revared:GetDirectoryOf(thing);
		local inst = game;

		for _, d in ipairs(dir) do
			inst = inst[d];
		end

		for _, a in ipairs(args) do
			inst = inst[a];
		end

		local stuff = ReplicatedThing.new();
		
		stuff.Activated:Connect(function()
			stuff.Event:Fire(inst);
			self.ReplicatedServer:Fire(inst);
		end)
		
		return stuff;
	end
end


function Replicator:GetClient(player: Player, thing: Instance, args)

	if rs:IsServer() then

		local dir = Revared:GetDirectoryOf(thing);

		clientFromServer:FireClient(player, dir, args);

		local pl, inst = nil, nil;

		while task.wait() do
			pl, inst = clientFromServer.OnServerEvent:Wait();

			if pl == player then
				break;
			end
		end

		local stuff = ReplicatedThing.new();

		stuff.Activated:Connect(function()
			stuff.Event:Fire(inst);
			self.ReplicatedClient:Fire(inst);
		end)

		return stuff;

	else
		local dir = Revared:GetDirectoryOf(thing);
		local inst = game;

		for _, d in ipairs(dir) do
			inst = inst[d];
		end

		for _, a in ipairs(args) do
			inst = inst[a];
		end

		local stuff = ReplicatedThing.new();

		stuff.Activated:Connect(function()
			stuff.Event:Fire(inst);
			self.ReplicatedClient:Fire(inst);
		end)

		return stuff;
	end
end


return Replicator