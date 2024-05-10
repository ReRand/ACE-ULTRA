local Signal = require(script.Parent.Signal);


local LocalDataStores = {
    Types = {
        Request = 1,
        Post = 2,
    },

    Requested = Signal.new(),
    Posted = Signal.new()
};


local request = script.Events.Request;
local post = script.Events.Post;
local out = script.Events.Out;


function LocalDataStores:Request(dataStore: string, keyOrScope: string, key)
    local scope = nil;

    if keyOrScope and not key then
        key = keyOrScope;
    else
        scope = keyOrScope;
    end


    request:FireServer(dataStore, scope, key);


    while task.wait() do
        local reqType, data = out.OnClientEvent:Wait();

        if reqType == LocalDataStores.Types.Request then
            LocalDataStores.Requested:Fire(data);
            return data;
        end
    end
end


function LocalDataStores:Post(dataStore: string, keyOrScope: string, keyOrData, data)
    local scope = nil;
    local key = nil;


    if keyOrScope and not data then
        key = keyOrScope;
        data = keyOrData;
    else
        scope = keyOrScope;
        key = keyOrData;
    end


    post:FireServer(dataStore, scope, key, data);


    while task.wait() do
        local reqType, data = out.OnClientEvent:Wait();

        if reqType == LocalDataStores.Types.Post then
            LocalDataStores.Posted:Fire(data);
            return data;
        end
    end
end


return LocalDataStores;
