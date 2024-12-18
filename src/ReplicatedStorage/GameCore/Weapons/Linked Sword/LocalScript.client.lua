repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer;

repeat task.wait() until player.loaded.Value
repeat task.wait() until player.spawned.Value;

local character = player.Character or player.CharacterAdded:Wait();

local hrp = character:WaitForChild("HumanoidRootPart");
local humanoid = character:WaitForChild("Humanoid");

local ddisplay = Instance.new("Part", hrp)
ddisplay.Name = "DeflectDisplay";
ddisplay.Size = Vector3.new(1, 1, 1)
ddisplay.CanCollide = false
ddisplay.Massless = true
ddisplay.Transparency = 1
ddisplay.Color = Color3.fromRGB(217, 0, 0)
ddisplay.Material = 'Neon'

local weld = Instance.new("Weld", ddisplay)
weld.Name = "SillyCDHBWeld";
weld.Part0 = hrp;
weld.Part1 = ddisplay;
weld.C1 = CFrame.new(-0.000244140625, -1, 3.99987793, 1, 0, 0, 0, 1, 0, 0, 0, 1)

local deflect = game.ReplicatedStorage:WaitForChild("Particles"):WaitForChild("DeflectEmitter").DeflectEmitter:Clone();
deflect.Enabled = false;
deflect.Parent = ddisplay;

deflect.ImageLabel.Rotation = 10;
deflect.ImageLabel.ImageTransparency = 1;
deflect.Size = UDim2.new(0, 0, 0, 0);