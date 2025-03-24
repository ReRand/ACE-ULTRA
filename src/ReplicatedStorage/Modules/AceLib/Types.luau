--!optimize 2
--!nocheck
--!native

local LemonSignal = require(script.Parent.Dependencies.LemonSignal)
local Types = {
    Enums = {}
}

--[[ Ace Class ]]--
-- extends into almost every class
-- contains base information for classes

Types.AceClass = {
    ClassName = "AceClass",
    Extensions = {}
}
export type _AceClass = {
	ClassName : string,
    Extensions: { [number]: string },
    Metadata: { [string]: any },
	New : (self : any, ...any?) -> (any?)?,
    Destroy : (self : any) -> nil
}


export type _AceEntity<T> = _AceClass & {
    Base: T,
    IsPlayer: boolean,
    Player: Player?
    Character: Model?

	Weapons: { [number]: _AceWeapon },
    Perks: { [number]: _AcePerk },
    Info: _AceEntityInfo,

	Killed: LemonSignal.Signal<_AceEntity, _AceEntity, _AceWeapon>,
	Suicided: LemonSignal.Signal<_AceEntity>
}

export type _AceEntityInfo = _AceClass & {
    Metadata: { [string]: any }?
}


--[[ Ace Weapon ]]--
-- weapons like guns or melee

Types.AceWeapon = {
    ClassName = "AceWeapon"
}
export type _AceWeapon = _AceClass & {
	Name : string,
	Id : string,
	ParentEntity : _AceEntity,
    Projectiles: { [int], _AceProjectile },

	Fire : (_AceWeapon) -> (_AceProjectile),
    Fired: LemonSignal.Signal<_AceProjectile>
}


--[[ Ace Projectile ]]--
-- projectiles fired from weapons

Types.AceEnumItem = {
    ClassName = "AceEnumItem"
}
export type _AceProjectile = _AceClass & {
	Name : string,
    Id: string,

	Info : _AceProjectileInfo,

    Hit : LemonSignal.Signal<Part>
}


export type _AceProjectileInfo = _AceClass & {
	
}

Types.AceExplosionInfo = {
    ClassName = "AceExplosionInfo",
    FilterType = Enum.RaycastFilterType.Exclude,
    Filter = {},

    OriginEntity = nil,

    MultiHit = false,
    FuseTime = nil,
    Knockback = true,
    KnockbackMultiplier = 5,
    Cooldown = 1,
    Velocity = 300,
    SetDamage = nil,
    FallVelocity = 1,

    Radius = 30,
    Color = nil,
    Transparency = nil,

    FireProbability = 1,
    FireInfo = nil

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

Types.AceFireInfo = {
    ClassName = "AceFireInfo",
    Color = nil,
    Transparency = nil,

    OriginEntity = nil,

    FireProbability = 1,
    Damage = 1,
    TickTime = 1,
    TotalTime = 5,

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


--[[ Ace Enum ]]--
-- enumerations for the game

Types.AceEnum = {}

function Types.AceEnum.New<T>(items: {}) : T
    local t = {}
    for k, v in items do
        if typeof(items[v]) == "string" then
            table.insert(t, v);
        else
            t[v] = k
        end
    end
    return t : T
end

export type _AceEnum = { [string]: number }
export type _ProjectileType = _AceEnum & {}
export type _PerkType = _AceEnum & {}

Types.Enums.ProjectileType: _ProjectileType = Types.AceEnum.New<_ProjectileType>({
    [1] = "Bullet"
})

Types.Enums.PerkType: _PerkType = Types.AceEnum.New<_PerkType>({
    [1] = "Dash",
    [2] = "Slide",
    [3] = "WallSlide",
    [4] = "WallJump",
    [5] = "Hook"
})

return Types