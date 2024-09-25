local GlobalRagdoll = {
	States = {
		"GettingUp", "Jumping", "Freefall", "Climbing", "Swimming", "Running", "PlatformStanding"
	}
}
local ragdoll = game.ReplicatedStorage.GlobalRagdoll.Ragdoll
local unragdoll = game.ReplicatedStorage.GlobalRagdoll.UnRagdoll
local Values = require(workspace.Modules.Values);
local falldown = Values:Fetch("falldown");


function GlobalRagdoll:Ragdoll(humanoid: Humanoid)
	falldown.Value = true;
	humanoid.BreakJointsOnDeath = false
	humanoid.RequiresNeck = false
	
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	
	for _, state in pairs(GlobalRagdoll.States) do
		humanoid:SetStateEnabled(Enum.HumanoidStateType[state], false);
	end
	
	for _, part in pairs(humanoid.Parent:GetChildren()) do
		if (part:GetAttribute("CanCollide")) then
			part.CanCollide = true;
		end
	end
	
	local hrp = humanoid.Parent:WaitForChild("HumanoidRootPart");
	
	ragdoll:FireServer(humanoid.Parent);
end


function GlobalRagdoll:UnRagdoll(humanoid: Humanoid)
	falldown.Value = false;
	
	for _, state in pairs(GlobalRagdoll.States) do
		humanoid:SetStateEnabled(Enum.HumanoidStateType[state], true);
	end
	
	for _, part in pairs(humanoid.Parent:GetChildren()) do
		if (part:GetAttribute("CanCollide") and part.Name ~= "HumanoidRootPart") then
			part.CanCollide = false;
		end
	end
	
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	humanoid.BreakJointsOnDeath = true
	humanoid.RequiresNeck = true
		
	unragdoll:FireServer(humanoid.Parent);
end


return GlobalRagdoll
