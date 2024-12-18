local player = game.Players.LocalPlayer;
local mgm = player.PlayerGui:WaitForChild("MobileGuiMock")

for _, gui in pairs(mgm:GetChildren()) do
	if gui:IsA("ScreenGui") then
		gui.Enabled = false;
	end
end