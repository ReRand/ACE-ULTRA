--!strict


export type Attributes = {
	
	loaded : boolean,
	mapLoaded : boolean,
	skinLoaded : boolean,
	inMenu : boolean,

	crosshairColor : Color3,
	crosshairSize : number,
	crosshairTransparency : number,

	xp : number,
	level : number,
	
	playerId : string,
	
	emote1 : number,
	emote2 : number,
	emote3 : number,
	emote4 : number,
	emote5 : number,
	
	weapon1 : number,
	weapon2 : number,
	weapon3 : number,
	weapon4 : number,
	
	perk1 : number,
	perk2 : number,
	
	kills : number,
	totalKills : number,
	
	style : number,
	totalStyle : number,
	
	skinId : number,

	performanceStats : boolean, -- if the player is viewing their stats like fps and ping with the debug keybind
	
	uiOffset : CFrame,
	
	viewportEnabled : boolean,
	viewportLocked : boolean
}


-- a bunch of these are made -1 by default so they can get a changed event

return {
	Defaults = {
		loaded = false,
		mapLoaded = false,
		skinLoaded = false,
		inMenu = false,
		
		crosshairColor = Color3.new(-1, -1, -1),
		crosshairSize = -1,
		crosshairTransparency = -1,
		
		xp = -1,
		level = -1,
		
		playerId = "",
		
		emote1 = -1,
		emote2 = -1,
		emote3 = -1,
		emote4 = -1,
		emote5 = -1,
		
		weapon1 = -1,
		weapon2 = -1,
		weapon3 = -1,
		weapon4 = -1,
		
		perk1 = -1,
		perk2 = -1,
		
		kills = -1,
		totalKills = -1,
		
		style = -1,
		totalStyle = -1,
		
		skinId = -1,
		
		performanceStats = false,
		
		uiOffset = CFrame.identity,
		
		viewportEnabled = true,
		viewportLocked = true,
	}
}