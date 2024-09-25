local player = game.Players.LocalPlayer;

local color = player:WaitForChild("crosshairColor3");
local size = player:WaitForChild("crosshairSize");
local transparency = player:WaitForChild("crosshairTransparency");



repeat task.wait() until player:WaitForChild("loaded").Value


local crosshair = require(script.Parent.Parent.Parent.Modules.Crosshair);


color.Changed:Connect(crosshair.UpdateColor);
transparency.Changed:Connect(crosshair.UpdateTransparency);
size.Changed:Connect(crosshair.UpdateSize);


crosshair.UpdateColor();
crosshair.UpdateTransparency();
crosshair.UpdateSize();