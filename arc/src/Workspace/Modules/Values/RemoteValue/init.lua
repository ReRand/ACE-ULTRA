local RemoteValue = {}


local functions = script.Functions;
local main = _G.Revared;


for _, f in ipairs(functions:GetChildren()) do
	require(f)(RemoteValue);
end


return RemoteValue;