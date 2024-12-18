local player = game.Players.LocalPlayer;
repeat task.wait() until player:WaitForChild("spawned").Value;


local TweenService = game:GetService("TweenService");
local Values = require(workspace.Modules.Values);
local RunService = game:GetService("RunService");
local StarterPlayer = game:GetService("StarterPlayer");


local uis = game:GetService("UserInputService")
local cas = game:GetService("ContextActionService");

local ts = game:GetService("TweenService");
local rs = game:GetService("RunService");

local character = player.Character or player.CharacterAdded:Wait();

local hrp = character:WaitForChild("HumanoidRootPart");
local humanoid = character:WaitForChild("Humanoid");
local Animator = humanoid:WaitForChild("Animator");


local emoting = Values:Fetch("emoting");
local emotesMenuOpen = Values:Fetch("emotesMenuOpen");
local thirdPerson = Values:Fetch("thirdPerson")

local dtp = Values:Fetch("debugThirdPerson")
local emote = nil;

local camera = workspace.CurrentCamera;


--local PlayerModule = require(player.PlayerScripts:WaitForChild('PlayerModule'))
--local controls = PlayerModule:GetControls()

--controls:Enable();


local ignore = false;
local standing = Values:Fetch('standing');
local baseWalkSpeed = StarterPlayer.CharacterWalkSpeed;


local baseOffset = workspace.CoolGui.EmoteAdorneePart.welds.emote1.C0.Position.Z;


emotesMenuOpen.Changed:Connect(function()
	if emotesMenuOpen.Value then
		player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("crosshair").Visible = false;

		camera.CameraType = Enum.CameraType.Scriptable;
		uis.MouseIconEnabled = true;
		--controls:Disable();

		for _, e in pairs(player.PlayerGui.EmoteWheel:GetChildren()) do
			pcall(function()
				e.Enabled = true;
			end)
		end

		for _, e in pairs(player.PlayerGui.EmoteWheel.Emotes:GetChildren()) do
			pcall(function()
				e.Enabled = true;
			end)
		end
	else

		player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("crosshair").Visible = true;

		camera.CameraType = Enum.CameraType.Custom;
		uis.MouseIconEnabled = false;
		--controls:Enable();

		for _, e in pairs(player.PlayerGui.EmoteWheel:GetChildren()) do
			pcall(function()
				e.Enabled = false;
			end)
		end
		
		for _, e in pairs(player.PlayerGui.EmoteWheel.Emotes:GetChildren()) do
			pcall(function()
				e.Enabled = false;
			end)
		end
	end
end)


uis.InputBegan:Connect(function(Input)
	if (Input.KeyCode == Enum.KeyCode.G or Input.KeyCode == Enum.KeyCode.Q) and emotesMenuOpen.Value and not ignore then
		emotesMenuOpen.Value = false;
	end
end)


uis.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.G and standing.Value and not emotesMenuOpen.Value then
		emotesMenuOpen.Value = true;
		
		player.PlayerGui.EmoteWheel.emotename.Enabled = false;
		
		ignore = true;

		task.delay(0.2, function()
			ignore = false;
		end)
	end
end)


local loadedEmotes = {}


local function GetEmoteFromId(emoteId)
	local baseemote = nil;
	
	for _, e in pairs(game.ReplicatedStorage.PlayerEmotes:GetChildren()) do
		if e:FindFirstChild("id") and tostring(e.id.Value) == tostring(emoteId) then
			baseemote = e;
		end
	end
	
	local loaded = nil;
	
	if not loadedEmotes[baseemote:FindFirstChild(baseemote.id.Value)] then
		loaded = Animator:LoadAnimation(baseemote);
	else
		loaded = loadedEmotes[baseemote:FindFirstChild(baseemote.id.Value)];
	end
	
	loaded.Looped = baseemote:FindFirstChild("looped") and baseemote:FindFirstChild("looped").Value or false;
	
	return loaded, baseemote;
end


local function GetEmoteFromSlot(slot)
	local emoteid = player:WaitForChild("emoteSlot"..slot);
	return GetEmoteFromId(emoteid.Value);
end



local function CancelEmote(emote)
	emoting.Value = false;
	humanoid.WalkSpeed = baseWalkSpeed;
	emote:Stop()
end


local servermodules = game.ReplicatedStorage.GameEvents.EmoteServerModules;


for _, e in pairs(player.PlayerGui.EmoteWheel.Emotes:GetChildren()) do
	
	for _, b in pairs(e.Buttons:GetChildren()) do
		
		b.MouseEnter:Connect(function()
			print('hovering')
			
			local weld = e.Adornee.Parent.welds[e.Name];
			
			ts:Create(weld, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				C0 = CFrame.new(weld.C0.Position.X, weld.C0.Position.Y, baseOffset+1) * weld.C0.Rotation
			}):Play();

			local emotenameid = string.gsub(e.Name, "emote", "");
			local loadedemote, baseemote = GetEmoteFromSlot(emotenameid);

			player.PlayerGui.EmoteWheel.emotename.Label.Text = baseemote:FindFirstChild("name") and baseemote:FindFirstChild("name").Value or baseemote.Name;
			player.PlayerGui.EmoteWheel.emotename.Enabled = true;	
		end)

		b.MouseLeave:Connect(function()
			print('unhovering')
			
			local weld = e.Adornee.Parent.welds[e.Name];
			
			ts:Create(weld, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				C0 = CFrame.new(weld.C0.Position.X, weld.C0.Position.Y, baseOffset) * weld.C0.Rotation
			}):Play();

			player.PlayerGui.EmoteWheel.emotename.Label.Text = "";
			player.PlayerGui.EmoteWheel.emotename.Enabled = false;
		end)
		
		b.Activated:Connect(function()
			print('pressed '..e.Name);

			local emotenameid = string.gsub(e.Name, "emote", "")
			local loadedemote, baseemote = GetEmoteFromSlot(emotenameid);

			emote = loadedemote;
			
			loadedemote:Play();

			emoting.Value = true;
			emotesMenuOpen.Value = false;
			
			
			standing.Changed:Connect(function()
				if not standing.Value and emoting.Value and (not baseemote:FindFirstChild("traversal") or (baseemote:FindFirstChild("traversal") and not baseemote.traversal.Value)) then
					CancelEmote(loadedemote);
				end
			end)
			
			
			if baseemote:FindFirstChild("traversal") and baseemote.traversal.Value and baseemote:FindFirstChild("walkspeed") then
				humanoid.WalkSpeed = baseemote:FindFirstChild("walkspeed").Value;
			end
			
			
			for _, mod in pairs(baseemote.Modules.Client:GetChildren()) do
				require(mod)(baseemote.id.Value, player);
			end
			
			
			servermodules:FireServer(baseemote.Modules.Server, baseemote.id.Value);
		end)
	end
end


humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
	if emoting.Value then
		CancelEmote(emote);
	end
end)


humanoid.StateChanged:Connect(function()
	if humanoid:GetState() == Enum.HumanoidStateType.Freefall and emoting.Value then
		CancelEmote(emote);
	end
end)