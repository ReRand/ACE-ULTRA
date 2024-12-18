return function(Vargs)
	local server, service = Vargs.Server, Vargs.Service

	server.Commands.ExampleCommand = {
		Prefix = server.Settings.Prefix;	-- Prefix to use for command
		Commands = {"overwritemap"};	-- Commands
		Args = { "mapid" };	-- Command arguments
		Description = "overwrites the map choice on the selection screen";	-- Command Description
		Hidden = false; -- Is it hidden from the command list?
		Fun = false;	-- Is it fun?
		AdminLevel = settings.Ranks.Admin;	    -- Admin level; If using settings.CustomRanks set this to the custom rank name (eg. "Baristas")

		Function = function(plr,args)    -- Function to run for command
			local grm = require(workspace.GameRoundMap.GameRoundMap);

			local gv = workspace.GlobalValues.Game;
			local vv = workspace.GlobalValues.Vote;

			local mapId = gv.mapId;
			local gmId = gv.gmId;
			local mapV = gv.map;
			local song = gv.song;
			local ended = gv.ended;
			local started = gv.started;
			local paused = gv.unendingHorrors;
			local roundTime = gv.roundTime;

			local voting = vv.itsSoHappening;
			local voteTime = vv.voteTime;

			local mapA = vv.mapA;
			local mapB = vv.mapB;
			local mapC = vv.mapC;

			local gmA = vv.gmA;
			local gmB = vv.gmB;
			local gmC = vv.gmC;
			
			local mapid = args[0];
			local mb = grm:GetMapFromId(mapid);
			
			for i, m in ipairs({mapA, mapB, mapC}) do
				m.id.Value = mb.id.Value;
				m.icon.Value = mb.icon;
				m.name.Value = string.upper(mb.Name);
			end
			
			mapB.id.Value = mb.id.Value;
			mapB.votes.Value = 0;
			mapB.icon.Value = mb.icon;
			mapB.name.Value = string.upper(mb.Name);
		end
	}
end