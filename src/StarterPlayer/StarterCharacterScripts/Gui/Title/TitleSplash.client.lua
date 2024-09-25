math.randomseed(os.time())
math.random(); math.random(); math.random()


local player = game.Players.LocalPlayer;


if player.spawned.Value then
	return;
end


playerBirthday = player.AccountAge;


local splash = player.PlayerGui:WaitForChild("CoolTitleGui").Left.Surf.splash;


function c(t, c)
	return '<font color="rgb('..math.round(c.R*255)..","..math.round(c.G*255)..","..math.round(c.B*255)..')">'..t..'</font>'
end


function s(t, tn, tr, c)
	return '<stroke color="'..math.round(c.R*255)..","..math.round(c.G*255)..","..math.round(c.B*255)..'" joins="miter" thickness="'..tn..'" transparency="'..tr..'">'..t..'</stroke>'
end


function si(t, s)
	return '<font size="'..s..'">'..t..'</font>';
end


local y = BrickColor.Yellow().Color;
local r = BrickColor.Red().Color;
local g = BrickColor.Green().Color;
local b = BrickColor.Blue().Color;
local bl = BrickColor.Black().Color;
local w = BrickColor.White().Color;
local gr = BrickColor.Gray().Color;
local dg = BrickColor.DarkGray().Color;
local o = Color3.fromHex("FF6A00");


local splashes = {
	
	-- 35% originals
	{ "open prealpha!!", 53 },
	{ "happy "..string.lower(os.date("%A")).."!", 35 },
	
	-- 35% suggestions
	{ "techoblade never dies", 35 },
	
	-- 25% originals
	{ "cool test text", 25 },
	{ "certified cool text", 25 },
	{ "IOU vaint", 25 },
	{ "stay snazzy!", 25 },
	{ "winnebago", 25 },
	{ "quality assurance", 25 },
	{ "whoops!", 25 },
	{ "pow!", 25 },
	{ "nuh uh", 25 },
	
	-- 25% suggestions
	{ "pootassium 🍌", 25 },
	{ "cat in apple runs at you", 25 },
	{ "central silly agency", 25 },
	{ "chrisean jr first steps", 25 },
	{ "stay hydrated!", 25 },
	{ "shower vaint!", 25 },
	
	-- shills
	{ "play ultrakill too", 25 },
	{ "play lethal\ncompany too", 25 },
	{ "play phighting too", 25 },
	{ "play arsenal too", 25 },
	
	-- 15% originals
	{ c("[User_'"..player.DisplayName.."'_Has_Been_Logged]", Color3.fromHex("510006")), 15 },
	{ "bear5 is coming\nfor you", 15 },
	{ "I'm swaiting", 15 },
	{ "whar", 15 },
	{ "guh", 15 },
	{ "doh!", 15 },
	
	-- 15% suggestions
	{ si("95%", 30).." of gamblers quit", 15 },
	{ "throughout kevin and earth", 15 },
	{ "finkle doodle", 15 },
	
	-- yeah
	{ "not associated with\nnewgrounds", 19 },
	
	
	-- So Lethal (JT Music)
	{ "DON'T FORGET!\nQUOTA CHECK!", 15 },
	
	
	-- The U & I in Suicide (That Handsome Devil)
	{ "how far are you\n running boy?", 15 },
	
	
	-- Interdimensional (Cosmo Sheldrake)
	{ si("I wasn't big", 30)..si("\nI wasn't small", 20), 15 },
	
	
	-- Kitchen Fork (Jack Conte)
	{ "my head's a gun!", 15 },
	{ "haunted pillow beneath\nmy head", 15 },
	
	
	-- Pork Soda (Glass Animals)
	{ "pineapples are in my head!", 15 },
	
	
	-- Dream Sweet in Sea Major (Miracle Musical)
	{ "a cosmic confluence of\npyramids hologrammed", 15 },
	{ "a line in any final song\nso long, so far", 15 },
	{ "un ensemble d'enfants\nla galaxie s'étend", 15 },
	{ "believe me, darling, the stars\n were made for falling", 15 },
	{ "signed, yours truly,\nthe whale", 15 },
	{ "now that existence is\non the wake", 15 },
	{ "bye, hi sigh, hawaii we were\nnever meant to part", 15 },
	
	
	-- & (Tally Hall)
	{ "stop the peace and\nkeep the violence", 15 },
	
	
	-- Shutup You're Stupid (That Handsome Devil)
	{ "searching for enlightenment", 15 },
	
	
	-- The Great Dictator (Charlie Chaplin)
	{ "\"greed has poisoned\nmens' souls\"", 15 },
	
	
	-- 5% originals
	{ "#### ### heck ###", 5 },
	{ "#SlestelumTechIsOverParty", 5 },
	
	
	-- 5% suggestions
	{ "lorem ipsum", 5 },
	
}


print(#splashes.." active splash texts");


function randsort( tbl, corrections )
	local rnd = corrections or {}
	
	table.sort( tbl, function ( a, b)
		rnd[a[1]] = rnd[a[1]] or math.random()
		rnd[b[1]] = rnd[b[1]] or math.random()
		return rnd[a[1]] > rnd[b[1]]
	end)
end


function ordinal(n)
	local ordinal, digit = {"st", "nd", "rd"}, string.sub(n, -1)
	if tonumber(digit) > 0 and tonumber(digit) <= 3 and string.sub(n,-2) ~= 11 and string.sub(n,-2) ~= 12 and string.sub(n,-2) ~= 13 then
		return n .. ordinal[tonumber(digit)]
	else
		return n .. "th"
	end
end


randsort(splashes);


local month = tonumber(os.date("%m"));
local day = tonumber(os.date("%d"));
local year = tonumber(os.date("%Y"))
local yday = os.date("*t")["yday"];


--<< albert stuff >>--

local albert = {
	"Alberts",
	"Mrflimflam",
	"Streety",
	"Crimson0",
	"yeoooooowwwwwch",
	"StupidAndStupid282",
	"GeanaSHUTUPSCDFIOJKN",
	"imobesebutimcute",
	"jasmine233223",
	"samanthapoopenheimer",
	"ihatemyson"
}


local isAlbert = false;


for _, n in pairs(albert) do
	if string.lower(n) == string.lower(player.Name) then
		isAlbert = true;
	end
end


if isAlbert then
	table.insert(splashes, 1, {
		c( "hello albert.", Color3.fromHex("B46F64") ),
		50
	});
	
	table.insert(splashes, 1, {
		c( si("[You_have_been_identified_as_flamingo]\n", 20)..si("[Is_this_correct[?]]", 25), Color3.fromHex("AB9264") ).."\n"..c("[Y]          [N]", Color3.fromHex("539D71")),
		50
	});
end


--<< player birthday >>--

local isBirthday = playerBirthday and playerBirthday % 365 == 0 or false;

if isBirthday then
	table.insert(splashes, 1, {
		c(string.upper("HAPPY "..ordinal(math.round(playerBirthday / 365)).." BIRTHDAY TO\nYOUR ACCOUNT "..player.DisplayName.."!!"), y),
		50
	});
end


--<< game birthday >>--

if month == 3 and day == 21 then
	table.insert(splashes, 1, {
		c(string.upper("its our "..ordinal(year-2024).." birthday!!"), y),
		50
	});
	
	table.insert(splashes, 1, {
		c(string.upper("HAPPY"..ordinal(year-2024).." BIRTHDAY US!!"), y),
		50
	})
	
	table.insert(splashes, 1, {
		c(string.upper("PARTYYY!! IT'S OUR\n"..ordinal(year-2024).." BIRTHDAY!!!!"), y),
		50
	})
end
	
	
--<< december >>--
	
if month == 12 then
	table.insert(splashes, 1, {
		"stay frosty!",
		50
	});
	
	table.insert(splashes, 1, {
		"merry christmas!",
		50
	})
end


--<< christmas >>--

if month == 12 and day == 25 then
	table.insert(splashes, 1, {
		c("MERRY", g)..c(" CHRISTMAS!!!!!", r),
		100,

		function()
			local first = true;

			while month == 12 and day == 25 do
				if first then
					splash.Text = c("MERRY", r)..c(" CHRISTMAS!!!!!", g);
					first = false;
				else
					splash.Text = c("MERRY", g)..c(" CHRISTMAS!!!!!", r);
					first = true;
				end

				task.wait(1);
			end
		end
	});
end


--<< new year >>--

if month == 1 and day == 1 then
	table.insert(splashes, 1, {
		c("HAPPY NEW YEAR!!!", y),
		100,
	})
end


--<< october >>--

if month == 10 then
	table.insert(splashes, 1, {
		"ISSA SPOOKY MONTH!!",
		50
	})
	
	table.insert(splashes, 1, {
		"real spooky!!",
		50
	})
	
	table.insert(splashes, 1, {
		"BOO!!!!!",
		50
	})
end


--<< halloween >>--

if month == 10 and day == 31 then
	table.insert(splashes, 1, {
		c("HAPPY", o)..c(" HALLOWEEN!!!!!", o),
		100,
		
		function()
			local first = true;
			
			while month == 10 and day == 31 do
				if first then
					splash.Text = c("HAPPY", dg)..c(" HALLOWEEN!!!!!", o);
					first = false;
				else
					splash.Text = c("HAPPY", o)..c(" HALLOWEEN!!!!!", dg);
					first = true;
				end
				
				task.wait(1);
			end
		end
	});
end



local length = #splashes
local mod = nil;


function GetSplash(percents)
	for i, obj in ipairs(percents) do
		
		local spl, percent, f = table.unpack(obj);
		
		if not percent then percent = 25 end;
		
		assert(percent >= 0 and percent <= 100)
		
		if percent >= math.random(1, 100) or i == #splashes then
			
			if f then
				mod = f;
			end
			
			return spl
		end
	end
	
end


splash.Text = GetSplash(splashes);


local ts = game:GetService("TweenService");

ti = TweenInfo.new(2)

local t1 = ts:Create(splash, ti, {
	Rotation = -5
})

local t2 = ts:Create(splash, ti, {
	Rotation = 0
});


t1.Completed:Connect(function()
	t2:Play()
end)

t2.Completed:Connect(function()
	t1:Play();
end)


t1:Play()

if mod then
	mod()
end