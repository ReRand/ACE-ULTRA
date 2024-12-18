if _G.RevaredDict then return _G.RevaredDict end;

local Dict = {

	Entry = nil,
	
	Types = {
		Uni = 1,
		Pair = 2
	},
	
	__ = script.__,
	__loaded = false

}


require(Dict.__.tonumber)(Dict);
require(Dict.__.tostring)(Dict);


local functions = script.Functions;
local main = _G.Revared;


local Entry = require(script.Entry);
Entry.init(Dict);


Dict.Entry = Entry;


for _, f in ipairs(functions:GetChildren()) do
	require(f)(Dict);
	wait()
end

require(script.new)(Dict)

Dict.__loaded = true;


_G.RevaredDict = Dict;
return Dict;