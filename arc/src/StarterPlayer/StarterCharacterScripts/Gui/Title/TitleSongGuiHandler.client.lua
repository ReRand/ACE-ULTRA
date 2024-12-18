local player = game.Players.LocalPlayer;
local loaded = player:WaitForChild("loaded");

repeat task.wait() until loaded.Value;

local ts = game:GetService("TweenService");

local stuff = player.PlayerGui:WaitForChild("CoolTitleGui").Right.Surf

local play = stuff.song.play


local music = stuff.song.music:GetChildren()
local song = music[math.random(1, #music)]

local info1 = TweenInfo.new(3, Enum.EasingStyle.Linear)

local songLabel = stuff.song.song;
local authorLabel = stuff.song.author;

songLabel.Text = '"'..song.Name..'"';
authorLabel.Text = song.author.Value;

play.Changed:Connect(function()
	if play.Value == true then
		song:Resume();
	else
		song:Pause();
	end
end)


if not player.spawned.Value then

	local vol = song.Volume;
	song.Volume = 0;

	song:Play();

	ts:Create(song, info1, { Volume = vol }):Play();	

	repeat task.wait() until player.spawned.Value;
	
	ts:Create(song, info1, { Volume = 0 }):Play();	
	
end