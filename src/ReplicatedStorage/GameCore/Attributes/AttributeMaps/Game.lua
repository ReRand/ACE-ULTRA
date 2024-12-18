--!strict


export type Attributes = {

	crosshairColor : Color3,
	crosshairSize : number,
	crosshairTransparency : number,

	currentExp : number,

	accomplice: Model,

	killedByHeadshot : boolean,
	deathReason : number,
	deathType : number,

}


-- a bunch of these are made -1 by default so they can get a changed event

return {
	Defaults = {
		crosshairColor = Color3.new(-1, -1, -1),
		crosshairSize = -1,
		crosshairTransparency = -1,
		
		currentExp = -1,
		
		killedByHeadshot = false,
		deathReason = -1,
		deathType = -1
	}
}