-- all credit to RockyRosso for this because I 100% stole this from a friends game that he worked on
-- thanks so much big man


--|| Variables

local movement = {};
movement.__index = movement;

local plr = game.Players.LocalPlayer;
local char = plr.Character or plr.CharacterAdded:Wait();

local ReplicatedStorage = game.ReplicatedStorage;
-- local Anims = ReplicatedStorage.Assets.Anims;

--||

--|| Functions

local function lerp(a: number, b: number, t: number)
    return a + (b - a) * t;
end

local function Tween(style: string, obj: Instance, length: number, goal: any)
    local tweenSettings = TweenInfo.new(
        length,
        Enum.EasingStyle[style],
        Enum.EasingDirection.Out,
        0,
        false,
        0
    );

    local tween = game:GetService("TweenService"):Create(obj, tweenSettings, goal);
    tween:Play();
end

local function LowSt(IsLow: boolean)
    local Lighting = game.Lighting;
    local Blur = Lighting.Blur;
    local CCor = Lighting.ColorCorrection;

    local EaseStyle = "Linear";

    if IsLow then
        Tween(EaseStyle, Blur, 2, {Size = 14});
        Tween(EaseStyle, CCor, 2, {Contrast = 0.3});
    else
        Tween(EaseStyle, Blur, 2, {Size = 2});
        Tween(EaseStyle, CCor, 2, {Contrast = 0.2});
    end 
end

--||

--|| Module Functions

function movement.new()
    local self = setmetatable({}, movement);

    --|| Player

    self.cam = workspace.CurrentCamera;

    --|| Character Content

    self.HRP = char:WaitForChild("HumanoidRootPart");
    -- self.Torso = char:WaitForChild("LowerTorso");

    -- self.right_arm = char:WaitForChild("RightUpperArm");

    self.Humanoid = char:WaitForChild("Humanoid");
    self.Animator = self.Humanoid:WaitForChild("Animator");

    --|| Anims

    --[[self.RunAnim = self.Animator:LoadAnimation(Anims.Run);
    self.RunToWalkAnim = self.Animator:LoadAnimation(Anims.WalkToRun);]]

    --|| Stats

    self.cam_offset = -1;

    self.tilt = 0.07;
    self.tiltZ = 0.07;

    self.has_slid = false;
    self.isSliding = false;
    self.slide_can = false;

    self.isSprinting = false;
    self.Stamina = 100;

    self.defSpeed = 9;
    self.sprSpeed = 50;
    self.crSpeed = 7;

    self.isCrouching = false;
    self.canCrouch = true;

    return self;
end

function movement:Sprint(State: boolean)
    local EasingStyle = "Linear";
    self.RunToWalkAnim.Looped = false;

    if State then
        self.isSprinting = true;

        self.RunToWalkAnim:Play();

        task.delay(1, function()
            self.RunAnim:Play();
        end)
        
        Tween(EasingStyle, self.cam, 2, {FieldOfView = self.sprFOV});
        Tween(EasingStyle, self.Humanoid, 2, {WalkSpeed = self.sprSpeed});

        repeat task.wait(0.1);
            self.Stamina -= 0.3;
        until self.Stamina <= 0 or not self.isSprinting;

        if self.Stamina <= 0 then
            LowSt(true);
            self.isSprinting = false;

            Tween(EasingStyle, self.cam, 2, {FieldOfView = self.defFOV});
            Tween(EasingStyle, self.Humanoid, 2, {WalkSpeed = self.defSpeed});
        end
    else
        self.isSprinting = false;

        Tween(EasingStyle, self.cam, 2, {FieldOfView = self.defFOV});
        Tween(EasingStyle, self.Humanoid, 2, {WalkSpeed = self.defSpeed});

        LowSt(false);

        repeat task.wait(0.5);
            self.Stamina += 1;
        until self.Stamina >= 100 or self.isSprinting;

        if self.Stamina > 100 then
            self.Stamina = 100;
        end
    end
end

function movement:updateCam()
    local moveVect = self.cam.CFrame:vectorToObjectSpace(Vector3.new(self.HRP.Velocity.X, 0.1, self.HRP.Velocity.Z) / 2 / math.max(self.Humanoid.WalkSpeed, 0.01));
    local x_bobble = math.cos(tick() * self.HRP.Velocity.Magnitude) / 2;
    local bobble = Vector3.new(x_bobble, 0, 0);
    
    -- self.Humanoid.CameraOffset = self.Humanoid.CameraOffset:Lerp(bobble, 0.25);

    self.tilt = math.clamp(lerp(self.tilt, moveVect.X * self.tiltZ, 0.1), -0.25, 0.1);
    self.cam.CFrame *= CFrame.Angles(0, 0, -self.tilt);
end

function movement:updateArms()
    local cam_dir = self.HRP.CFrame:toObjectSpace(self.cam.CFrame).lookVector;
    
    self.right_arm.RightShoulder.C0 = CFrame.new(self.right_arm.RightShoulder.C0.X, self.right_arm.RightShoulder.C0.Y, 0) * CFrame.Angles(math.asin(cam_dir.y), 0, 0);
end

function movement:anims()
    if not self.isSprinting then
        self.RunToWalkAnim:Stop();
        self.RunAnim:Stop();
    end
end

function movement:Update()
    self:updateCam();
    self:anims();
    self:updateArms();
end

--||

return movement;