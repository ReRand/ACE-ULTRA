local GlobalDamage = {}
GlobalDamage.__index = GlobalDamage

local Values = require(workspace.Modules.Values);


local serverEvent = game.ReplicatedStorage.GlobalDamage.Server;
local victimEvent = game.ReplicatedStorage.GlobalDamage.Victim;


function GlobalDamage:Inflict(victim: Humanoid, damage, actionType, ...)
	local char = victim.Parent;
	local style = Values:Fetch("style"); -- 0 - 100

	local ace = actionType == "ace" and true or false

	serverEvent:FireServer(char, damage, ace, actionType, ... );
end


return GlobalDamage;