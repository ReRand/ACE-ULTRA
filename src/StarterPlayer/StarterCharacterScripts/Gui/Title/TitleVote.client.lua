local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("loaded").Value;

local events = game.ReplicatedStorage.GameEvents.GameRoundMapLoading;

local mapVote = events:WaitForChild("MapVote");
local mapUnvote = events:WaitForChild("MapUnvote");
local mapVoteEnd = events:WaitForChild("MapVoteEnd");
local gmVote = events:WaitForChild("GamemodeVote");
local gmUnvote = events:WaitForChild("GamemodeUnvote");
local gmVoteEnd = events:WaitForChild("GamemodeVoteEnd");


local ts = game:GetService("TweenService");

local vv = workspace.GlobalValues.Vote;

local mapA = vv:WaitForChild("mapA");
local mapB = vv:WaitForChild("mapB");
local mapC = vv:WaitForChild("mapC");

local gmA = vv:WaitForChild("gmA");
local gmB = vv:WaitForChild("gmB");
local gmC = vv:WaitForChild("gmC");

local voting = vv:WaitForChild("itsSoHappening");
local mapVoting = vv:WaitForChild("mapVoteHappening");
local gmVoting = vv:WaitForChild("gmVoteHappening");


local gui = player.PlayerGui:WaitForChild("CoolTitleGui").Right.Surf.Vote.Selec;
local guiMA = gui.mapA;
local guiMB = gui.mapB;
local guiMC = gui.mapC;


local guiGMA = gui.gmA;
local guiGMB = gui.gmB;
local guiGMC = gui.gmC;


mapA.name.Changed:Connect(function() guiMA.mapname.Text = mapA.name.Value; end)
mapB.name.Changed:Connect(function() guiMB.mapname.Text = mapB.name.Value; end)
mapB.name.Changed:Connect(function() guiMB.mapname.Text = mapB.name.Value; end)


gmA.name.Changed:Connect(function() guiGMA.gmname.Text = gmA.name.Value; end)
gmB.name.Changed:Connect(function() guiGMB.gmname.Text = gmB.name.Value; end)
gmB.name.Changed:Connect(function() guiGMC.gmname.Text = gmB.name.Value; end)


mapA.icon.Changed:Connect(function() guiMA.icon.Image = mapA.icon.Value.Image; end)
mapB.icon.Changed:Connect(function() guiMB.icon.Image = mapB.icon.Value.Image; end)
mapB.icon.Changed:Connect(function() guiMB.icon.Image = mapB.icon.Value.Image; end)


gmA.icon.Changed:Connect(function() guiGMA.icon.Image = gmA.icon.Value.Image; end)
gmB.icon.Changed:Connect(function() guiGMB.icon.Image = gmB.icon.Value.Image; end)
gmB.icon.Changed:Connect(function() guiGMC.icon.Image = gmB.icon.Value.Image; end)


local votedMap = nil;
local votedGM = nil;


gui.Parent.Visible = false;


local function VoteMapStart()
	local trem = vv.voteTime.Value;


	for _, choice in pairs(gui:GetChildren()) do
		if choice:IsA("Frame") then

			choice.BorderColor3 = Color3.fromRGB(24, 137, 185);
			choice.BorderSizePixel = 4

			choice.icon.ImageTransparency = 0;
			choice.icon.BackgroundTransparency = 0;

			choice.Transparency = 0.6

			choice.votes.TextTransparency = 0;
			choice.votes.BackgroundTransparency = 0.5

			if choice:FindFirstChild('mapname') then
				choice.mapname.TextTransparency = 0;
				choice.mapname.BackgroundTransparency = 0.5
			elseif choice:FindFirstChild("gmname") then
				choice.gmname.TextTransparency = 0;
				choice.gmname.BackgroundTransparency = 0.5
			end

		end
	end

	gui.Parent.Visible = true;

	guiGMA.Visible = false;
	guiGMB.Visible = false;
	guiGMC.Visible = false;

	guiMA.Visible = true;
	guiMB.Visible = true;
	guiMC.Visible = true;

	guiMA.icon.Interactable = true;
	guiMB.icon.Interactable = true;
	guiMC.icon.Interactable = true;

	guiGMA.icon.Interactable = false;
	guiGMB.icon.Interactable = false;
	guiGMC.icon.Interactable = false;

	guiMA.icon.Image = mapA.icon.Value.Image;
	guiMB.icon.Image = mapB.icon.Value.Image;
	guiMC.icon.Image = mapC.icon.Value.Image;

	guiMA.mapname.Text = mapA.name.Value;
	guiMB.mapname.Text = mapB.name.Value;
	guiMC.mapname.Text = mapC.name.Value;

	mapA.votes.Changed:Connect(function() guiMA.votes.Text = mapA.votes.value; end)
	mapB.votes.Changed:Connect(function() guiMB.votes.Text = mapB.votes.value; end)
	mapC.votes.Changed:Connect(function() guiMC.votes.Text = mapC.votes.value; end)

	mapA.votes.Value = 0;
	mapB.votes.Value = 0;
	mapC.votes.Value = 0;
end



local function VoteGamemodeStart()
	local trem = vv.voteTime.Value;

	for _, choice in pairs(gui:GetChildren()) do
		if choice:IsA("Frame") then

			choice.BorderColor3 = Color3.fromRGB(24, 137, 185);

			choice.icon.ImageTransparency = 0;
			choice.icon.BackgroundTransparency = 0;
			choice.icon.ImageColor3 = Color3.new(1, 1, 1);

			choice.Transparency = 0.6

			choice.votes.TextTransparency = 0;
			choice.votes.BackgroundTransparency = 0.5

			if choice:FindFirstChild('mapname') then
				choice.mapname.TextTransparency = 0;
				choice.mapname.BackgroundTransparency = 0.5
			elseif choice:FindFirstChild("gmname") then
				choice.gmname.TextTransparency = 0;
				choice.gmname.BackgroundTransparency = 0.5
			end
		end
	end

	gui.Parent.Visible = true;

	guiGMA.Visible = true;
	guiGMB.Visible = true;
	guiGMC.Visible = true;

	guiMA.Visible = false;
	guiMB.Visible = false;
	guiMC.Visible = false;

	guiMA.icon.Interactable = false;
	guiMB.icon.Interactable = false;
	guiMC.icon.Interactable = false;

	guiGMA.icon.Interactable = true;
	guiGMB.icon.Interactable = true;
	guiGMC.icon.Interactable = true;

	print(guiGMA.icon, gmA.icon.Value);

	guiGMA.icon.Image = gmA.icon.Value.Image;
	guiGMB.icon.Image = gmB.icon.Value.Image;
	guiGMC.icon.Image = gmC.icon.Value.Image;

	guiGMA.gmname.Text = gmA.name.Value;
	guiGMB.gmname.Text = gmB.name.Value;
	guiGMC.gmname.Text = gmC.name.Value;

	gmA.votes.Changed:Connect(function() guiGMA.votes.Text = gmA.votes.value; end)
	gmB.votes.Changed:Connect(function() guiGMB.votes.Text = gmB.votes.value; end)
	gmC.votes.Changed:Connect(function() guiGMC.votes.Text = gmC.votes.value; end)

	gmA.votes.Value = 0;
	gmB.votes.Value = 0;
	gmC.votes.Value = 0;
end



if mapVoting.Value then
	VoteMapStart();
end

mapVote.OnClientEvent:Connect(VoteMapStart);


if gmVoting.Value then
	VoteGamemodeStart();
end


gmVote.OnClientEvent:Connect(VoteGamemodeStart);


local votedForMap = false;
local votedForGamemode = false;


local function VoteMap(thing, alph)
	if not votedForMap and mapVoting.Value then
		ts:Create(thing, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
			BorderColor3 = Color3.fromRGB(0, 255);
			BorderSizePixel = 10
		}):Play();
		
		if voting.Value then
			mapVote:FireServer(alph);
		end
		
		votedForMap = true;
		votedMap = alph;
		
	elseif votedForMap and mapVoting.Value and votedMap ~= alph then
		
		local old = gui:WaitForChild("map"..string.upper(votedMap));
		
		ts:Create(thing, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
			BorderColor3 = Color3.fromRGB(0, 255);
			BorderSizePixel = 10
		}):Play();
		
		ts:Create(old, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
			BorderColor3 = Color3.fromRGB(24, 137, 185);
			BorderSizePixel = 4
		}):Play();

		if voting.Value then
			mapUnvote:FireServer(votedMap);
			mapVote:FireServer(alph);
		end

		votedForMap = true;
		votedMap = alph;
	end
end


local function VoteGamemode(thing, alph)
	if not votedForGamemode and gmVoting.Value then
		ts:Create(thing, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
			BorderColor3 = Color3.fromRGB(0, 255);
			BorderSizePixel = 10
		}):Play();

		if voting.Value then
			gmVote:FireServer(alph);
		end

		votedForGamemode = true;
		votedGM = alph;
		
	elseif votedForGamemode and gmVoting.Value and votedGM ~= alph then

		local old = gui:WaitForChild("gm"..string.upper(votedGM));

		ts:Create(thing, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
			BorderColor3 = Color3.fromRGB(0, 255);
			BorderSizePixel = 10
		}):Play();

		ts:Create(old, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
			BorderColor3 = Color3.fromRGB(24, 137, 185);
			BorderSizePixel = 4
		}):Play();

		if voting.Value then
			gmUnvote:FireServer(votedGM);
			gmVote:FireServer(alph);
		end

		votedForGamemode = true;
		votedGM = alph;
	end
end



guiMA.icon.Activated:Connect(function(Input) VoteMap(guiMA, "a") end)
guiMB.icon.Activated:Connect(function(Input) VoteMap(guiMB, "b") end)
guiMC.icon.Activated:Connect(function(Input) VoteMap(guiMC, "c") end)


guiGMA.icon.Activated:Connect(function(Input) VoteGamemode(guiGMA, "a") end)
guiGMB.icon.Activated:Connect(function(Input) VoteGamemode(guiGMB, "b") end)
guiGMC.icon.Activated:Connect(function(Input) VoteGamemode(guiGMC, "c") end)



mapVoteEnd.OnClientEvent:Connect(function(winner, mapConot)
	local tt = 0.7;
	
	for _, choice in pairs(gui:GetChildren()) do
		if choice:IsA("Frame") and choice.Name ~= mapConot then
			
			ts:Create(choice.icon, TweenInfo.new(tt), {
				ImageColor3 = Color3.fromRGB(161, 161, 161)
			}):Play();
			
			ts:Create(choice.votes, TweenInfo.new(tt), {
				TextTransparency = 0.5,
				BackgroundTransparency = 0.8
			}):Play();
			
			if choice:FindFirstChild("mapname") then
				ts:Create(choice.mapname, TweenInfo.new(tt), {
					TextTransparency = 0.5,
					BackgroundTransparency = 0.8
				}):Play();
			elseif choice:FindFirstChild('gmname') then
				ts:Create(choice.gmname, TweenInfo.new(tt), {
					TextTransparency = 0.5,
					BackgroundTransparency = 0.8
				}):Play();
			end
			
			if choice.BorderColor3 == Color3.fromRGB(0, 255) then
				ts:Create(choice, TweenInfo.new(tt), {
					BorderColor3 = Color3.fromRGB(25, 55),
					BorderSizePixel = 4
				})
			end
			
			
		elseif choice:IsA("Frame") and choice.Name == mapConot then
			ts:Create(choice, TweenInfo.new(tt), {
				Size = UDim2.new(0, 125, 0, 120)
			}):Play();
		end
	end
end)



gmVoteEnd.OnClientEvent:Connect(function(winner, gmConot)

	local tt = 0.7;

	for _, choice in pairs(gui:GetChildren()) do
		if choice:IsA("Frame") and choice.Name ~= gmConot then

			ts:Create(choice.icon, TweenInfo.new(tt), {
				ImageColor3 = Color3.fromRGB(161, 161, 161)
			}):Play();

			ts:Create(choice.votes, TweenInfo.new(tt), {
				TextTransparency = 0.5,
				BackgroundTransparency = 0.8
			}):Play();

			if choice:FindFirstChild("mapname") then
				ts:Create(choice.mapname, TweenInfo.new(tt), {
					TextTransparency = 0.5,
					BackgroundTransparency = 0.8
				}):Play();
			elseif choice:FindFirstChild('gmname') then
				ts:Create(choice.gmname, TweenInfo.new(tt), {
					TextTransparency = 0.5,
					BackgroundTransparency = 0.8
				}):Play();
			end

			if choice.BorderColor3 == Color3.fromRGB(0, 255) then
				ts:Create(choice, TweenInfo.new(tt), {
					BorderColor3 = Color3.fromRGB(25, 55),
					BorderSizePixel = 4
				})
			end


		elseif choice:IsA("Frame") and choice.Name == gmConot then
			ts:Create(choice, TweenInfo.new(tt), {
				Size = UDim2.new(0, 125, 0, 120)
			}):Play();
		end
	end


	task.wait(1);


	local main = ts:Create(gui.Parent, TweenInfo.new(tt), {
		BackgroundTransparency = 1
	})


	for _, choice in pairs(gui:GetChildren()) do
		if choice:IsA("Frame") then

			ts:Create(choice.icon, TweenInfo.new(tt), {
				ImageTransparency = 1;
				BackgroundTransparency = 1;
			}):Play();

			ts:Create(choice, TweenInfo.new(tt), {
				BackgroundTransparency = 1
			}):Play();

			ts:Create(choice.votes, TweenInfo.new(tt), {
				TextTransparency = 1,
				BackgroundTransparency = 1
			}):Play();

			if choice:FindFirstChild("mapname") then
				ts:Create(choice.mapname, TweenInfo.new(tt), {
					TextTransparency = 1,
					BackgroundTransparency = 1
				}):Play();
			elseif choice:FindFirstChild('gmname') then
				ts:Create(choice.gmname, TweenInfo.new(tt), {
					TextTransparency = 1,
					BackgroundTransparency = 1
				}):Play();
			end
		end
	end

	main.Completed:Connect(function()
		gui.Parent.Visible = false;
		gui.Parent.BackgroundTransparency = 0.6

		for _, choice in pairs(gui:GetChildren()) do
			if choice:IsA("Frame") then

				choice.BorderColor3 = Color3.fromRGB(24, 137, 185);

				choice.icon.ImageTransparency = 0;
				choice.icon.BackgroundTransparency = 0;
				choice.icon.ImageColor3 = Color3.new(1, 1, 1);

				choice.Transparency = 0.6

				choice.votes.TextTransparency = 0;
				choice.votes.BackgroundTransparency = 0.5

				if choice:FindFirstChild('mapname') then
					choice.mapname.TextTransparency = 0;
					choice.mapname.BackgroundTransparency = 0.5
				elseif choice:FindFirstChild("gmname") then
					choice.gmname.TextTransparency = 0;
					choice.gmname.BackgroundTransparency = 0.5
				end
			end
		end
	end)


	main:Play()
end)