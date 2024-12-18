local uis = game:GetService("UserInputService")
local tcs = game:GetService("TextChatService");
local rs = game:GetService("RunService");
local Values = require(workspace.Modules.Values);

local typing = Values:Fetch("typing");
local dashing = Values:Fetch("dashing");

uis.InputBegan:Connect(function(Input, t)
	if t and Input.KeyCode ~= Enum.KeyCode.LeftShift then
		typing.Value = true
	else
		typing.Value = false;
	end
end)

rs.RenderStepped:Connect(function()
	if tcs.ChatInputBarConfiguration.IsFocused then
		typing.Value = true;
	else
		typing.Value = false;
	end
end)