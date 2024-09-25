local ValuesFolder = workspace.Modules.Values.ValuesFolder.Value;
local BaseValues = {}


for _, s in pairs(ValuesFolder:GetChildren()) do
	BaseValues[s.Name] = {};
	local sec = BaseValues[s.Name];

	for _, v in pairs(s:GetChildren()) do
		sec[v.Name] = v.Value;
	end
end


local player = game.Players.LocalPlayer;
local character = player.Character or player.CharacterAdded:Wait();


player.CharacterAdded:Connect(function(character)
	for secName, sec in pairs(BaseValues) do
		for name, value in pairs(sec) do
			
			local v = ValuesFolder[secName][name];
			
			if not v:FindFirstChild("ignorereset") or (v:FindFirstChild("ignorereset") and not v:FindFirstChild("ignorereset").Value) then
				v.Value = value;
			end
		end
	end
end)