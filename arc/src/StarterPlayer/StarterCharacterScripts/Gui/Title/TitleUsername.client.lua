local player = game.Players.LocalPlayer;
local loaded = player:WaitForChild("loaded");

repeat task.wait() until loaded.Value

player.PlayerGui:WaitForChild("CoolTitleGui").Left.Surf.Frame.player.Text = player.DisplayName;