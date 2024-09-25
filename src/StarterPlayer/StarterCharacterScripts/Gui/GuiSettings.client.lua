local Disabled = {
	"PlayerList", "EmotesMenu", "Backpack", "Health"
};


for _, dis in pairs(Disabled) do
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[dis], false);
end

local uis = game:GetService("UserInputService");


local camera = workspace.CurrentCamera
local player = game.Players.LocalPlayer


local mouse = player:GetMouse()


mouse.Icon = "rbxassetid://14013223911";
uis.MouseIconEnabled = true;
player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("crosshair").Visible = false;


repeat task.wait() until player:WaitForChild("spawned").Value;

uis.MouseIconEnabled = false;
player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("crosshair").Visible = true;