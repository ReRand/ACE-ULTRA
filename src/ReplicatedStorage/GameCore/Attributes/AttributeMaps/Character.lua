--!strict


export type Attributes = {

	killerId : string,
	killerWeapon : number,
	accompliceId: string,

	killedByHeadshot : boolean,
	deathReason : number,
	deathType : number,
	
	isPlayer : boolean,
	playerId : string,
	
	hookUUID : string,
	
	iframed : boolean,
	parrying : boolean,
	
	weaponId : number,
	lastWeaponId : number,
	
	lit : boolean,
	
	standing : boolean,
	walking : boolean

}


-- a bunch of these are made -1 by default so they can get a changed event

return {
	Defaults = {
		
		killerId = "",
		killerWeapon = -1,
		accompliceId = "",

		killedByHeadshot = false,
		deathReason = -1,
		deathType = -1,
		
		isPlayer = false,
		playerId = "",
		
		hookUUID = "",
		
		iframed = false,
		parrying = false,
		
		weaponId = -1,
		lastWeaponId = -1,
		
		lit = false,
		
		standing = true,
		walking = false
	}
}