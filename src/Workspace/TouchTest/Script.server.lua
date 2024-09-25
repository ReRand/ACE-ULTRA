local Revared = require(workspace.Modules.Revared);
local TouchGenius = Revared:GetModule("TouchGenius");


local tg = TouchGenius.new(script.Parent);


tg.PlayerTouched:Connect(function(res)
	print(res.Instance);
end)