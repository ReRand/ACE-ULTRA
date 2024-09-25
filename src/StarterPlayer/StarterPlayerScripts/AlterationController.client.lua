local Values = require(workspace.Modules.Values);
local gravityAlter = Values:Fetch("GravityAlteration");
local baseGrav = workspace.Gravity


while task.wait(1) do
	if not gravityAlter.Value then workspace.Gravity = baseGrav; end
end