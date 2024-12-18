local PlayerLeaderboard = {}


local add = game.ReplicatedStorage.GameEvents:WaitForChild("AddPlayerToLeaderboard");
local rem = game.ReplicatedStorage.GameEvents:WaitForChild("RemovePlayerFromLeaderboard");


local players = game.Players


local player = players.LocalPlayer;
local spawned = player:WaitForChild("spawned");



function PlayerLeaderboard:GetTeamFromColor(color)
	for _, t in pairs(game.Teams:GetTeams()) do
		if t.TeamColor == color then
			return t;
		end
	end
end



function PlayerLeaderboard:FindPlayerGuiObject(pl)
	local gui = player.PlayerGui:WaitForChild("CoolGui"):WaitForChild("Middle"):WaitForChild("Playerlist")
	return gui:FindFirstChild(pl);
end


function PlayerLeaderboard:WaitForPlayerGuiObject(pl)
	local gui = player.PlayerGui:WaitForChild("CoolGui"):WaitForChild("Middle"):WaitForChild("Playerlist")
	return gui:WaitForChild(pl);
end



function PlayerLeaderboard:IsPlayerShown(pl)
	local gui = PlayerLeaderboard:FindPlayerGuiObject(pl);
	return gui and gui.Visible
end



function PlayerLeaderboard.AddPlayer(pl)
	print("added player to player leaderboard "..pl.Name.." ("..pl.UserId..")")

	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size420x420
	local thumb = players:GetUserThumbnailAsync(pl.UserId, thumbType, thumbSize)

	local gui = player.PlayerGui:WaitForChild("CoolGui"):WaitForChild("Middle"):WaitForChild("Playerlist")

	local background = gui:WaitForChild("Leaderboard"):WaitForChild("PlayersBgFrame"):WaitForChild("PlayersBoxFrame")

	local bp = gui:WaitForChild("BasePlayer");
	local portr = bp:Clone();

	local team = PlayerLeaderboard:GetTeamFromColor(pl.TeamColor);

	local colors = workspace.TeamColorGuiValues:FindFirstChild(team.Name);

	if colors then
		portr.BackgroundColor3 = colors.bg.Value;
	end

	portr.Label.Image = thumb;
	portr:SetAttribute("AdorneePlayerId", pl.UserId);
	portr.Parent = gui.Leaderboard.Players;
	portr.Name = (pl:WaitForChild("kills").Value)..pl.UserId;

	background.Size = UDim2.new(0, background.Size.X.Offset+150, background.Size.Y.Scale, 0)
	
	portr.Visible = true;
	
	return portr;
end



function PlayerLeaderboard.RemovePlayer(pl)
	print("removed player from player leaderboard "..pl.Name.." ("..pl.UserId..")")

	local gui = player.PlayerGui:WaitForChild("CoolGui"):WaitForChild("Middle"):WaitForChild("Playerlist")

	local background = gui:WaitForChild("Leaderboard"):WaitForChild("PlayersBgFrame"):WaitForChild("PlayersBoxFrame")

	for _, portr in pairs(gui.Leaderboard.Players:GetChildren()) do
		if portr:GetAttribute("AdorneePlayerId") and portr:GetAttribute("AdorneePlayerId") == pl.UserId then
			portr:Destroy();
		end
	end

	background.Size = UDim2.new(0, background.Size.X.Offset-150, background.Size.Y.Scale, 0)
end



function PlayerLeaderboard.UpdatePlayer(pl)
	if PlayerLeaderboard:IsPlayerShown(pl) then
		
	end
end


return PlayerLeaderboard;
