local Values = require(workspace.Modules.Values);
local player = game.Players.LocalPlayer;
local loaded = player.loaded;

repeat task.wait() until loaded.Value


local RBXScriptSignal = require(workspace.Modules.Signal);
local TweenService = game:GetService("TweenService");


local character = player.Character or player.CharacterAdded:Wait();


local wm = require(script.Parent.WeaponModule);
local pm = require(script.Parent.ProjectileModule);
local hsm = require(script.Parent.HitscanModule);


local Weapon = {};
Weapon.__index = Weapon;


function Weapon.new(datafolder)

    local id = datafolder.id.Value;


    local cdTime = datafolder.cooldown.Value;
    local switchTime = datafolder.switch.Value;


    local model = wm:GetWeaponModelFromId(id);
    local vpModel = wm:GetViewportWeaponModelFromId(id);


    local self = setmetatable({

        --< Values >--


        Threads = {
            
        }
        

        Id = id,
        Model = model,
        ViewportModel = vpModel,
        
        CooldownTime = cdTime,
        SwitchTime = switchTime,

        Quipped = false;
        Abled = true,
        Ready = false,


        --< Events >--

        Fired = RBXScriptSignal.new(),
        
        Disabled = RBXScriptSignal.new(),
        Enabled = RBXScriptSignal.new(),

        Cooldowned = RBXScriptSignal.new(),
        SwitchCooldowned = RBXScriptSignal.new(),

        Equipped = RBXScriptSignal.new(),
        UnEquipped = RBXScriptSignal.new(),


    }, Weapon);


    return self;
end



function Weapon:Fire(cooldown)

    if not self.Ready or not self.Abled then return end;

    self.Fired:Fire();

    self.Ready = false;

    if not cooldown then
        cooldown = self.CooldownTime;
    end

    task.delay(cooldown, function()
        if 
    end);
end



function Weapon:Equip()
    self.Equipped:Fire();
end



function Weapon:UnEquip()
    self.UnEquipped:Fire();
end



function Weapon:Enable(time)
    self.Abled = true;
    self.Enabled:Fire();

    if time then
        task.delay(time, function()
            self:Disable();
        end);
    end
end



function Weapon:Disable(time)
    self.Abled = false;
    self.Disabled:Fire();

    if time then
        task.delay(time, function()
            self:Enable();
        end)
    end
end




return Weapon;