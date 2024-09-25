local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("spawned").Value;
task.wait(0.2)


local rs = game:GetService("RunService");


local thing = player.PlayerGui:WaitForChild("CoolGui").Middle.Playerlist.Leaderboard.GamemodeBoxFrame.gmname;


local function GetGamemodeFromId(id)
	for i, gm in ipairs(game.ReplicatedStorage:WaitForChild("Gamemodes"):GetChildren()) do
		if gm.id.Value == id then
			return gm;
		end
	end
end


repeat task.wait() until workspace.GlobalValues.Game.started.Value;


local id = workspace.GlobalValues.Game.gmId;

thing.Text = GetGamemodeFromId(id.Value).Name