local Signal = require(script.Parent.Signal);


local LocalBadges = {
    Types = {
        Award = 1,
        Has = 2
    },

    Awarded = Signal.new(),
    DoesHave = Signal.new(),
};


local award = script.Events.Award;
local has = script.Events.Has;
local out = script.Events.Out;


function LocalBadges:Award(badgeId, player)
    if not player then player = game.Players.LocalPlayer; end
    award:FireServer(badgeId, player);


    while task.wait() do
        local reqType, data = out.OnClientEvent:Wait();

        if reqType == LocalBadges.Types.Award then
            LocalBadges.Awarded:Fire(data);
            return data;
        end
    end
end


function LocalBadges:Has(badgeId, player)
    if not player then player = game.Players.LocalPlayer; end
    has:FireServer(badgeId, player);


    while task.wait() do
        local reqType, data = out.OnClientEvent:Wait();

        if reqType == LocalBadges.Types.Has then
            LocalBadges.DoesHave:Fire(data);
            return data;
        end
    end
end



return LocalBadges;
