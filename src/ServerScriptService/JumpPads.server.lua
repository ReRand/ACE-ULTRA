local JumpPad = require(game.ReplicatedStorage.Modules.JumpPad);

local function init(descendants)
	for _, model in game.ReplicatedStorage:WaitForChild("Stored").Maps:GetDescendants() do
		if model:IsA("Model") and model:HasTag("JumpPad") then
			local jp = JumpPad.new(model);
			jp:Activate();
		end
	end
end


init(game.ReplicatedStorage:WaitForChild("Stored").Maps:GetDescendants());
init(game.ReplicatedStorage:WaitForChild("Assets"):GetDescendants())