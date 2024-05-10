--[[
	== Revared: ReRand Game ToolKit ==
	Created by Paige "paishee" Sheffield

	https://gitub.com/ReRand/RbxRevared
]]


if _G.Revared then return _G.Revared end;


local Revared = {
	Modules = {},
	Experiments = {},
	CaptionStore = {}
};


local settings = script.Settings;


local modules = script.Modules;
local functions = script.Functions;


for _, mod in pairs(modules:GetChildren()) do
	if mod:IsA("ModuleScript") then
		Revared.Modules[mod.Name] = mod;
	end
end


if settings.Experiments.Value then
	local experiments = script.Experiments;

	for _, exp in pairs(experiments:GetChildren()) do
		if exp:IsA("ModuleScript") then
			Revared.Experiments[exp.Name] = exp;
		end
	end
end


for _, f in ipairs(functions:GetChildren()) do
	require(f)(Revared);
end


_G.Revared = Revared;
return Revared;
