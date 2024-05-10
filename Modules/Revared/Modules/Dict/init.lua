local Dict = {

	Entry = nil,
	
	__types = {
		Uni = 1,
		Pair = 2
	}

}


local functions = script.Functions;
local main = _G.Revared;


local Entry = require(script.Entry);
Entry.init(Dict);


Dict.Entry = Entry;


for _, f in ipairs(functions:GetChildren()) do
	require(f)(Dict);
end


return Dict;
