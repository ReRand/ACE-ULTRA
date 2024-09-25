local players = game.Players

local localplayer = players.LocalPlayer;
local spawned = localplayer:WaitForChild("spawned");
local loaded = localplayer:WaitForChild("loaded");

repeat task.wait() until loaded.Value;


local add = game.ReplicatedStorage.GameEvents:WaitForChild("AddKillFeedItem");
local rem = game.ReplicatedStorage.GameEvents:WaitForChild("RemoveKillFeedItem");
local gettc = game.ReplicatedStorage.GameEvents:WaitForChild("GetTeamColor");
local gottc = game.ReplicatedStorage.GameEvents:WaitForChild("GotTeamColor");

local KillFeed = require(workspace.Modules:WaitForChild("KillFeed"));



local function GetName(player)
	if not player then return "JohnDoe" end;
	return ((typeof(player.DisplayName) == "Instance" and player.DisplayName:IsA("StringValue")) and player.DisplayName.Value or player.DisplayName);
end


local function GetTeamColor(player)
	if not player then return BrickColor.new("Medium stone grey") end
	local tc = BrickColor.new("Medium stone grey");
	
	if player ~= localplayer and (typeof(player) == "Player" or not (typeof(player.TeamColor) == "Instance" and player.TeamColor:IsA("BrickColorValue"))) then
		
		local waiting = false;
		
		coroutine.wrap(function()
			tc = gottc.OnClientEvent:Wait();
			waiting = false
		end)()
		
		gettc:FireServer(player);
		waiting = true;
		
		repeat task.wait() until not waiting;
		
	else
		tc = ((typeof(player.TeamColor) == "Instance" and player.TeamColor:IsA("BrickColorValue")) and player.TeamColor.Value or player.TeamColor)
	end
	
	return tc;
end


local function GetTeam(color)
	for _, team in pairs(game.Teams:GetTeams()) do
		if team.TeamColor == color then return team end;
	end
end



local function Filter(colors, g)
	local baseTmod = 0;
	
	if g:IsA("Frame") and string.match(g.Name, "BoxFrame") then

		local tmod = baseTmod;

		if g:FindFirstChild("transparency") then
			tmod += g.transparency.Value;
		end

		g.BackgroundColor3 = colors.bg.Value;
		g.BorderColor3 = colors.border.Value;

		if g:FindFirstChild("UIStroke") then
			g.UIStroke.Color = colors.border.Value;
			g.UIStroke.Transparency = colors.transparency.Value + tmod/2;
		end

		g.BackgroundTransparency = colors.transparency.Value + tmod;

	elseif g:IsA("TextLabel") then
		--g.TextColor3 = colors.text.Value;
		g.TextColor3 = Color3.new(255,255,255)

		if colors:FindFirstChild("stroke") then
			g.TextStrokeColor3 = colors.text.Value;
			g.TextStrokeTransparency = 0
		else
			g.TextStrokeTransparency = 1;
		end

		local tmod = baseTmod;

		if g:FindFirstChild("transparency") then
			tmod += g.transparency.Value;
		end

		g.BackgroundColor3 = colors.bg.Value;
		g.BorderColor3 = colors.border.Value;

		if g:FindFirstChild("UIStroke") then
			g.UIStroke.Color = colors.border.Value;
			g.UIStroke.Transparency = colors.transparency.Value + tmod/2;
		end

		g.BackgroundTransparency = colors.transparency.Value + tmod;
	end
	
	coroutine.wrap(function()
		for _, g in pairs(g:GetDescendants()) do

			if g:IsA("Frame") and string.match(g.Name, "BoxFrame") then

				local tmod = baseTmod;

				if g:FindFirstChild("transparency") then
					tmod += g.transparency.Value;
				end

				g.BackgroundColor3 = colors.bg.Value;
				g.BorderColor3 = colors.border.Value;

				if g:FindFirstChild("UIStroke") then
					g.UIStroke.Color = colors.border.Value;
					g.UIStroke.Transparency = colors.transparency.Value + tmod/2;
				end

				g.BackgroundTransparency = colors.transparency.Value + tmod;

			elseif g:IsA("TextLabel") then
				--g.TextColor3 = colors.text.Value;

				if colors:FindFirstChild("stroke") then
					g.TextStrokeColor3 = colors.text.Value;
					g.TextStrokeTransparency = 0
				else
					g.TextStrokeTransparency = 1;
				end

				local tmod = baseTmod;

				if g:FindFirstChild("transparency") then
					tmod += g.transparency.Value;
				end

				g.BackgroundColor3 = colors.bg.Value;
				g.BorderColor3 = colors.border.Value;

				if g:FindFirstChild("UIStroke") then
					g.UIStroke.Color = colors.border.Value;
					g.UIStroke.Transparency = colors.transparency.Value + tmod/2;
				end

				g.BackgroundTransparency = colors.transparency.Value + tmod;
			end
		end
	end)()
end


local function TeamColorer(player, gui)
	local teamColor = GetTeamColor(player);

	local team = GetTeam(teamColor);

	if team then
		
		local colors = workspace:WaitForChild("TeamColorGuiValues"):FindFirstChild(team.Name);

		if colors then
			Filter(colors, gui)
		end
	end
end



local function WeaponImager(weaponId, gui)
	coroutine.wrap(function()
		for _, w in pairs(game.StarterPlayer.StarterCharacterScripts.Weapons:GetChildren()) do
			if w:FindFirstChild("id") and w.id.Value == weaponId and w:FindFirstChild("image") then
				gui.Image = w.image.Image;
			end
		end
	end)()
end




add.OnClientEvent:Connect(function(kf)
	
	local gui = localplayer.PlayerGui:WaitForChild("CoolGui"):WaitForChild("KillFeed");
	local list = gui:WaitForChild("feed");
	local base = gui:WaitForChild("Base");
	
	
	local fetchTyped = KillFeed.Types()[kf.Type];
	local typed = fetchTyped:Clone();
	typed.Parent = list.items;
	typed.LayoutOrder = -(#(list.items:GetChildren())+1);
	
	-- print(kf.Type);
	
	local function AssistFinishKill(letter1, letter2)

		if not letter1 then letter1 = "a"; end
		if not letter2 then letter2 = "d"; end

		local player1 = typed[letter1.."Player1"];
		local player2 = typed[letter2.."Player2"];

		player1.Text = GetName(kf.AttackerPlayer);
		player2.Text = GetName(kf.VictimPlayer);

		coroutine.wrap(function()
			TeamColorer(kf.AttackerPlayer, player1);
		end)()
		
		coroutine.wrap(function()
			TeamColorer(kf.VictimPlayer, player2);
		end)()
	end
	
	
	local function WeaponKill(letter1, letter2, letter3)
		
		if not letter1 then letter1 = "a"; end
		if not letter2 then letter2 = "d"; end
		if not letter3 then letter3 = "b"; end
		
		local player1 = typed[letter1.."Player1"];
		local player2 = typed[letter2.."Player2"];
		local weapon = typed[letter3.."Weapon"];

		player1.Text = GetName(kf.AttackerPlayer);
		player2.Text = GetName(kf.VictimPlayer);
		
		coroutine.wrap(function()
			TeamColorer(kf.AttackerPlayer, player1);
		end)()
		
		coroutine.wrap(function()
			TeamColorer(kf.VictimPlayer, player2);
		end)()
		
		coroutine.wrap(function()
			WeaponImager(kf.Weapon, weapon);
		end)()
	end
	
	
	local function AssistWeaponKill(letter1, letter2, letter3, letter4)
		
		if not letter1 then letter1 = "a"; end
		if not letter2 then letter2 = "c"; end
		if not letter3 then letter3 = "f"; end
		if not letter4 then letter4 = "d"; end
		
		local player1 = typed[letter1.."Player1"];
		local player2 = typed[letter2.."Player2"];
		local player3 = typed[letter3.."Player3"];
		local weapon = typed[letter4.."Weapon"];

		player1.Text = GetName(kf.AttackerPlayer);
		player2.Text = GetName(kf.AssistPlayer);
		player3.Text = GetName(kf.VictimPlayer);
		
		coroutine.wrap(function()
			TeamColorer(kf.AttackerPlayer, player1);
		end)()
		
		coroutine.wrap(function()
			TeamColorer(kf.AssistPlayer, player2);
		end)()
		
		coroutine.wrap(function()
			TeamColorer(kf.VictimPlayer, player3);
		end)()
		
		coroutine.wrap(function()
			WeaponImager(kf.Weapon, weapon);
		end)()
	end
	
	
	
	local function ReasonKill(letter1, letter2)
		if not letter1 then letter1 = "b"; end
		if not letter2 then letter2 = "c"; end
		
		local player = typed[letter1.."Player"];
		local reason = typed[letter2.."Reason"];

		player.Text = GetName(kf.VictimPlayer);
		reason.Text = KillFeed:GetMessage(kf.Reason);

		coroutine.wrap(function()
			TeamColorer(kf.VictimPlayer, player);
		end)()
	end
	
	
	local function SelfKill(letter1)
		if not letter1 then letter1 = "b"; end

		local player = typed[letter1.."Player"];

		player.Text = GetName(kf.VictimPlayer);

		coroutine.wrap(function()
			TeamColorer(kf.VictimPlayer, player);
		end)()
	end
	
	
	local function SelfWeaponKill(letter1, letter2)
		if not letter1 then letter1 = "b"; end
		if not letter2 then letter2 = "c"; end

		local player = typed[letter1.."Player"];
		local weapon = typed[letter2.."Weapon"];

		player.Text = GetName(kf.VictimPlayer);

		coroutine.wrap(function()
			TeamColorer(kf.VictimPlayer, player);
		end)()
		
		coroutine.wrap(function()
			WeaponImager(kf.Weapon, weapon);
		end)()
	end
	
	
	
	if kf.Type == 1 then -- WeaponKill
		WeaponKill()
		
	elseif kf.Type == 2 then -- ReasonKill
		ReasonKill();
	
	elseif kf.Type == 3 then -- AssistWeaponKill
		AssistWeaponKill();
		
	elseif kf.Type == 4 then -- AssistFinishKill
		AssistFinishKill();
		
	elseif kf.Type == 5 then -- AssistFinishWeaponKill
		WeaponKill("a", "e");
	
	elseif kf.Type == 6 then -- SelfWeaponKill
		SelfKill("b");
	
	elseif kf.Type == 7 then -- SelfKill
		SelfWeaponKill("b", "c")
	end
	
	
	task.delay(5, function()
		if typed then
			typed:Destroy();
		end
	end)
end)



rem.OnClientEvent:Connect(function(kf)
	print(kf);
end)