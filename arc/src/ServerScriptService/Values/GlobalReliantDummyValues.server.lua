local dummies = workspace:WaitForChild("Dummies");
local values = workspace.GlobalValues.Player;



local function AddData(dummy)
	local dd = dummy:FindFirstChild("DummyData");
	if not dd then
		dd = Instance.new("Folder", dummy);
		dd.Name = "DummyData";
	end

	local loaded = Instance.new("BoolValue", dd);
	loaded.Name = "valuesLoaded";
	loaded.Parent = dd;

	--script.RemoteEvent:FireClient(player, loaded)

	for i, v in pairs(values:GetChildren()) do
		local val = v:Clone()
		val.Parent = dd;
	end
	
	local teamColor = Instance.new("BrickColorValue", dd);
	teamColor.Value = game.Teams.Dummy.TeamColor
	teamColor.Name = "TeamColor";
	
	
	local displayName = Instance.new("StringValue", dd);
	displayName.Value = dummy:WaitForChild("Humanoid").DisplayName;
	displayName.Name = "DisplayName";
	

	loaded.Value = true;
end




dummies.ChildAdded:Connect(AddData)


for _, dummy in pairs(dummies:GetChildren()) do
	AddData(dummy);
end