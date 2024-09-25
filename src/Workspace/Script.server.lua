local Revared = require(workspace.Modules.Revared);
local Dict = Revared:GetModule("Dict");

local d1 = Dict.new({
	{ key1 = "a" },
	{ key2 = "b" }
});

local d2 = Dict.new({
	{ key3 = "c" },
	{ key4 = "d" }
})


print(d2)

print(d2:Get(0))