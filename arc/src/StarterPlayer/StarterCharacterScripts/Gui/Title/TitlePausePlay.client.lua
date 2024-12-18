local player = game.Players.LocalPlayer;

local loaded = player:WaitForChild("loaded");

repeat task.wait() until loaded.Value

local play = player.PlayerGui:WaitForChild("CoolTitleGui").Right.Surf.song.play;
local pauseplay = player.PlayerGui:WaitForChild("CoolTitleGui").Right.Surf.song.pauseplay;

local last = { Name = "none" };
local internalState = pauseplay.GuiState;
local replicate = true;

local donotdotwice = 0;


local function Hover()
	if replicate then
		internalState = pauseplay.GuiState;
	else
		replicate = true;
	end

	if internalState == Enum.GuiState.Hover or internalState == Enum.GuiState.Press then
		pauseplay.ImageColor3 = pauseplay:WaitForChild("hover").Value;

	elseif (last == Enum.GuiState.Press and internalState == Enum.GuiState.Idle) then
		pauseplay.ImageColor3 = pauseplay:WaitForChild("hover").Value;

		internalState = Enum.GuiState.Hover
		replicate = false;
		
		Hover();

	else
		pauseplay.ImageColor3 = pauseplay:WaitForChild("base").Value;
	end

	if internalState ~= last then
		last = internalState;
	end
end


pauseplay.Changed:Connect(Hover)


pauseplay.Activated:Connect(function()
	if play.Value then
		pauseplay.Image = pauseplay.play.Image
		play.Value = false;
	else
		pauseplay.Image = pauseplay.pause.Image
		play.Value = true;
	end
end)