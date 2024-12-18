local ts = game:GetService("TweenService");

local player = game.Players.LocalPlayer;

repeat task.wait() until player:WaitForChild("loaded").Value;


local gui = player.PlayerGui:WaitForChild("CoolGui").Right.Song;
local stuff = gui.Stuff;
local texts = stuff.Texts;

gui.Visible = false;

local basepos = gui.Position;


local spawned = player:WaitForChild("spawned");
local rs = game.ReplicatedStorage.GameSounds:WaitForChild("RecordScratch");
local rs2 = game.ReplicatedStorage.GameSounds:WaitForChild("RecordScratch2");

local tp = 0;

local baseVolume = 0.5;


player.CharacterAdded:Connect(function()
	local song = workspace.GlobalValues.Game:WaitForChild("song").Value;

	local gui = player.PlayerGui:WaitForChild("CoolGui").Right.Song;
	local stuff = gui.Stuff;
	local texts = stuff.Texts;
	
	gui.Visible = false;

	local outpos = UDim2.new(UDim.new(2, 0), basepos.Y);
	gui.Position = outpos;

	if gui.Position ~= outpos then
		gui.Position = outpos;
	end
	
	if song and spawned.Value then
		texts.song.Text = '"'..song:GetAttribute("SongName")..'"';
		texts.author.Text = "By "..song:GetAttribute("SongComposer");

		local covers = game.ReplicatedStorage.OstCovers:GetChildren();
		local coverimage;

		local songcovername = song:GetTags()[1];

		for _, c in pairs(covers) do
			if c.Name == songcovername then
				coverimage = c.Image;
			end
		end

		stuff.Covers.cover.Image = coverimage;


		local guiIn = ts:Create(gui, TweenInfo.new(2), {
			Position = basepos
		});

		local guiOut = ts:Create(gui, TweenInfo.new(4), {
			Position = outpos
		});

		guiIn.Completed:Connect(function()
			task.delay(3, function()
				guiOut:Play();	
			end)
		end)
		
		guiOut.Completed:Connect(function()
			gui.Visible = false;
		end)
		
		gui.Visible = true;

		guiIn:Play();
	end
	
end)


spawned.Changed:Connect(function()
	
	local song = workspace.GlobalValues.Game:WaitForChild("song").Value;
	
	if spawned.Value and song then
		
		song.PlaybackSpeed = 0;
		
		ts:Create(song, TweenInfo.new(0.7), {
			Volume = baseVolume,
			PlaybackSpeed = 1
		}):Play();
		
		song:Resume();
		
	elseif song and not spawned.Value then
		
		baseVolume = song.Volume;
		
		local tween = ts:Create(song, TweenInfo.new(1), {
			Volume = 0
		});
		
		rs:Play();
		rs2:Play();
		
		tween.Completed:Connect(function()
			if workspace.GlobalValues.Game.ended.Value then
				song:Stop();
			else
				song:Pause();
			end
		end)
		
		tween:Play()
	end
end)