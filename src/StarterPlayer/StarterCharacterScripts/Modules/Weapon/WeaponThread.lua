local RBXScriptSignal = require(workspace.Modules.Signal);


local WeaponThread = {};
WeaponThread.__index = WeaponThread;


function WeaponThread.new(threadtable)
    local self = setmetatable({
    
        Ended = RBXScriptSignal.new()
    
    }, WeaponThread)
end