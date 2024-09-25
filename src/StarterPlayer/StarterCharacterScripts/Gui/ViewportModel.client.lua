local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")



local function createAnimation(keyframes)
	local hashId = KeyframeSequenceProvider:RegisterKeyframeSequence(keyframes)
	local Animation = Instance.new("Animation", keyframes.Parent)
	Animation.AnimationId = hashId;
	return Animation;
end



local player = game.Players.LocalPlayer;

repeat task.wait() until game:IsLoaded();
repeat task.wait() until player.spawned.Value;


local Values = require(workspace.Modules.Values);

local vpm = workspace.Assets:WaitForChild("baseWeaponStance");
local dump = workspace:WaitForChild("ViewportDump");
local CWeld = require(script.Parent.Parent.Modules.CWeld);
local CWeldConfig = CWeld.CWeldConfig;


for _, vp in pairs(dump:GetChildren()) do
	if vp.Name == vpm.Name then vp:Destroy() end;
end


local viewport = vpm:Clone();
viewport.Parent = dump;

local vpValue = Values:Fetch("viewportModel");
local emoting = Values:Fetch("thirdPerson");

vpValue.Value = viewport;

local Animator = viewport.Humanoid:WaitForChild("Animator");
local idlekeyframes = game.ReplicatedStorage.GameAnims.ViewportModel:FindFirstChild("Idle");
local kfidle = createAnimation(idlekeyframes);


local walkkeyframes = game.ReplicatedStorage.GameAnims.ViewportModel:FindFirstChild("Walk");
local kfwalk = createAnimation(walkkeyframes);

--[[
local pickupkeyframes = game.ReplicatedStorage.GameAnims.ViewportModel:FindFirstChild("PickUp");
local kfpickup = createAnimation(pickupkeyframes);

local togglekeyframes = game.ReplicatedStorage.GameAnims.ViewportModel:FindFirstChild("FlashlightToggle");
local kftoggle = createAnimation(togglekeyframes);

]]local idle = Animator:LoadAnimation(kfidle);
local walk = Animator:LoadAnimation(kfwalk);--[[
local pickup = Animator:LoadAnimation(kfpickup);
local toggle = Animator:LoadAnimation(kftoggle);
]]

-- local flashlight = viewport.ViewportFlashlight
local root = viewport.PrimaryPart;
root.Anchored = true;


local character = player.Character or player.CharacterAdded:Wait();
local humanoid = character:WaitForChild("Humanoid");
local hrp = character:WaitForChild("HumanoidRootPart");
local head = character:WaitForChild("Head");


local enabled = player:WaitForChild("viewportEnabled");


humanoid.Died:Connect(function()
	viewport:Destroy();
	vpValue.Value = nil;
end)


local camera = workspace.CurrentCamera;

local baseStep = 1/1.3


local config = CWeldConfig.new({
	Y = 0.3,
	X = 0.03,
	D = 0.1,
	LerpStep = baseStep,
	TweenInfo = TweenInfo.new(0.01, Enum.EasingStyle.Sine)
});

local cw = CWeld.new(root, camera, config);
cw:Activate();



emoting.Changed:Connect(function()
	if emoting.Value then
		enabled.Value = false;
	else
		enabled.Value = true;
	end
end)


enabled.Changed:Connect(function()
	if enabled.Value then
		cw:Enable();
	else
		cw:Disable();
	end	
end)


local function PlayIdle()
	idle:Play();
	idle.TimePosition = walk.TimePosition;
	idle:AdjustSpeed(0.7);
end

--[[
local function PlayWalk()
	walk:Play();
	walk.TimePosition = idle.TimePosition;
	walk:AdjustSpeed(0.7);
end


coroutine.wrap(function()
	local playing = false;
	local stopped = true;
	
	
	walk.Stopped:Connect(function()
		stopped = true;
		playing = false;
	end);
	
	walk.Ended:Connect(function()
		stopped = true;
		playing = false;
	end);
	
	
	while task.wait(0.01) do
		if stopped and not playing and walk.IsPlaying then
			playing = true;
			stopped = false;
			
			-- print('playing');

			while playing and not stopped and task.wait(0.01) do
				local mag = ((hrp.Velocity*Vector3.new(1, 0, 1)).Magnitude)*0.2;
				-- print(mag);
				walk:AdjustSpeed(mag);
			end
		end
	end
end)();


player:WaitForChild("standing").Changed:Connect(function()
	if not player.standing.Value then
		idle:Stop();
		walk:Play();
	else
		walk:Stop()
		PlayIdle();
	end
end)


player:WaitForChild("viewportLocked").Changed:Connect(function()
	if player.viewportLocked.Value then
		cw:Activate();
	else
		cw:Deactivate();
	end
end)


local GameSettings = UserSettings().GameSettings;


local function GetQualityLevel()
	local sub = string.gsub(tostring(GameSettings.SavedQualityLevel), "Enum.SavedQualitySetting.QualityLevel", "");
	return tonumber(sub);
end


GameSettings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(function()
	if GetQualityLevel() < 4 then
		lowGraphics.Value = true
	else
		lowGraphics.Value = false;
	end
end)


local function UpdateFlashlight()
	if player:WaitForChild('flashlightOn').Value then
		local quality = GetQualityLevel();
		if quality and quality < 4 then
			flashlight.head.Attachment0.BigLight.Enabled = false;
			flashlight.head.Attachment0.LowGBigLight.Enabled = true;
			flashlight.head.Attachment0.SmallLight.Enabled = false;
			flashlight.head.Attachment0.LowGSmallLight.Enabled = true;

			lowGraphics.Value = true;

			print('applied lower graphics flashlight');
		else
			flashlight.head.Attachment0.BigLight.Enabled = true;
			flashlight.head.Attachment0.LowGBigLight.Enabled = false;
			flashlight.head.Attachment0.SmallLight.Enabled = true;
			flashlight.head.Attachment0.LowGSmallLight.Enabled = false;

			lowGraphics.Value = false;

			print('deun something undo unapplied lower graphics flashlight, no flashlight bad cool');
		end
	end
end


lowGraphics.Changed:Connect(function()
	UpdateFlashlight();
end);


local function ActuallyToggleTheLight(b)
	if not b then b = player:WaitForChild('flashlightOn').Value; end

	local togglesfx = game.ReplicatedStorage.GameSounds.Flashlight.Toggle;
	local buzzing = game.ReplicatedStorage.GameSounds.Flashlight.Buzzing;

	togglesfx:Stop();
	togglesfx.Playing = false;
	togglesfx.TimePosition = 0;

	togglesfx.TimePosition = 0;
	togglesfx:Play();

	if b then
		buzzing.Playing = false;
		buzzing.TimePosition = 0;
		buzzing.TimePosition = 0;
		buzzing:Play();
	else
		buzzing:Stop();
	end

	for _, l in pairs(flashlight.head.Attachment0:GetChildren()) do
		if string.match(l.ClassName, "Light") then
			if b == false or ((lowGraphics.Value and string.match(l.Name, "LowG")) or (not lowGraphics.Value and not string.match(l.Name, "LowG"))) then
				l.Enabled = b;
			end
		end
	end

	flashlight.head.Beam.Enabled = b;

	toggle:Play();
end



player:WaitForChild("flashlightOn").Changed:Connect(ActuallyToggleTheLight);


ActuallyToggleTheLight(false);


local function ToggleLight(b)	
	player:WaitForChild("flashlightOn").Value = b;
end


player:WaitForChild("viewportEnabled").Changed:Connect(function()
	if player.viewportEnabled.Value then
		
		ToggleLight(false);
		
		if player:WaitForChild("flashlightPickedUp").Value then
			idle:Stop();
			pickup:Play();
			
			task.delay(pickup.Length-0.1, function()
				player:WaitForChild("flashlightPickedUp").Value = false;
				player:WaitForChild("flashlightGotten").Value = true;
				pickup:Stop();
				idle:Play();

				cw.Config.LerpStep = baseStep;

				
				task.delay(0.3, function()
					ToggleLight(true);
				end);
			end)
			
			cw.Config.LerpStep = 1/1;
		end
		
		cw:Activate();
	else
		cw:Deactivate();
		viewport:PivotTo(CFrame.new(0, 0, 0));
	end
end)


]]
PlayIdle();
-- UpdateFlashlight();