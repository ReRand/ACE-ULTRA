local Trigger = {
	OutTypes = {
		Entered = 1;
		Exited = 2;
	}
};

Trigger.__index = Trigger;


local functions = script.Functions;
local main = script.Parent.Parent;


for _, f in ipairs(functions:GetChildren()) do
	require(f)(Trigger);
end


local Signal = require(script.Parent.Signal);
local sp = game:GetService("StarterPlayer");
local rep = game:GetService("ReplicatedStorage");
local rs = game:GetService("RunService");
local cs = game:GetService("CollectionService");



function Trigger.new(triggerPart, triggerSettings)
	local id = _G.Revared:GenerateId();
	local partId = _G.Revared:GenerateId();
	triggerPart.Transparency = 1;

	local tag = "Trigger?id="..tostring(id);
	cs:AddTag(triggerPart, tag);

	local Enabled = Instance.new("BoolValue", triggerPart);
	Enabled.Name = "TriggerEnabled";
	Enabled.Value = true;


	-- trigger data
	local self = setmetatable({

		-- basic data
		Id = id,
		Tag = tag,
		PartId = partId,
		PartName = triggerPart.Name,
		Part = triggerPart,
		Settings = triggerSettings,
		Enabled = Enabled,
		Running = false,

		-- events
		Entered = Signal.new(),
		Exited = Signal.new(),
		Activated = Signal.new(),
		Deactivated = Signal.new()

	}, Trigger);


	if triggerSettings then
		if triggerSettings.PartTransparency then
			triggerPart.Transparency = triggerSettings.PartTransparency;
		end
	end


	local ScriptFolders = nil;
	local PartFolders = nil;
	local EventFolders = nil;
	local PlayerHandler = nil;


	if not script.Handlers:FindFirstChild("TriggerScripts") then
		ScriptFolders = Instance.new("Folder", script.Handlers);
		ScriptFolders.Name = "TriggerScripts";
	else
		ScriptFolders = script.Handlers:FindFirstChild("TriggerScripts");
	end


	if (not rep:FindFirstChild("TriggerEvents")) then
		EventFolders = Instance.new("Folder", rep);
		EventFolders.Name = "TriggerEvents";
	else
		EventFolders = rep:FindFirstChild("TriggerEvents");
	end


	if (not workspace:FindFirstChild("TriggerPlayerHandler")) then
		PlayerHandler = script.Handlers.Player:Clone();
		PlayerHandler.Name = "TriggerPlayerHandler";
		PlayerHandler.Parent = workspace;
	else
		PlayerHandler = workspace:FindFirstChild("TriggerPlayerHandler");
	end


	local Scripts = Instance.new("Folder", ScriptFolders);
	local Events = Instance.new("Folder", EventFolders);

	Scripts.Name = id;
	Events.Name = id;

	local TriggerHandler = script.Handlers.Main:Clone();
	TriggerHandler.Name = "TriggerHandler";
	TriggerHandler.Parent = Scripts;
	TriggerHandler.Enabled = true;


	local inEvent = Instance.new("RemoteEvent", Events);
	inEvent.Name = "InEvent";
	local outEvent = Instance.new("RemoteEvent", Events);
	outEvent.Name = "OutEvent";


	local referInEvent = Instance.new("BindableEvent", Events);
	referInEvent.Name = "ReferInEvent";
	local referOutEvent = Instance.new("BindableEvent", Events);
	referOutEvent.Name = "ReferOutEvent";


	local playerHandler = Instance.new("RemoteEvent", EventFolders);
	playerHandler.Name = "PlayerHandler";


	self._inEvent = inEvent;
	self._outEvent = outEvent;

	self._referInEvent = referInEvent;
	self._referOutEvent = referOutEvent;

	self._playerHandler = playerHandler;


	return self;
end


return Trigger;
