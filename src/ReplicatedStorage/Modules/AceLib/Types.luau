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
    FilterType : Enum.RaycastFilterType,
    Filter : { [number] : Instance },

    OriginEntity : AceEntity?,
	OriginProjectile : AceProjectile,

    MultiHit : boolean,
    FuseTime : number?,
    Knockback : boolean,
    KnockbackMultiplier : number,
    Cooldown : number,
    Velocity : number,
    SetDamage : number?,
    FallVelocity : number,

    Radius : number,
    Color : Color3 | BrickColor?,
    Transparency : number?,

    FireProbability : number,
    FireInfo : AceFireInfo?,
}


export type AceFireInfo = AceClass & {
    Color : Color3 | BrickColor?,
    Transparency : number?,

    OriginEntity : AceEntity?,

    Damage : number,
    TickTime : number,
    TotalTime : number,
}


export type AceExplosion = AceClass & {
    Info : AceExplosionInfo
}


export type AceFire = AceClass & {
	Info : AceFireInfo
}


return {}