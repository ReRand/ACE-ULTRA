--[[
there are a lot of different configurations for the bullet behavior and I'll try to list them below

behavior<String>: the behavior of the projectile
- boom: explodes upon impact
- pierce: goes through enemies killing instantly
- flat: flat damage to an enemy that immediately goes away upon hitting


radius<Number>||<Int>: explosion radius if projectile behavior is on boom, default 30

rotation<Number>||<Int>: rotation added onto the y axis of the part upon shooting, default 0

velocity<Number>||<Int>: velocity multiplier for the part when shot, default 300

persist<Bool>: if the explosion should continue damaging even while fading out, default false

multihit<Bool>: if the explosion should hit continously until destroyed, default false

indiv<Number>||<Int>: the amount of time it takes for the first phase of the explosion (fading in) to finish, default 35

outdiv<Number>||<Int>: the amount of time it takes for the second phase of the explosion (fading out) to finish, default 10

damage<Number>||<Int>: the amount of damage put out, automatically calculated using radius by boom but defaults to 100 for pierce and defaults to 10 for flat damage

transparency<Number>||<Int>: the transparency of the explosion

cooldown<Number>||<Int>: the cooldown for multihit, default 1

bigmult<Number>||<Int>: multiplier for the size of the explosion's outer wave

shockwave<Bool>: if there should be a shockwave, default true

color<Color3>: the color of the explosion

knockback<Bool>: if there should be any knockback upon exploding

kbmult<Number>||<Int>: multiplier for the knockback applied on enemies when exploded

]]


local ProjectileModule = {}
local player = game.Players.LocalPlayer;
local character = player.Character or player.CharacterAdded:Wait();

local hrp = character:WaitForChild("HumanoidRootPart");

local weapons = character:WaitForChild("Weapons");
local firer = game.ReplicatedStorage.GameEvents.ProjMod:WaitForChild("Firer")
local exploder = game.ReplicatedStorage.GameEvents.ProjMod:WaitForChild("Exploder")
local deflecter = game.ReplicatedStorage.GameEvents.ProjMod:WaitForChild("Deflecter")



local camera = workspace.CurrentCamera;


local CameraShaker = require(workspace.Modules.CameraShaker);


local function ShakeCamera(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end


local renderPriority = Enum.RenderPriority.Camera.Value + 1


local cs = CameraShaker.new(renderPriority, ShakeCamera)
cs:Start();


local boomMsg = game.ReplicatedStorage.GameEvents.ProjMod:WaitForChild("BoomMessage")


boomMsg.OnClientEvent:Connect(function(part, radius)
	cs:ShakeOnce(radius/125, radius/5, (0.1*radius)/1000, (radius/1000*(radius/10))/1.8 );
end)



firer.OnClientEvent:Connect(function(pl, ammotype, customconfig)
	if pl == player then
		if ammotype:FindFirstChild("BulletConfig") and ammotype.BulletConfig:FindFirstChild("Modules") then
			for _, mod in pairs(ammotype.BulletConfig.Modules.Shot.Client:GetChildren()) do
				require(mod)(player, ammotype, customconfig);
			end
		end
	end
end)



function ProjectileModule:Init(ammotype, customConfig)
	local cf = camera.CFrame;
	firer:FireServer(hrp, ammotype, camera.CFrame.LookVector, cf, customConfig)
end



function ProjectileModule:Explode(part, config, replace)
	local cf = camera.CFrame;
	exploder:FireServer(part, config, replace)
end


function ProjectileModule:Deflect(projectile, mult)
	local cf = camera.CFrame;
	deflecter:FireServer(hrp, projectile, camera.CFrame.LookVector, cf, mult);
end


return ProjectileModule