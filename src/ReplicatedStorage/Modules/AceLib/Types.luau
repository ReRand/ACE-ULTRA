--!optimize 2
--!nocheck
--!native

local LemonSignal = require(script.Parent.Dependencies.LemonSignal)


export type AceClass = {
	ClassName : string,
	New : (self : any, ...any?) -> (any?)?
}


export type AceEnum = AceClass & {
	Name : string,
	Enums : { [number]: AceEnumItem }
}


export type AceEnumItem = AceClass & {
	Name : string,
	Value : number,
	EnumType : AceEnum
}


export type AceWeapon = AceClass & {
	Name : string,
	Id : string,
	Entity : AceEntity,

	Fire : (AceWeapon) -> (AceProjectile)
}


export type AceProjectile = AceClass & {
	Name : string,
	Weapon : AceWeapon,
	Info : AceProjectileInfo
}


export type AceProjectileInfo = AceClass & {
	
}


export type AceEntity = AceClass & {
	Player: Player,

	Weapons: { [number]: AceWeapon },

	Killed: LemonSignal.Signal<AceEntity, AceEntity, AceWeapon>,
	Suicided: LemonSignal.Signal<AceEntity>
}


export type AceExplosionInfo = AceClass & {
    FilterType : Enum.RaycastFilterType?,
    Filter : { [number] : Instance }?,

    OriginPlayer: AceEntity?,
    Part: Part,

	Projectile: AceProjectile
}


export type AceExplosion = AceClass & {
    Info: AceExplosionInfo
}

return {}