return function(Vargs)
	local server, service = Vargs.Server, Vargs.Service

	server.Commands.ExampleCommand = {
		Prefix = server.Settings.Prefix;	-- Prefix to use for command
		Commands = {"endgame"};	-- Commands
		Args = {};	-- Command arguments
		Description = "end the current game";	-- Command Description
		Hidden = false; -- Is it hidden from the command list?
		Fun = false;	-- Is it fun?
		AdminLevel = settings.Ranks.Admin;	    -- Admin level; If using settings.CustomRanks set this to the custom rank name (eg. "Baristas")
		
		Function = function(plr,args)    -- Function to run for command
			local grm = require(workspace.GameRoundMap.GameRoundMap);
			grm:EndRound();
		end
	}
end