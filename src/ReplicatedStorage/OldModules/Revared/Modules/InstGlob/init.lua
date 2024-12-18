local InstGlob = {
	Loaded = false,
	Version = nil,
	Data = nil,
	Classes = nil
};

local functions = script.Functions;


for _, f in ipairs(functions:GetChildren()) do
	require(f)(InstGlob);
end


return InstGlob;