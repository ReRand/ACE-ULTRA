--!optimize 2
--!nocheck
--!native

local LemonSignal = require(script.Parent.Dependencies.LemonSignal)
local Types = {}


--[[ Ace Class ]]--
-- extends into almost every class
-- contains base information for classes

Types.AceClass = {
    ClassName = "AceClass"
}
export type _AceClass = {
	ClassName : string,
	New : (self : any, ...any?) -> (any?)?
}


--[[ Ace Enum ]]--
-- enumerations for the game

local AceEnum = {
    ClassName = "AceEnum"
}
export type _AceEnum = _AceClass & {
	Name : string,
	Enums : { [number]: _AceEnumItem }
}


export type _AceEnumItem = _AceClass & {
	Name : string,
	Value : number,
	EnumType : AceEnum
}


export type _AceWeapon = _AceClass & {
	Name : string,
	Id : string,
	Entity : _AceEntity,

	Fire : (_AceWeapon) -> (_AceProjectile),
    Fired: LemonSignal.Signal<_AceProjectile>
}


export type _AceProjectile = _AceClass & {
	Name : string,
	Weapon : _AceWeapon,
    Id: string,
	Info : _AceProjectileInfo,
    Hit : LemonSignal.Signal<Part>
}


export type _AceProjectileInfo = _AceClass & {
	
}


export type _AceEntity = _AceClass & {
	Player: Player,

	Weapons: { [number]: _AceWeapon },
    Info: _AceEntityInfo,

	Killed: LemonSignal.Signal<_AceEntity, _AceEntity, _AceWeapon>,
	Suicided: LemonSignal.Signal<_AceEntity>
}

export type _AceEntityInfo = _AceClass & {
    Metadata: { [string]: any }?
}


export type _AceExplosionInfo = _AceClass & {
    FilterType : Enum.RaycastFilterType,
    Filter : { [number] : Instance },

    OriginEntity : _AceEntity?,
	OriginProjectile : _AceProjectile,

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
    FireInfo : _AceFireInfo?,
}


export type _AceFireInfo = _AceClass & {
    Color : Color3 | BrickColor?,
    Transparency : number?,

    OriginEntity : _AceEntity?,

    Damage : number,
    TickTime : number,
    TotalTime : number,
}


export type _AceExplosion = _AceClass & {
    Info : _AceExplosionInfo
}


export type _AceFire = _AceClass & {
	Info : _AceFireInfo
}


return {}