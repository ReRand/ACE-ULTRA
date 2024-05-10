local BadgeService = game:GetService("BadgeService");

local main = script.Parent;
local LocalBadges = require(main);
local events = main.Events;


local award = events.Award;
local has = events.Has;
local out = events.Out;


award.OnServerEvent:Connect(function(initPlayer, badgeId, receiver)
    BadgeService:AwardBadge(receiver.UserId, badgeId);

    out:FireClient(receiver, LocalBadges.Types.Award, receiver);
end);


has.OnServerEvent:Connect(function(initPlayer, badgeId, player)
    local doesHave = BadgeService:UserHasBadgeAsync(player.UserId, badgeId);

    out:FireClient(player, LocalBadges.Types.Has, doesHave);
end);
