local PlayerControls = {};


local functions = script.Functions;


for _, f in ipairs(functions:GetChildren()) do
	require(f)(PlayerControls);
end


return PlayerControls;
