local GlobalHealing = {}
GlobalHealing.__index = GlobalHealing

local Values = require(workspace.Modules.Values);


local serverEvent = game.ReplicatedStorage.GlobalHealing.Server;
local victimEvent = game.ReplicatedStorage.GlobalHealing.Victim;


function GlobalHealing:Inflict(victim: Humanoid, amount, actionType, ...)
	local char = victim.Parent;
	local style = Values:Fetch("style"); -- 0 - 100

	local ace = actionType == "ace" and true or false

	serverEvent:FireServer(char, amount, ace, actionType, ... );
end


return GlobalHealing;