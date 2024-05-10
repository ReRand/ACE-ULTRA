local Signal = require(script.Parent.Signal);

local GlobalSide = {
	Healed = {
		Server = Signal.new(),
		Client = Signal.new(),
		Finally = Signal.new()
	},

	Damaged = {
		Server = Signal.new(),
		Client = Signal.new(),
		Finally = Signal.new()
	}
};


local functions = script.Functions;


for _, f in ipairs(functions:GetChildren()) do
	require(f)(GlobalSide);
end


return GlobalSide;
